Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab1C3AvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 20:51:18 -0400
Received: from relay3.sgi.com ([192.48.152.1]:59876 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753806Ab1C3AvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 20:51:17 -0400
Message-ID: <4D927E86.90400@sgi.com>
Date: Tue, 29 Mar 2011 17:51:18 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bitmap, irq: Add smp_affinity_list interface to /proc/irq
References: <4D926F6C.8010705@sgi.com>	<20110329165612.bd6ad7e4.akpm@linux-foundation.org> <20110329174314.80cf7b50.akpm@linux-foundation.org>
In-Reply-To: <20110329174314.80cf7b50.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Tue, 29 Mar 2011 16:56:12 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Tue, 29 Mar 2011 16:46:52 -0700
>> Mike Travis <travis@sgi.com> wrote:
>>
>>> +	/* create /proc/irq/<irq>/smp_affinity_list */
>>> +	proc_create_data("smp_affinity_list", 0600, desc->dir,
>>> +			 &irq_affinity_list_proc_fops, (void *)(long)irq);
>> Always document your interfaces, please.  `grep -r smp_affinity
>> Documentation' shows where.
>>
>> And one we've seen a description of the proposed new interface, we can
>> review the patch!
> 
> Also, the patch adds a new interface which duplicates an existing one,
> only the formats are different, yes?  This is, of course, bad.
> 
> The only justification we've seen for being bad is "Manually adjusting
> the smp_affinity for IRQ's becomes unwieldy when the cpu count is
> large".  A more thorough description of how painful this is might help
> motivate people to do bad things to the kernel.
> 
> Also, if it's just a matter of an alternative presentation of the data,
> why not implement the desired user interface with a little userspace
> tool then feed the results down into the existing kernel interface?
> 

Setting smp affinity to cpus 256 to 263 would be:

echo 000000ff,00000000,00000000,00000000,00000000,00000000,00000000,00000000 > smp_affinity

instead of:

echo 256-263 > smp_affinity_list

Think about what it looks like for cpus around say, 4088 to 4095.

We already have many alternate "list" interfaces:

/sys/devices/system/cpu/cpuX/indexY/shared_cpu_list
/sys/devices/system/cpu/cpuX/topology/thread_siblings_list
/sys/devices/system/cpu/cpuX/topology/core_siblings_list
/sys/devices/system/node/nodeX/cpulist
/sys/devices/pci***/***/local_cpulist

etc.

This just expands on that same philosophy.

Thanks,
Mike
