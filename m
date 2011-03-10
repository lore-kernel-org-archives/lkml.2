Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab1CJJqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 04:46:18 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:25616 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1CJJqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 04:46:16 -0500
Message-ID: <4D789B64.9000603@parallels.com>
Date: Thu, 10 Mar 2011 12:35:32 +0300
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pidns: Make pid_max per namespace
References: <4D6F53B5.5090105@parallels.com> <20110307155823.22e47d73.akpm@linux-foundation.org>
In-Reply-To: <20110307155823.22e47d73.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2011 02:58 AM, Andrew Morton wrote:
> On Thu, 03 Mar 2011 11:39:17 +0300
> Pavel Emelyanov <xemul@parallels.com> wrote:
> 
>> Rationale:
>>
>> On x86_64 with big ram people running containers set pid_max on host to 
>> large values to be able to launch more containers. At the same time 
>> containers running 32-bit software experience problems with large pids - ps
>> calls readdir/stat on proc entries and inode's i_ino happen to be too big 
>> for the 32-bit API.
>>
>> Thus, the ability to limit the pid value inside container is required.
>>
> 
> This is a behavioural change, isn't it?  In current kernels a write to
> /proc/sys/kernel/pid_max will change the max pid on all processes. 
> After this change, that write will only affect processes in the current
> namespace.  Anyone who was depending on the old behaviour might run
> into problems?

Hardly. If the behavior of some two apps depends on its synchronous change,
these two might want to run in the same pid namespace.

> Also: documentation.  Documentation/sysctl/kernel.txt would like an
> update.  And perhaps also the pidns documentation which we forgot to
> create :(

OK, I'll fix the existing docs.

Thanks,
Pavel
