Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab0HXSca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 14:32:30 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44454 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab0HXSc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 14:32:27 -0400
Message-ID: <4C741029.7090300@cs.helsinki.fi>
Date: Tue, 24 Aug 2010 21:32:09 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (slab
 tree related)
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <alpine.DEB.2.00.1008241256280.4763@router.home>
In-Reply-To: <alpine.DEB.2.00.1008241256280.4763@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.8.2010 20.59, Christoph Lameter wrote:
> On Tue, 24 Aug 2010, Pekka Enberg wrote:
>
>> Thanks for the report. The problem should be fixed by this commit:
>
> Its not that easy. __alloc_percpu falls back to kzalloc() on UP and this
> can result in unique bootstrap problems with UP since the bootstrap array
> is no longer there. Does the UP kernel boot?

No, I get this under kvm:

[    0.000000] Linux version 2.6.36-rc2+ (penberg@tiger) (gcc version 
4.4.1 (Ubuntu 4.4.1-4ubuntu9) ) #103 Tue Aug 24 21:27:28 EEST 2010
[    0.000000] Command line: notsc nolapic nosmp noacpi pci=conf1 
earlyprintk=ttyS0,keep
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 00000000000fffff (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000004000000 (usable)
[    0.000000] console [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI not present or invalid.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x4000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
[    0.000000] CPU MTRRs all blank - virtualized system.
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 00000000000fffff (reserved)
[    0.000000]  modified: 0000000000100000 - 0000000004000000 (usable)
[    0.000000] init_memory_mapping: 0000000000000000-0000000004000000
[    0.000000] ACPI Error: A valid RSDP was not found 
(20100702/tbxfroot-219)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1945621, boot clock
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00004000
[    0.000000] No local APIC present
[    0.000000] APIC: disable apic facility
[    0.000000] APIC: switched to apic NOOP
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 
00000000000ff000
[    0.000000] PM: Registered nosave memory: 00000000000ff000 - 
0000000000100000
[    0.000000] Allocating PCI resources starting at 4000000 (gap: 
4000000:fc000000)
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 16047
[    0.000000] Kernel command line: notsc nolapic nosmp noacpi pci=conf1 
earlyprintk=ttyS0,keep
[    0.000000] notsc: Kernel compiled with CONFIG_X86_TSC, cannot 
disable TSC completely.
[    0.000000] PID hash table entries: 256 (order: -1, 2048 bytes)
[    0.000000] Dentry cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.000000] Inode-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (23 early reservations)
[    0.000000]   #0 [0001000000 - 0001b751a0]   TEXT DATA BSS
[    0.000000]   #1 [000009f000 - 0000100000]   BIOS reserved
[    0.000000]   #2 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #3 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #4 [0001b751c0 - 0001b761c0]         BOOTMEM
[    0.000000]   #5 [0001f761c0 - 0001f761d8]         BOOTMEM
[    0.000000]   #6 [0002377000 - 0002378000]         BOOTMEM
[    0.000000]   #7 [0002378000 - 0002379000]         BOOTMEM
[    0.000000]   #8 [0002400000 - 0002600000]        MEMMAP 0
[    0.000000]   #9 [0001b761c0 - 0001b762c0]         BOOTMEM
[    0.000000]   #10 [0001b762c0 - 0001b766c0]         BOOTMEM
[    0.000000]   #11 [0001b77000 - 0001b78000]         BOOTMEM
[    0.000000]   #12 [0001b766c0 - 0001b767d8]         BOOTMEM
[    0.000000]   #13 [0001b76800 - 0001b76868]         BOOTMEM
[    0.000000]   #14 [0001b76880 - 0001b768e8]         BOOTMEM
[    0.000000]   #15 [0001b76900 - 0001b76968]         BOOTMEM
[    0.000000]   #16 [0001b76980 - 0001b769e8]         BOOTMEM
[    0.000000]   #17 [0001b76a00 - 0001b76a20]         BOOTMEM
[    0.000000]   #18 [0001b76a40 - 0001b76a7d]         BOOTMEM
[    0.000000]   #19 [0001b76a80 - 0001b76abd]         BOOTMEM
[    0.000000]   #20 [0001b78000 - 0001b78800]         BOOTMEM
[    0.000000]   #21 [0001b78800 - 0001b88800]         BOOTMEM
[    0.000000]   #22 [0001b88800 - 0001b90800]         BOOTMEM
[    0.000000] Memory: 51156k/65536k available (6550k kernel code, 452k 
absent, 13928k reserved, 3761k data, 764k init)
[    0.000000] Kernel panic - not syncing: Cannot create slab kmem_cache 
size=232 realsize=256 order=0 offset=0 flags=42000
[    0.000000]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.36-rc2+ #103
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81659a35>] panic+0x91/0x19b
[    0.000000]  [<ffffffff81126e59>] kmem_cache_open+0x1e9/0x200
[    0.000000]  [<ffffffff81a3141a>] kmem_cache_init+0x57/0x300
[    0.000000]  [<ffffffff81a14a97>] start_kernel+0x1ca/0x396
[    0.000000]  [<ffffffff81a14325>] x86_64_start_reservations+0x12c/0x130
[    0.000000]  [<ffffffff81a14423>] x86_64_start_kernel+0xfa/0x109

> Why did this ever build on my UP configuration tests? Hmmm... I only
> tested x86_64 UP. This was 32 bit UP I guess.

I could reproduce the build problem with x86-64 and !CONFIG_SMP so it's 
not related to 32-bit.
