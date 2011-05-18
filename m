Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab1ERUlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:41:21 -0400
Received: from smtp.nexicom.net ([216.168.96.13]:37188 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab1ERUlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:41:18 -0400
Message-ID: <4DD42F10.90602@lockie.ca>
Date: Wed, 18 May 2011 16:41:52 -0400
From: James <bjlockie@lockie.ca>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110512 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: help to bisect
References: <4DD31264.4070704@lockie.ca> <20110518072245.GB17608@liondog.tnic>
In-Reply-To: <20110518072245.GB17608@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/11 03:22, Borislav Petkov wrote:
> On Tue, May 17, 2011 at 08:27:16PM -0400, James wrote:
>> How do I build v2.6.36 so I can test it mark it good so I can bisect?
>>
>> Here is what I want to do:
>> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
>> $ cd linux-2.6.37.y
>> $ git bisect start
>> $ git bisect good v2.6.36
>> $ git bisect bad v2.6.37.6
>>
>> Do I do "git checkout v2.6.36"?
> Yes, but you should do it first, before starting bisection. After you've
> verified .36 is fine, then you do the last three commands:
>
>> $ git bisect start
>> $ git bisect good v2.6.36
>> $ git bisect bad v2.6.37.6
> assuming you have verified also that .37.6 is bad, but I guess so,
> otherwise you wouldn't be bisecting in the first place :)
>
> Also, it might make sense to check whether .37 is fine too before
> bisecting. If so, you save yourself quite a bit of bisection runs by
> marking .37 as good instead of .36.
>
> HTH.
>
Here is what I did:

$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
$ cd linux-2.6.37.y
$ git checkout v2.6.36
build and boot kernel
$ cd linux-2.6.37.y
$ git bisect start
$ git bisect good v2.6.36
$ git bisect bad v2.6.37.6

build and boot kernel
git bisect good|bad
repeat

3044100e58c84e133791c8b60a2f5bef69d732e4 is the first bad commit.

I did:
$ git show 3044100e58c84e133791c8b60a2f5bef69d732e4

commit 3044100e58c84e133791c8b60a2f5bef69d732e4
Merge: b515316 67e87f0
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Oct 21 18:52:11 2010 -0700

    Merge branch 'core-memblock-for-linus' of git://git.kernel.org/pub/scm/linux
    
    * 'core-memblock-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git
      x86-64: Only set max_pfn_mapped to 512 MiB if we enter via head_64.S
      xen: Cope with unmapped pages when initializing kernel pagetable
      memblock, bootmem: Round pfn properly for memory and reserved regions
      memblock: Annotate memblock functions with __init_memblock
      memblock: Allow memblock_init to be called early
      memblock/arm: Fix memblock_region_is_memory() typo
      x86, memblock: Remove __memblock_x86_find_in_range_size()
      memblock: Fix wraparound in find_region()
      x86-32, memblock: Make add_highpages honor early reserved ranges
      x86, memblock: Fix crashkernel allocation
      arm, memblock: Fix the sparsemem build
      memblock: Fix section mismatch warnings
      powerpc, memblock: Fix memblock API change fallout
      memblock, microblaze: Fix memblock API change fallout
      x86: Remove old bootmem code
      x86, memblock: Use memblock_memory_size()/memblock_free_memory_size() to g
      x86: Remove not used early_res code
      x86, memblock: Replace e820_/_early string with memblock_
      x86: Use memblock to replace early_res
      x86, memblock: Use memblock_debug to control debug message print out
      ...
    
    Fix up trivial conflicts in arch/x86/kernel/setup.c and kernel/Makefile

How do I find out what change causes the problem?
The problem causes my wireless card not to work.
Other people have similar cards that do work so the problem seems isolated to my hardware but kernel-2.6.36 works so I don't think my hardware is faulty.


