Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1C3BE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 21:04:56 -0400
Received: from relay1.sgi.com ([192.48.179.29]:48296 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753849Ab1C3BEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 21:04:55 -0400
Message-ID: <4D9281B8.1090904@sgi.com>
Date: Tue, 29 Mar 2011 18:04:56 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bitmap, irq: Add smp_affinity_list interface to /proc/irq
References: <4D926F6C.8010705@sgi.com>	<20110329165612.bd6ad7e4.akpm@linux-foundation.org>	<20110329174314.80cf7b50.akpm@linux-foundation.org>	<4D927E86.90400@sgi.com> <20110329175614.0c41ae8c.akpm@linux-foundation.org>
In-Reply-To: <20110329175614.0c41ae8c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Tue, 29 Mar 2011 17:51:18 -0700 Mike Travis <travis@sgi.com> wrote:
> 
>>> Also, the patch adds a new interface which duplicates an existing one,
>>> only the formats are different, yes?  This is, of course, bad.
>>>
>>> The only justification we've seen for being bad is "Manually adjusting
>>> the smp_affinity for IRQ's becomes unwieldy when the cpu count is
>>> large".  A more thorough description of how painful this is might help
>>> motivate people to do bad things to the kernel.
>>>
>>> Also, if it's just a matter of an alternative presentation of the data,
>>> why not implement the desired user interface with a little userspace
>>> tool then feed the results down into the existing kernel interface?
>>>
>> Setting smp affinity to cpus 256 to 263 would be:
>>
>> echo 000000ff,00000000,00000000,00000000,00000000,00000000,00000000,00000000 > smp_affinity
>>
>> instead of:
>>
>> echo 256-263 > smp_affinity_list
>>
>> Think about what it looks like for cpus around say, 4088 to 4095.
>>
>> We already have many alternate "list" interfaces:
>>
>> /sys/devices/system/cpu/cpuX/indexY/shared_cpu_list
>> /sys/devices/system/cpu/cpuX/topology/thread_siblings_list
>> /sys/devices/system/cpu/cpuX/topology/core_siblings_list
>> /sys/devices/system/node/nodeX/cpulist
>> /sys/devices/pci***/***/local_cpulist
>>
>> etc.
>>
>> This just expands on that same philosophy.
> 
> You mean that if someone had written a stupid little tool to convert a
> list of tuples into a bitmap, we wouldn't have needed to add all that
> crap to the kernel?
> 

We actually had a problem where the interface would not take enough characters
to set the irq mask.  (It has since been fixed.)

I don't mind if there's an alternate way to do this if you really feel strongly
about it.  Be nice if it was somehow included but that requires yet way more
infrastructure somewhere else.

How about if I #ifdef CONFIG_MAX_SMP around it?  It's really not needed if
you only have a few cpu's enabled.

[If it was up to me, I'd eliminate the bitmask interfaces and just keep the
list interfaces.  That's the stupid interface that's not needed, and far more
shortsighted.]

Thanks,
Mike


