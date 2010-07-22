Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab0GVWBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:01:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57645 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab0GVWBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:01:46 -0400
Message-ID: <4C48BF7E.80002@kernel.org>
Date: Thu, 22 Jul 2010 15:00:30 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH -v26 00/31] generic changes for memblock
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org> <1279834556.1970.20.camel@pasglop>
In-Reply-To: <1279834556.1970.20.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C48BF90.01A0,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 02:35 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-07-22 at 11:20 -0700, Yinghai Lu wrote:
>> New memblock could be used to replace early_res in x86.
>>
>> Suggested by: David, Ben, and Thomas
>>
>> -v25: update to mainline with kmemleak fix on nobootmem
>>       also rename lmb to memblock alread in mainline
>>
>> -v26: according to Linus and hpa, seperate the big patchset to small ones.
>>
>> This one is rebase of Ben's changeset to current mainline/tip
>>
>> Last 6 are needed for x86 memblock transistion, but change mm/memblock.c
> 
> Are there any change from my original series other than an automated
> rebase ? If yes, let me know as I do plan to do that rebase myself, I
> just haven't got to it yet.
> 
>>
>> [PATCH 01/31] memblock: Rename memblock_region to memblock_type and memblock_property to memblock_region
>> [PATCH 02/31] memblock: No reason to include asm/memblock.h late
>> [PATCH 03/31] memblock: Introduce for_each_memblock() and new accessors, and use it
>> [PATCH 04/31] memblock: Remove nid_range argument, arch provides memblock_nid_range() instead
>> [PATCH 05/31] memblock: Factor the lowest level alloc function
>> [PATCH 06/31] memblock: Expose MEMBLOCK_ALLOC_ANYWHERE
>> [PATCH 07/31] memblock: Introduce default allocation limit and use it to replace explicit ones
>> [PATCH 08/31] memblock: Remove rmo_size, burry it in arch/powerpc where it belongs
>> [PATCH 09/31] memblock: Change u64 to phys_addr_t
>> [PATCH 10/31] memblock: Remove unused memblock.debug struct member
>> [PATCH 11/31] memblock: Remove memblock_type.size and add memblock.memory_size instead
>> [PATCH 12/31] memblock: Move memblock arrays to static storage in memblock.c and make their size a variable
>> [PATCH 13/31] memblock: Add debug markers at the end of the array
>> [PATCH 14/31] memblock: Make memblock_find_region() out of memblock_alloc_region()
>> [PATCH 15/31] memblock: Define MEMBLOCK_ERROR internally instead of using ~(phys_addr_t)0
>> [PATCH 16/31] memblock: Move memblock_init() to the bottom of the file
>> [PATCH 17/31] memblock: split memblock_find_base() out of __memblock_alloc_base()

i folded the patch that make make memblock_find_base() to return MEMBLOCK_ERROR into patch 17
and following one or two patches need to change too accordingly.

>> [PATCH 18/31] memblock: Move functions around into a more sensible order
>> [PATCH 19/31] memblock: Add array resizing support
>> [PATCH 20/31] memblock: Add arch function to control coalescing of memblock memory regions
>> [PATCH 21/31] memblock: Add "start" argument to memblock_find_base()
>> [PATCH 22/31] memblock: NUMA allocate can now use early_pfn_map
>> [PATCH 23/31] memblock: Separate memblock_alloc_nid() and memblock_alloc_try_nid()
>> [PATCH 24/31] memblock: Make memblock_alloc_try_nid() fallback to MEMBLOCK_ALLOC_ANYWHERE
>> [PATCH 25/31] memblock: Add debugfs files to dump the arrays content



>> [PATCH 26/31] memblock: Prepare x86 to use memblock to replace early_res
>> [PATCH 27/31] memblock: Print new doubled array location info
>> [PATCH 28/31] memblock: Export MEMBLOCK_ERROR again
>> [PATCH 29/31] memblock: Prepare to include linux/memblock.h in core file
>> [PATCH 30/31] memblock: Add ARCH_DISCARD_MEMBLOCK to put memblock code to .init
>> [PATCH 31/31] memblock: Add memblock_find_in_range()

please check if you can those 6 into your new branch.

Thanks

Yinghai
