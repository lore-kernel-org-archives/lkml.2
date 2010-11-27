Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab0K0Xv2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 18:51:28 -0500
Received: from mail1.ugh.no ([80.239.42.168]:46111 "EHLO mail1.ugh.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab0K0Xv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 18:51:27 -0500
Message-ID: <4CF1997D.3020501@tomt.net>
Date: Sun, 28 Nov 2010 00:51:25 +0100
From: Andre Tomt <andre@tomt.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: jason.vas.dias@gmail.com
CC: Ben Gamari <bgamari@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: per-chroot clock module ?
References: <201011271821.35039.jason.vas.dias@gmail.com> <874ob2r3w0.fsf@gmail.com> <201011271922.45611.jason.vas.dias@gmail.com>
In-Reply-To: <201011271922.45611.jason.vas.dias@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2010 08:22 PM, Jason Vas Dias wrote:
> RE: why ?
> This would allow one to very easily support websites for totally different timezones , where offsets need not be
> restricted to legal timezone offsets but could encompass years - also nice if you want to run applications whose
> license key has expired .  Also very easy to support multiple instances of cron(1) running in different timezones.
> In any case, the module would ensure that the time the kernel sees internally for all processes is the actual real-time
> clock value; only processes which have their root directory in one of the special chroot directories would get
> a different gettimeofday() or clock_gettime() value .
>
>>
>> It seems like what you want here is simple virtualization. Have you
>> considered KVM? The closest thing to your request currently upstream is
>> containers, although I'm unsure of whether a container can be created
>> with an independent clock. Might be something to look into.
>>
>
> To me, using virtualization to solve this problem is like using a sledgehammer to crack a nut,
> particularly if the optimal performance of the processes running in such chroot environments
> is of paramount importance.

You might want to take a look at Linux-Vserver; it has containers (that 
is, chroot on stereoids) with support for "virtualized time"/clock offset.

Virtualized time is not without downsides, it adds overhead. It will be 
tiny compared to using a sledgehammer of course. The vserver guys puts 
it this way;
"This enables per guest time offsets to allow for adjusting the system 
clock individually per guest. this adds some overhead to the time 
functions and therefore should not be enabled without good reason."

http://linux-vserver.org/

It could be useful to implement such a thing in a "time" namespace, 
making it available to lxc containers and cgroups also.
