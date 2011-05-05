Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab1EEWqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 18:46:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62867 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab1EEWqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 18:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=the2masters.de; s=mail;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nL7IPrwH2NQS8OOJuo565cy8cGC0ztupfOqOxalYbOUjowdfY3XlAZwqjBMJ5n61Yj
         lfWoUa5CKroSpxPfWjgy5LVafOB9U9C+S6qYST84lnq3kIHuAg+qQK/ZeHVcAHTSBU4q
         l91xVp9PI/msDWRiir3i2vWb6YIV7sX2XGMlA=
Message-ID: <4DC328AC.1060906@the2masters.de>
Date: Fri, 06 May 2011 00:46:04 +0200
From: Stefan Hellermann <stefan@the2masters.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: early crash on ancient tablet related to no-bootmem
References: <4DC30251.9040902@the2masters.de> <4DC31D5F.8070209@the2masters.de> <4DC31F72.5050206@kernel.org>
In-Reply-To: <4DC31F72.5050206@kernel.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.05.2011 00:06, schrieb Yinghai Lu:
> 
> can you please boot with "ignore_loglevel debug memblock=debug"?
> 

Here we are:

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
Linux version 2.6.39-rc6+ (stefan@hel-stefan.lan) (gcc version 4.6.0
20110428 (Red Hat 4.6.0-6) (GCC) ) #1 Thu May 5 19:21:50 CEST 2011
BIOS-provided physical RAM map:
 BIOS-88: 0000000000000000 - 000000000009f000 (usable)
 BIOS-88: 0000000000100000 - 0000000000840000 (usable)
bootconsole [earlyser0] enabled
debug: ignoring loglevel setting.
Notice: NX (Execute Disable) protection missing in CPU!
DMI not present or invalid.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==>
(reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x840 max_arch_pfn = 0x100000
    memblock_x86_reserve_range: [0x003a5000-0x003a6fff]              BRK
MEMBLOCK configuration:
 memory size = 0x7cf000
 memory.cnt  = 0x2
 memory[0x0]	[0x00000000010000-0x0000000009efff], 0x8f000 bytes
 memory[0x1]	[0x00000000100000-0x0000000083ffff], 0x740000 bytes
 reserved.cnt  = 0x1
 reserved[0x0]	[0x0000000009f000-0x000000003a6fff], 0x308000 bytes
initial memory mapped : 0 - 00800000
    memblock_x86_reserve_range: [0x0009e000-0x0009efff]       TRAMPOLINE
Base memory trampoline at [c009e000] 9e000 size 4096
init_memory_mapping: 0000000000000000-0000000000840000
 0000000000 - 0000840000 page 4k
kernel direct mapping tables up to 840000 @ 7fa000-800000
    memblock_x86_reserve_range: [0x007fa000-0x007fafff]          PGTABLE
8MB LOWMEM available.
  mapped low ram: 0 - 00840000
  low ram: 0 - 00840000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x00000840
On node 0 totalpages: 1999
free_area_init_node: node 0, pgdat c03555a0, node_mem_map 00000200
  DMA zone: 17 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 1982 pages, LIFO batch:0
BUG: Int 6: CR2   (null)
     EDI c0355868  ESI   (null)  EBP 00000830  ESP c0339f10
     EBX c03555a0  EDX 00000006  ECX 01000000  EAX fffffff4
     err   (null)  EIP c0361b85   CS 00000060  flg 00010082
Stack:   (null) c031d2f2 000007be   (null) c031d2f2 00000003   (null)
(null)
       00000010 00000018 00000002   (null) 00000002 c0361ea8   (null)
(null)
       00000100 00000840 00000001   (null)   (null) c0339f8c c0339fb8
c035e41b
Pid: 0, comm: swapper Not tainted 2.6.39-rc6+ #1
Call Trace:
 [<c036edb5>] ? 0xc036edb5
 [<c0361b85>] ? 0xc0361b85
 [<c0361ea8>] ? 0xc0361ea8
 [<c035e41b>] ? 0xc035e41b
 [<c035986d>] ? 0xc035986d
 [<c0358401>] ? 0xc0358401
