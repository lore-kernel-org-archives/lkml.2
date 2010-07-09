Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab0GIUWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 16:22:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41747 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab0GIUWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 16:22:31 -0400
Message-ID: <4C37841F.4030500@kernel.org>
Date: Fri, 09 Jul 2010 13:18:39 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Conny Seidel <conny.seidel@amd.com>
CC: "Petkov, Borislav" <Borislav.Petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: unable to handle kernel paging request at 40000000 __alloc_memory_core_early+0x147/0x1d6
References: <20100709145415.GC11199@aftab>	<4C3773C4.1010609@kernel.org> <20100709215202.4be679a8@marah.osrc.amd.com>
In-Reply-To: <20100709215202.4be679a8@marah.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C3784ED.0183,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2010 12:52 PM, Conny Seidel wrote:
> Hi,
> 
> On Fri, 9 Jul 2010 15:08:52 -0400
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> On 07/09/2010 07:54 AM, Borislav Petkov wrote:
>>> Hi,
>>>
>>> this is something we're getting during testing on one of our boxes
>>> here, a dual socket Magny-Cours machine. It is oopsing on the addr
>>> variable in __alloc_memory_core_early() after converting it to a
>>> virtual address in order to clear the mem region at it. I've removed
>>> the "#if 0.. #endif" around the printk which dumps the ranges in the
>>> early node map for more info.
>>>
>>> It's latest -git, 32bit build, config is attached.
>>>
>>
>> can not duplicate on all my setup.
>>
>> but look at the code there is limit problem with 32 bit...
>>
>> please check if it will fix the problem.
>>
>> and we will need to rebase early_res to memblock patchset.
>>
>> Thanks
>>
>> Yinghai Lu
>>
> 
> I'm sorry but the patch isn't working.
> 
> Now we are seeing this:
> 
> [    0.000000] BUG: Int 6: CR2 (null)
> [    0.000000]      EDI 00000005  ESI f3e00800  EBP c21afed4  ESP c21afe90
> [    0.000000]      EBX 01000000  EDX 00000006  ECX (null)  EAX fffffff4
> [    0.000000]      err (null)  EIP c2359558   CS 00000060  flg 00010046
> [    0.000000] Stack: fffffff4 (null) 00000001 f3e00000 00000005 00080000 00000001 00000002
> [    0.000000]        000b6800 00000002 f3e00000 00000001 00000002 c21aff0c c2359dd2 (null)
> [    0.000000]        ffe00000 00000004 (null) 00000004 001fafd8 c2943000 (null) 00004e00
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.35-rc4+ #1
> [    0.000000] Call Trace:
> [    0.000000]  [<c1dd39d9>] hlt_loop+0x0/0x3
> [    0.000000]  [<c2359558>] ? free_area_init_node+0x5b1/0x647
> [    0.000000]  [<c2359dd2>] free_area_init_nodes+0x7b5/0x89a
> [    0.000000]  [<c234a2c9>] paging_init+0x1a9/0x1cc
> [    0.000000]  [<c2330325>] setup_arch+0x1414/0x15f7
> [    0.000000]  [<c23510c1>] ? __reserve_early+0x119/0x135
> [    0.000000]  [<c1078c8a>] ? printk+0x36/0x54
> [    0.000000]  [<c232917b>] start_kernel+0x1d0/0xb6f
> [    0.000000]  [<c2328163>] i386_start_kernel+0x163/0x179

can you send out boot log from start?

YH
