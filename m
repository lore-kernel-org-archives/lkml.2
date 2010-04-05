Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab0DEHwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 03:52:19 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:17120 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960Ab0DEHwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 03:52:12 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACEyuUtR8TNa/2dsb2JhbACbSHKyCYUHBA
Message-ID: <4BB99654.4090203@computer.org>
Date: Mon, 05 Apr 2010 09:50:44 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Alexander Konovalenko <alexkon@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Reading entropy_avail file appears to consume entropy
References: <epOXE-4EU-7@gated-at.bofh.it> <b7822cd7-97f3-489e-a16b-686b0419d3f2@k19g2000yqn.googlegroups.com>
In-Reply-To: <b7822cd7-97f3-489e-a16b-686b0419d3f2@k19g2000yqn.googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Konovalenko wrote:
> On Mar 19, Jan Ceuleers wrote:
>> I'm using the 2.6.31 kernel that comes with Ubuntu 9.10.
>>
>> If I
>>
>>    # watch cat /proc/sys/kernel/random/entropy_avail
>>
>> then the size of the entropy pool falls rapidly (by more than 200 bytes per 2s interval).
>> It settles down around 160 bytes.
> 
> Jan, did you find out anything interesting about this issue?
> 
> I have a wild guess, although I have no idea whether it can be
> correct. I couldn't catch any user-space /dev/random or /dev/urandom
> readers with fuser, so I think something in the kernel is using up the
> entropy. If I remember correctly, recent Ubuntu releases were supposed
> to include a security feature that randomizes memory layout in order
> to mitigate some kinds of security vulnerabilities. What if each time
> a new process is started the kernel needs to obtain a significant
> number of random bytes? Here is some supporting evidence. I can
> reproduce the behavior you describe on a vanilla Ubuntu 9.10 system
> (without latest updates). But if I watch entropy_avail using a Python
> script that does not start a new process every time, then the
> available entropy amount won't decrease. (The system is otherwise
> idle.) Give it a try:
> 
> $ python
> import sys, time
> while True:
>   sys.stdout.write(open('/proc/sys/kernel/random/entropy_avail',
> 'r').read())
>   time.sleep(1)
> 
> It would be great if someone with knowledge about this could confirm
> or refute my guess.
> 
>  -- Alexander
> 

Alexander,

Thanks, this never made it out to LKML so I'm forwarding it now.

This does sound quite plausible; does anyone from Ubuntu want to chip in?

Thanks, Jan
