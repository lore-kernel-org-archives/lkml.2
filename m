Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab0HYUMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 16:12:21 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:41817 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753660Ab0HYUMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 16:12:15 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: PXb0494VM1lXokv795Y7gi8ynnsxQ.MJmwyJrLqQ0osDhQk
 LtOrmLIOoyEEmEi6ZKBLCVjv1iihfzYOyE6nP3UcnnRvhOnnpYHa61DLP1O.
 RcrnqENY2pzh8tmTPd36_y7aGv21WrpiHozK1dnFbxU7eBg8QkKDQO_LmX5d
 8FLyFm_lrvZnLmWdRg3vz5RoD_lQA21Bm8mH4xk_npGPa7_mvjuedk9ny.Z8
 c
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 25 Aug 2010 15:12:10 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (slab
 tree related)
In-Reply-To: <4C74D1D7.4080608@kernel.org>
Message-ID: <alpine.DEB.2.00.1008251509080.22117@router.home>
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <alpine.DEB.2.00.1008241256280.4763@router.home> <4C741029.7090300@cs.helsinki.fi> <alpine.DEB.2.00.1008241352240.5388@router.home> <4C74D1D7.4080608@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, Tejun Heo wrote:

> Eh... nasty.  Maybe we can create a alloc_percpu_early() function
> which doesn't allow freeing of allocate memory and just redirect to
> bootmem on UP?

The whole early alloc stuff does also does not go over too well with the
page allocator (never had trouble on KVM):

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.36-rc2 (root@rd-rsync) (gcc version 4.4.4 (Debian
4.4.4-5) ) #1 SMP Wed Aug 25 13:26:59 CDT 2010
Command line: ro root=/dev/mapper/vgubuntu-root console=tty0
console=ttyS1,57600 idle=mwait earlyprintk=ttyS1,57600
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 0000000000100000 - 00000000cf699000 (usable)
 BIOS-e820: 00000000cf699000 - 00000000cf6af000 (reserved)
 BIOS-e820: 00000000cf6af000 - 00000000cf6ce000 (ACPI data)
 BIOS-e820: 00000000cf6ce000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fe000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000001b0000000 (usable)
bootconsole [earlyser0] enabled
NX (Execute Disable) protection: active
DMI 2.6 present.
No AGP bridge found
last_pfn = 0x1b0000 max_arch_pfn = 0x400000000
last_pfn = 0xcf699 max_arch_pfn = 0x400000000
found SMP MP-table at [ffff8800000fe710] fe710
init_memory_mapping: 0000000000000000-00000000cf699000
init_memory_mapping: 0000000100000000-00000001b0000000
RAMDISK: 37b98000 - 37ff0000
ACPI: RSDP 00000000000f1630 00024 (v02 DELL  )
ACPI: XSDT 00000000000f1734 0009C (v01 DELL   PE_SC3   00000001 DELL
00000001)
ACPI: FACP 00000000cf6c3f9c 000F4 (v03 DELL   PE_SC3   00000001 DELL
00000001)
ACPI: DSDT 00000000cf6af000 0320F (v01 DELL   PE_SC3   00000001 INTL
20050624)
ACPI: FACS 00000000cf6c6000 00040
ACPI: APIC 00000000cf6c3478 0015E (v01 DELL   PE_SC3   00000001 DELL
00000001)
ACPI: SPCR 00000000cf6c35d8 00050 (v01 DELL   PE_SC3   00000001 DELL
00000001)
ACPI: HPET 00000000cf6c362c 00038 (v01 DELL   PE_SC3   00000001 DELL
00000001)
ACPI: DM__ 00000000cf6c3668 001A8 (v01 DELL   PE_SC3   00000001 DELL
00000001)
ACPI: MCFG 00000000cf6c38c4 0003C (v01 DELL   PE_SC3   00000001 DELL
00000001)
ACPI: WD__ 00000000cf6c3904 00134 (v01 DELL   PE_SC3   00000001 DELL
00000001)
ACPI: SLIC 00000000cf6c3a3c 00176 (v01 DELL   PE_SC3   00000001 DELL
00000001)
ACPI: ERST 00000000cf6b2390 00270 (v01 DELL   PE_SC3   00000001 DELL
00000001)
ACPI: HEST 00000000cf6b2600 0027C (v01 DELL   PE_SC3   00000001 DELL
00000001)
ACPI: BERT 00000000cf6b2210 00030 (v01 DELL   PE_SC3   00000001 DELL
00000001)
ACPI: EINJ 00000000cf6b2240 00150 (v01 DELL   PE_SC3   00000001 DELL
00000001)
ACPI: SRAT 00000000cf6c3bc0 00370 (v01 DELL   PE_SC3   00000001 DELL
00000001)
ACPI: TCPA 00000000cf6c3f34 00064 (v02 DELL   PE_SC3   00000001 DELL
00000001)
ACPI: SSDT 00000000cf6c7000 04BE4 (v01  INTEL PPM RCM  80000001 INTL
20061109)
SRAT: PXM 1 -> APIC 0x10 -> Node 0
SRAT: PXM 2 -> APIC 0x00 -> Node 1
SRAT: PXM 1 -> APIC 0x12 -> Node 0
SRAT: PXM 2 -> APIC 0x02 -> Node 1
SRAT: PXM 1 -> APIC 0x14 -> Node 0
SRAT: PXM 2 -> APIC 0x04 -> Node 1
SRAT: PXM 1 -> APIC 0x16 -> Node 0
SRAT: PXM 2 -> APIC 0x06 -> Node 1
SRAT: PXM 1 -> APIC 0x11 -> Node 0
SRAT: PXM 2 -> APIC 0x01 -> Node 1
SRAT: PXM 1 -> APIC 0x13 -> Node 0
SRAT: PXM 2 -> APIC 0x03 -> Node 1
SRAT: PXM 1 -> APIC 0x15 -> Node 0
SRAT: PXM 2 -> APIC 0x05 -> Node 1
SRAT: PXM 1 -> APIC 0x17 -> Node 0
SRAT: PXM 2 -> APIC 0x07 -> Node 1
SRAT: Node 1 PXM 2 0-c0000000
SRAT: Node 0 PXM 1 c0000000-d0000000
SRAT: Node 0 PXM 1 100000000-1b0000000
SRAT: Node 0 [c0000000,d0000000) + [100000000,1b0000000) ->
[c0000000,1b0000000)
Initmem setup node 0 00000000c0000000-00000001b0000000
  NODE_DATA [0000000100000000 - 0000000100004fff]
Initmem setup node 1 0000000000000000-00000000c0000000
  NODE_DATA [00000000016ee780 - 00000000016f377f]
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x001b0000
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    1: 0x00000001 -> 0x000000a0
    1: 0x00000100 -> 0x000c0000
    0: 0x000c0000 -> 0x000cf699
    0: 0x00100000 -> 0x001b0000
------------[ cut here ]------------
WARNING: at mm/percpu.c:285 pcpu_mem_alloc+0x31/0x78()
Hardware name: PowerEdge R610
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.36-rc2 #1
Call Trace:
 [<ffffffff810305fa>] warn_slowpath_common+0x80/0x98
 [<ffffffff81030627>] warn_slowpath_null+0x15/0x17
 [<ffffffff810a226c>] pcpu_mem_alloc+0x31/0x78
 [<ffffffff810a2fe1>] pcpu_alloc+0x243/0x8d9
 [<ffffffff81030c85>] ? release_console_sem+0x185/0x1b6
 [<ffffffff810a3692>] __alloc_percpu+0xb/0xd
 [<ffffffff81601d6f>] free_area_init_node+0x235/0x350
 [<ffffffff815e9c65>] free_area_init_nodes+0x4c1/0x50b
 [<ffffffff815eb13c>] ? sparse_init+0x292/0x2cf
 [<ffffffff815e2d50>] paging_init+0x53/0x5a
 [<ffffffff815d642f>] setup_arch+0x82c/0x8b8
 [<ffffffff813ad816>] ? printk+0x3c/0x3e
 [<ffffffff8104f548>] ? clockevents_register_notifier+0x3e/0x4a
 [<ffffffff815d29df>] start_kernel+0x88/0x351
 [<ffffffff815d22a3>] x86_64_start_reservations+0xb3/0xb7
 [<ffffffff815d238b>] x86_64_start_kernel+0xe4/0xeb
---[ end trace 4eaa2a86a8e2da22 ]---
PERCPU: allocation failed, size=96 align=8, failed to allocate new chunk
Pid: 0, comm: swapper Tainted: G        W   2.6.36-rc2 #1
Call Trace:
 [<ffffffff810a35ca>] pcpu_alloc+0x82c/0x8d9
 [<ffffffff81030c85>] ? release_console_sem+0x185/0x1b6
 [<ffffffff810a3692>] __alloc_percpu+0xb/0xd
 [<ffffffff81601d6f>] free_area_init_node+0x235/0x350
 [<ffffffff815e9c65>] free_area_init_nodes+0x4c1/0x50b
 [<ffffffff815eb13c>] ? sparse_init+0x292/0x2cf
 [<ffffffff815e2d50>] paging_init+0x53/0x5a
 [<ffffffff815d642f>] setup_arch+0x82c/0x8b8
 [<ffffffff813ad816>] ? printk+0x3c/0x3e
 [<ffffffff8104f548>] ? clockevents_register_notifier+0x3e/0x4a
 [<ffffffff815d29df>] start_kernel+0x88/0x351
 [<ffffffff815d22a3>] x86_64_start_reservations+0xb3/0xb7
 [<ffffffff815d238b>] x86_64_start_kernel+0xe4/0xeb
---[ end trace 4eaa2a86a8e2da22 ]---
PERCPU: allocation failed, size=96 align=8, failed to allocate new chunk
Pid: 0, comm: swapper Tainted: G        W   2.6.36-rc2 #1
Call Trace:
 [<ffffffff810a35ca>] pcpu_alloc+0x82c/0x8d9
 [<ffffffff81030c85>] ? release_console_sem+0x185/0x1b6
 [<ffffffff810a3692>] __alloc_percpu+0xb/0xd
 [<ffffffff81601d6f>] free_area_init_node+0x235/0x350
 [<ffffffff815e9c65>] free_area_init_nodes+0x4c1/0x50b
 [<ffffffff815eb13c>] ? sparse_init+0x292/0x2cf
 [<ffffffff815e2d50>] paging_init+0x53/0x5a
 [<ffffffff815d642f>] setup_arch+0x82c/0x8b8
 [<ffffffff813ad816>] ? printk+0x3c/0x3e
 [<ffffffff8104f548>] ? clockevents_register_notifier+0x3e/0x4a
 [<ffffffff815d29df>] start_kernel+0x88/0x351
 [<ffffffff815d22a3>] x86_64_start_reservations+0xb3/0xb7
 [<ffffffff815d238b>] x86_64_start_kernel+0xe4/0xeb
PERCPU: allocation failed, size=96 align=8, failed to allocate new chunk
Pid: 0, comm: swapper Tainted: G        W   2.6.36-rc2 #1
Call Trace:
 [<ffffffff810a35ca>] pcpu_alloc+0x82c/0x8d9
 [<ffffffff81030c85>] ? release_console_sem+0x185/0x1b6
 [<ffffffff810a3692>] __alloc_percpu+0xb/0xd
 [<ffffffff81601d6f>] free_area_init_node+0x235/0x350
 [<ffffffff815e9c65>] free_area_init_nodes+0x4c1/0x50b
 [<ffffffff815eb13c>] ? sparse_init+0x292/0x2cf
 [<ffffffff815e2d50>] paging_init+0x53/0x5a
 [<ffffffff815d642f>] setup_arch+0x82c/0x8b8
 [<ffffffff813ad816>] ? printk+0x3c/0x3e
 [<ffffffff8104f548>] ? clockevents_register_notifier+0x3e/0x4a

