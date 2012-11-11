Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab2KKX03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 18:26:29 -0500
Received: from rrcs-24-173-105-85.sw.biz.rr.com ([24.173.105.85]:36743 "EHLO
	mx1.mthode.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab2KKX00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 18:26:26 -0500
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Nov 2012 18:26:25 EST
Message-ID: <50A03281.6040206@gentoo.org>
Date: Sun, 11 Nov 2012 17:19:29 -0600
From: Matthew Thode <prometheanfire@gentoo.org>
Reply-To: prometheanfire@gentoo.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121030 Thunderbird/16.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: bhelgaas@google.com, linux-pci@vger.kernel.org, mthode@mthode.org,
        iommu@lists.linux-foundation.org
Subject: [BUG 3.7-rc5] NULL pointer deref when using a pcie-pci bridged pci
 device and intel-iommu
X-Enigmail-Version: 1.5a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD6F4FF116F9EF02826A8BF54"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD6F4FF116F9EF02826A8BF54
Content-Type: multipart/mixed;
 boundary="------------090205050801070509070204"

This is a multi-part message in MIME format.
--------------090205050801070509070204
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

System boots with vt-d disabled in bios. Otherwise I get the errors in
the attached log.  I can do whatever testing you need as this system is
not in production yet.  gonna paste the important part here.  Let me
know if you want anything else.

Please CC me directly as I am not subscribed to the LKML.


Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 5124k freed
IOMMU 0 0xfbffe000: using Queued invalidation
IOMMU: Setting RMRR:
IOMMU: Setting identity map for device 0000:00:1d.0 [0xbf7ec000 -
0xbf7fffff]
IOMMU: Setting identity map for device 0000:00:1d.1 [0xbf7ec000 -
0xbf7fffff]
IOMMU: Setting identity map for device 0000:00:1d.2 [0xbf7ec000 -
0xbf7fffff]
IOMMU: Setting identity map for device 0000:00:1d.7 [0xbf7ec000 -
0xbf7fffff]
IOMMU: Setting identity map for device 0000:00:1a.0 [0xbf7ec000 -
0xbf7fffff]
IOMMU: Setting identity map for device 0000:00:1a.1 [0xbf7ec000 -
0xbf7fffff]
IOMMU: Setting identity map for device 0000:00:1a.2 [0xbf7ec000 -
0xbf7fffff]
IOMMU: Setting identity map for device 0000:00:1a.7 [0xbf7ec000 -
0xbf7fffff]
IOMMU: Setting identity map for device 0000:00:1d.0 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1d.1 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1d.2 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1d.7 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1a.0 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1a.1 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1a.2 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1a.7 [0xec000 - 0xeffff]
IOMMU: Prepare 0-16MiB unity mapping for LPC
IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
BUG: unable to handle kernel NULL pointer dereference at 000000000000003c=

IP: [<ffffffff813bd796>] pci_get_dma_source+0xf/0x41
PGD 0
Oops: 0000 [#1] SMP
Modules linked in:
CPU 7
Pid: 1, comm: swapper/0 Not tainted 3.7.0-rc5 #1 Penguin Computing
Relion 1751/X8DTU
RIP: 0010:[<ffffffff813bd796>]  [<ffffffff813bd796>]
pci_get_dma_source+0xf/0x41
RSP: 0000:ffff8806264d1d88  EFLAGS: 00010282
RAX: ffffffff813bd3a8 RBX: ffff8806261d1000 RCX: 00000000e8221180
RDX: ffffffff818624f0 RSI: ffff88062635b0c0 RDI: 0000000000000000
RBP: ffff8806264d1d88 R08: ffff8806263d6000 R09: 00000000ffffffff
R10: ffff8806264d1ca8 R11: 0000000000000005 R12: 0000000000000000
R13: ffff8806261d1098 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88063f2e0000(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000000003c CR3: 0000000001c0b000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 1, threadinfo ffff8806264d0000, task
ffff8806264cf910)
Stack:
 ffff8806264d1dc8 ffffffff815d02c9 0000000000000000 ffff880600000000
 ffff8806264d1dd8 ffffffff81c64b00 ffff8806261d1098 ffff8806264d1df8
 ffff8806264d1de8 ffffffff815cd5a4 ffffffff81c64b00 ffffffff815cd56a
Call Trace:
 [<ffffffff815d02c9>] intel_iommu_add_device+0x95/0x167
 [<ffffffff815cd5a4>] add_iommu_group+0x3a/0x41
 [<ffffffff815cd56a>] ? bus_set_iommu+0x44/0x44
 [<ffffffff8145eca1>] bus_for_each_dev+0x54/0x81
 [<ffffffff815cd563>] bus_set_iommu+0x3d/0x44
 [<ffffffff81cd3fa3>] intel_iommu_init+0xae5/0xb5e
 [<ffffffff81ca0277>] ? free_initrd+0x9e/0x9e
 [<ffffffff81ca4248>] ? memblock_find_dma_reserve+0x13f/0x13f
 [<ffffffff81ca425e>] pci_iommu_init+0x16/0x41
 [<ffffffff81cc4140>] ? pci_proc_init+0x6b/0x6b
 [<ffffffff81000231>] do_one_initcall+0x7a/0x129
 [<ffffffff816dac14>] kernel_init+0x139/0x2a2
 [<ffffffff81c9d4c7>] ? loglevel+0x31/0x31
 [<ffffffff816daadb>] ? rest_init+0x6f/0x6f
 [<ffffffff816f66ac>] ret_from_fork+0x7c/0xb0
 [<ffffffff816daadb>] ? rest_init+0x6f/0x6f
Code: ff c1 75 04 ff d0 eb 12 48 83 c2 10 48 8b 42 08 48 85 c0 75 d3 b8
e7 ff ff ff c9 c3 55 48 c7 c2 f0 24 86 81 48 89 e5 eb 24 8b 0a <66> 3b
4f 3c 74 05 66 ff c1 75 13 66 8b 4a 02 66 3b 4f 3e 74 05
RIP  [<ffffffff813bd796>] pci_get_dma_source+0xf/0x41
 RSP <ffff8806264d1d88>
CR2: 000000000000003c
---[ end trace 5c5a2ceca067e0ec ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=3D0x00000009=


------------[ cut here ]------------
WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x25/0x5=
1()
Hardware name: Relion 1751
Modules linked in:
Pid: 1, comm: swapper/0 Tainted: G      D      3.7.0-rc5 #1
Call Trace:
 <IRQ>  [<ffffffff810968ee>] warn_slowpath_common+0x80/0x98
 [<ffffffff8109691b>] warn_slowpath_null+0x15/0x17
 [<ffffffff8104e1a3>] native_smp_send_reschedule+0x25/0x51
 [<ffffffff810bc81b>] trigger_load_balance+0x1e8/0x214
 [<ffffffff810b731f>] scheduler_tick+0xd8/0xe1
 [<ffffffff810a132f>] update_process_times+0x62/0x73
 [<ffffffff810cb78b>] tick_sched_timer+0x7c/0x9b
 [<ffffffff810b0f83>] __run_hrtimer.clone.24+0x4e/0xc1
 [<ffffffff810b15b0>] hrtimer_interrupt+0xc7/0x1ac
 [<ffffffff8104ef01>] smp_apic_timer_interrupt+0x81/0x94
 [<ffffffff816f71ca>] apic_timer_interrupt+0x6a/0x70
 <EOI>  [<ffffffff81097ffc>] ? console_unlock+0x2c2/0x2ed
 [<ffffffff816f32fc>] ? panic+0x189/0x1c5
 [<ffffffff816f3261>] ? panic+0xee/0x1c5
 [<ffffffff8109ab6b>] do_exit+0x357/0x7b2
 [<ffffffff810371b8>] oops_end+0xb2/0xba
 [<ffffffff8105841d>] no_context+0x266/0x275
 [<ffffffff810585e7>] __bad_area_nosemaphore+0x1bb/0x1db
 [<ffffffff8118de46>] ? sysfs_addrm_finish+0x2f/0xa6
 [<ffffffff81058615>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81058bdb>] __do_page_fault+0x360/0x39f
 [<ffffffff81394afa>] ? ida_get_new_above+0xf9/0x19e
 [<ffffffff8112a077>] ? slab_node+0x59/0xa2
 [<ffffffff816f3ffd>] ? mutex_unlock+0x9/0xb
 [<ffffffff816da653>] ? klist_put+0x4c/0x70
 [<ffffffff816da581>] ? klist_next+0x30/0xb6
 [<ffffffff813b8cf9>] ? pci_do_find_bus+0x49/0x49
 [<ffffffff81058c42>] do_page_fault+0x9/0xb
 [<ffffffff816f6232>] page_fault+0x22/0x30
 [<ffffffff813bd3a8>] ? nv_msi_ht_cap_quirk_all+0x10/0x10
 [<ffffffff813bd796>] ? pci_get_dma_source+0xf/0x41
 [<ffffffff815d02c9>] intel_iommu_add_device+0x95/0x167
 [<ffffffff815cd5a4>] add_iommu_group+0x3a/0x41
 [<ffffffff815cd56a>] ? bus_set_iommu+0x44/0x44
 [<ffffffff8145eca1>] bus_for_each_dev+0x54/0x81
 [<ffffffff815cd563>] bus_set_iommu+0x3d/0x44
 [<ffffffff81cd3fa3>] intel_iommu_init+0xae5/0xb5e
 [<ffffffff81ca0277>] ? free_initrd+0x9e/0x9e
 [<ffffffff81ca4248>] ? memblock_find_dma_reserve+0x13f/0x13f
 [<ffffffff81ca425e>] pci_iommu_init+0x16/0x41
 [<ffffffff81cc4140>] ? pci_proc_init+0x6b/0x6b
 [<ffffffff81000231>] do_one_initcall+0x7a/0x129
 [<ffffffff816dac14>] kernel_init+0x139/0x2a2
 [<ffffffff81c9d4c7>] ? loglevel+0x31/0x31
 [<ffffffff816daadb>] ? rest_init+0x6f/0x6f
 [<ffffffff816f66ac>] ret_from_fork+0x7c/0xb0
 [<ffffffff816daadb>] ? rest_init+0x6f/0x6f
---[ end trace 5c5a2ceca067e0ed ]---

--=20
-- Matthew Thode (prometheanfire)

--------------090205050801070509070204
Content-Type: text/plain; charset=UTF-8;
 name="3.7.0-rc5.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="3.7.0-rc5.log"

Initializing cgroup subsys cpuset
Linux version 3.7.0-rc5 (root@vm-master-01) (gcc version 4.5.4 (Gentoo Ha=
rdened 4.5.4 p1.0, pie-0.4.7) ) #1 SMP Sun Nov 11 13:51:19 CST 2012
Command line: rootfstype=3Dext4 real_root=3D/dev/mapper/vg-rootfs real_ro=
otflags=3Dnoatime,nodev,acl,user_xattr crypt_root=3DUUID=3D4b11f604-66b2-=
4673-a50d-d88e5fc9a8b3 domdadm dolvm=20
netconsole=3D4444@10.10.2.2/eth0,4444@10.10.2.1/4e:9c:bc:82:6d:d6;netcons=
ole=3D4444@10.10.2.2/eth1,4444@10.10.2.1/4e:9c:bc:82:6d:d6;netconsole=3D4=
444@10.10.2.2/eth2,4444@10.10.2.1/4e:9c:bc:82:6d:d6 console=3DttyS0,11520=
0n8 ro
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x0000000000097bff] usable
BIOS-e820: [mem 0x0000000000097c00-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x00000000bf77ffff] usable
BIOS-e820: [mem 0x00000000bf78e000-0x00000000bf78ffff] type 9
BIOS-e820: [mem 0x00000000bf790000-0x00000000bf79dfff] ACPI data
BIOS-e820: [mem 0x00000000bf79e000-0x00000000bf7cffff] ACPI NVS
BIOS-e820: [mem 0x00000000bf7d0000-0x00000000bf7dffff] reserved
BIOS-e820: [mem 0x00000000bf7ec000-0x00000000bfffffff] reserved
BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000063fffffff] usable
NX (Execute Disable) protection: active
DMI present.
No AGP bridge found
e820: last_pfn =3D 0x640000 max_arch_pfn =3D 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820: last_pfn =3D 0xbf780 max_arch_pfn =3D 0x400000000
found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000f=
f780]
init_memory_mapping: [mem 0x00000000-0xbf77ffff]
init_memory_mapping: [mem 0x100000000-0x63fffffff]
RAMDISK: [mem 0x37aef000-0x37feffff]
ACPI: RSDP 00000000000face0 00024 (v02 ACPIAM)
ACPI: XSDT 00000000bf790100 00084 (v01 SMCI            20120803 MSFT 0000=
0097)
ACPI: FACP 00000000bf790290 000F4 (v04 080312 FACP1521 20120803 MSFT 0000=
0097)
ACPI: DSDT 00000000bf7906a0 06580 (v02  10600 10600000 00000000 INTL 2005=
1117)
ACPI: FACS 00000000bf79e000 00040
ACPI: APIC 00000000bf790390 0011E (v02 080312 APIC1521 20120803 MSFT 0000=
0097)
ACPI: MCFG 00000000bf7904b0 0003C (v01 080312 OEMMCFG  20120803 MSFT 0000=
0097)
ACPI: SLIT 00000000bf7904f0 00030 (v01 080312 OEMSLIT  20120803 MSFT 0000=
0097)
ACPI: OEMB 00000000bf79e040 00086 (v01 080312 OEMB1521 20120803 MSFT 0000=
0097)
ACPI: HPET 00000000bf79a6a0 00038 (v01 080312 OEMHPET  20120803 MSFT 0000=
0097)
ACPI: DMAR 00000000bf79e0d0 00130 (v01    AMI  OEMDMAR 00000001 MSFT 0000=
0097)
ACPI: SSDT 00000000bf79fe40 00363 (v01 DpgPmm    CpuPm 00000012 INTL 2005=
1117)
ACPI: EINJ 00000000bf79a6e0 00130 (v01  AMIER AMI_EINJ 20120803 MSFT 0000=
0097)
ACPI: BERT 00000000bf79a870 00030 (v01  AMIER AMI_BERT 20120803 MSFT 0000=
0097)
ACPI: ERST 00000000bf79a8a0 001B0 (v01  AMIER AMI_ERST 20120803 MSFT 0000=
0097)
ACPI: HEST 00000000bf79aa50 000A8 (v01  AMIER ABC_HEST 20120803 MSFT 0000=
0097)
NUMA: Warning: node ids are out of bound, from=3D-1 to=3D-1 distance=3D10=

No NUMA configuration found
Faking a node at [mem 0x0000000000000000-0x000000063fffffff]
Initmem setup node 0 [mem 0x00000000-0x63fffffff]
  NODE_DATA [mem 0x63fffc000-0x63fffffff]
Zone ranges:
  DMA      [mem 0x00010000-0x00ffffff]
  DMA32    [mem 0x01000000-0xffffffff]
  Normal   [mem 0x100000000-0x63fffffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00010000-0x00096fff]
  node   0: [mem 0x00100000-0xbf77ffff]
  node   0: [mem 0x100000000-0x63fffffff]
ACPI: PM-Timer IO Port: 0x808
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
ACPI: LAPIC (acpi_id[0x11] lapic_id[0x90] disabled)
ACPI: LAPIC (acpi_id[0x12] lapic_id[0x91] disabled)
ACPI: LAPIC (acpi_id[0x13] lapic_id[0x92] disabled)
ACPI: LAPIC (acpi_id[0x14] lapic_id[0x93] disabled)
ACPI: LAPIC (acpi_id[0x15] lapic_id[0x94] disabled)
ACPI: LAPIC (acpi_id[0x16] lapic_id[0x95] disabled)
ACPI: LAPIC (acpi_id[0x17] lapic_id[0x96] disabled)
ACPI: LAPIC (acpi_id[0x18] lapic_id[0x97] disabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec8a000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 32, address 0xfec8a000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
smpboot: Allowing 24 CPUs, 16 hotplug CPUs
PM: Registered nosave memory: 0000000000097000 - 0000000000098000
PM: Registered nosave memory: 0000000000098000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000bf780000 - 00000000bf78e000
PM: Registered nosave memory: 00000000bf78e000 - 00000000bf790000
PM: Registered nosave memory: 00000000bf790000 - 00000000bf79e000
PM: Registered nosave memory: 00000000bf79e000 - 00000000bf7d0000
PM: Registered nosave memory: 00000000bf7d0000 - 00000000bf7e0000
PM: Registered nosave memory: 00000000bf7e0000 - 00000000bf7ec000
PM: Registered nosave memory: 00000000bf7ec000 - 00000000c0000000
PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
PM: Registered nosave memory: 00000000fee01000 - 00000000ffc00000
PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:24 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff88063f200000 s73728 r8192 d20480 u1310=
72
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 6199=
553
Policy zone: Normal
Kernel command line: rootfstype=3Dext4 real_root=3D/dev/mapper/vg-rootfs =
real_rootflags=3Dnoatime,nodev,acl,user_xattr crypt_root=3DUUID=3D4b11f60=
4-66b2-4673-a50d-d88e5fc9a8b3 domdadm dolvm=20
netconsole=3D4444@10.10.2.2/eth0,4444@10.10.2.1/4e:9c:bc:82:6d:d6;netcons=
ole=3D4444@10.10.2.2/eth1,4444@10.10.2.1/4e:9c:bc:82:6d:d6;netconsole=3D4=
444@10.10.2.2/eth2,4444@10.10.2.1/4e:9c:bc:82:6d:d6 console=3DttyS0,11520=
0n8 ro
PID hash table entries: 4096 (order: 3, 32768 bytes)
__ex_table already sorted, skipping sort
Checking aperture...
No AGP bridge found
Memory: 24724712k/26214400k available (7151k kernel code, 1057764k absent=
, 431924k reserved, 5688k data, 620k init)
Hierarchical RCU implementation.
	RCU restricting CPUs from NR_CPUS=3D32 to nr_cpu_ids=3D24.
NR_IRQS:4352 nr_irqs:1280 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [ttyS0] enabled
tsc: Fast TSC calibration failed
tsc: PIT calibration matches HPET. 1 loops
tsc: Detected 2266.735 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.=
=2E 4533.47 BogoMIPS (lpj=3D22667350)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
process: using mwait in idle threads
Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 6
Freeing SMP alternatives: 32k freed
ACPI: Core revision 20120913
dmar: Host address width 40
dmar: DRHD base: 0x000000fbffe000 flags: 0x1
dmar: IOMMU 0: reg_base_addr fbffe000 ver 1:0 cap c90780106f0462 ecap f02=
0fe
dmar: RMRR base: 0x000000000ec000 end: 0x000000000effff
dmar: RMRR base: 0x000000bf7ec000 end: 0x000000bf7fffff
dmar: ATSR flags: 0x0
IOAPIC id 8 under DRHD base  0xfbffe000 IOMMU 0
IOAPIC id 9 under DRHD base  0xfbffe000 IOMMU 0
Enabled IRQ remapping in xapic mode
Switched APIC routing to physical flat.
=2E.TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
smpboot: CPU0: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz (fam: 06, =
model: 1a, stepping: 05)
Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events, Intel PMU dr=
iver.
perf_event_intel: CPU erratum AAJ80 worked around
perf_event_intel: CPUID marked event: 'bus cycles' unavailable
=2E.. version:                3
=2E.. bit width:              48
=2E.. generic registers:      4
=2E.. value mask:             0000ffffffffffff
=2E.. max period:             000000007fffffff
=2E.. fixed-purpose events:   3
=2E.. event mask:             000000070000000f
smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7
Brought up 8 CPUs
smpboot: Total of 8 processors activated (36267.76 BogoMIPS)
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0xbf79e000-0xbf7cffff] (204800 bytes=
)
xor: automatically using best checksumming function:
   generic_sse:  8139.200 MB/sec
NET: Registered protocol family 16
ACPI: bus type pci registered
dca service started, version 1.12.1
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] =
(base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
raid6: sse2x1    5511 MB/s
raid6: sse2x2    6460 MB/s
raid6: sse2x4    7317 MB/s
raid6: using algorithm sse2x4 (7317 MB/s)
raid6: using ssse3x2 recovery algorithm
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: SSDT 00000000bf79e200 015DC (v01 DpgPmm  P001Ist 00000011 INTL 2005=
1117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 015DC (v01 DpgPmm  P001Ist 00000011 INTL 2005=
1117)
ACPI: SSDT 00000000bf79f7e0 00659 (v01  PmRef  P001Cst 00003001 INTL 2005=
1117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00659 (v01  PmRef  P001Cst 00003001 INTL 2005=
1117)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=3Dnocrs"=
 and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window expanded to [mem 0xf0000000-0xfed=
8ffff]; [mem 0xfed40000-0xfed44fff] ignored
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x03b0-0x03bb]
pci_bus 0000:00: root bus resource [io  0x03c0-0x03df]
pci_bus 0000:00: root bus resource [io  0x0d00-0xefff]
pci_bus 0000:00: root bus resource [io  0xf000-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
pci_bus 0000:00: root bus resource [mem 0xc0000000-0xdfffffff]
pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfed8ffff]
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 4700 (mask 00ff)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1640 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:03.0: PCI bridge to [bus 02]
pci 0000:00:05.0: PCI bridge to [bus 03]
pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable =
it with 'pcie_aspm=3Dforce'
pci 0000:00:07.0: PCI bridge to [bus 04-05]
pci 0000:04:00.0: PCI bridge to [bus 05]
pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable =
it with 'pcie_aspm=3Dforce'
pci 0000:00:09.0: PCI bridge to [bus 06]
pci 0000:00:1e.0: PCI bridge to [bus 07] (subtractive decode)
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC control (0x1c) granted
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disable=
d.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 10 11 12 14 15) *0, disable=
d.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *6 7 10 11 12 14 15)
vgaarb: device added: PCI:0000:07:01.0,decodes=3Dio+mem,owns=3Dio+mem,loc=
ks=3Dnone
vgaarb: loaded
vgaarb: bridge control possible 0000:07:01.0
SCSI subsystem initialized
ACPI: bus type scsi registered
ACPI: bus type usb registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Initialized.
PCI: Using ACPI for IRQ routing
PCI: Discovered peer bus ff
PCI host bridge to bus 0000:ff
pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
pci_bus 0000:ff: root bus resource [mem 0x00000000-0xffffffffff]
pci_bus 0000:ff: No busn resource found for root bus, will use [bus ff-ff=
]
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:08: [io  0x0a10-0x0a1f] has been reserved
system 00:0b: [io  0x0ca2-0x0ca3] has been reserved
system 00:0b: [io  0x0cf8-0x0cff] could not be reserved
system 00:0b: [io  0x04d0-0x04d1] has been reserved
system 00:0b: [io  0x0800-0x087f] has been reserved
system 00:0b: [io  0x0500-0x057f] has been reserved
system 00:0b: [mem 0x00000400-0x000004ff] could not be reserved
system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:0b: [mem 0xfed40000-0xfed8ffff] has been reserved
system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:0d: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0e: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0f: [mem 0x000c0000-0x000cffff] could not be reserved
system 00:0f: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0f: [mem 0xfed90000-0xffffffff] could not be reserved
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:01.0:   bridge window [mem 0xfbb00000-0xfbbfffff]
pci 0000:00:03.0: PCI bridge to [bus 02]
pci 0000:00:05.0: PCI bridge to [bus 03]
pci 0000:04:00.0: PCI bridge to [bus 05]
pci 0000:04:00.0:   bridge window [io  0xd000-0xdfff]
pci 0000:04:00.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
pci 0000:00:07.0: PCI bridge to [bus 04-05]
pci 0000:00:07.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:07.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
pci 0000:00:09.0: PCI bridge to [bus 06]
pci 0000:00:09.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:09.0:   bridge window [mem 0xfbd00000-0xfbdfffff]
pci 0000:00:1e.0: PCI bridge to [bus 07]
pci 0000:00:1e.0:   bridge window [mem 0xfaf00000-0xfb7fffff]
pci 0000:00:1e.0:   bridge window [mem 0xf9000000-0xf9ffffff 64bit pref]
NET: Registered protocol family 2
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP: reno registered
UDP hash table entries: 16384 (order: 7, 524288 bytes)
UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:04:00.0: TI XIO2000a quirk detected; secondary bus fast back-to-=
back transfers disabled
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 5124k freed
IOMMU 0 0xfbffe000: using Queued invalidation
IOMMU: Setting RMRR:
IOMMU: Setting identity map for device 0000:00:1d.0 [0xbf7ec000 - 0xbf7ff=
fff]
IOMMU: Setting identity map for device 0000:00:1d.1 [0xbf7ec000 - 0xbf7ff=
fff]
IOMMU: Setting identity map for device 0000:00:1d.2 [0xbf7ec000 - 0xbf7ff=
fff]
IOMMU: Setting identity map for device 0000:00:1d.7 [0xbf7ec000 - 0xbf7ff=
fff]
IOMMU: Setting identity map for device 0000:00:1a.0 [0xbf7ec000 - 0xbf7ff=
fff]
IOMMU: Setting identity map for device 0000:00:1a.1 [0xbf7ec000 - 0xbf7ff=
fff]
IOMMU: Setting identity map for device 0000:00:1a.2 [0xbf7ec000 - 0xbf7ff=
fff]
IOMMU: Setting identity map for device 0000:00:1a.7 [0xbf7ec000 - 0xbf7ff=
fff]
IOMMU: Setting identity map for device 0000:00:1d.0 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1d.1 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1d.2 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1d.7 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1a.0 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1a.1 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1a.2 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1a.7 [0xec000 - 0xeffff]
IOMMU: Prepare 0-16MiB unity mapping for LPC
IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
BUG: unable to handle kernel NULL pointer dereference at 000000000000003c=

IP: [<ffffffff813bd796>] pci_get_dma_source+0xf/0x41
PGD 0=20
Oops: 0000 [#1] SMP=20
Modules linked in:
CPU 7=20
Pid: 1, comm: swapper/0 Not tainted 3.7.0-rc5 #1 Penguin Computing Relion=
 1751/X8DTU
RIP: 0010:[<ffffffff813bd796>]  [<ffffffff813bd796>] pci_get_dma_source+0=
xf/0x41
RSP: 0000:ffff8806264d1d88  EFLAGS: 00010282
RAX: ffffffff813bd3a8 RBX: ffff8806261d1000 RCX: 00000000e8221180
RDX: ffffffff818624f0 RSI: ffff88062635b0c0 RDI: 0000000000000000
RBP: ffff8806264d1d88 R08: ffff8806263d6000 R09: 00000000ffffffff
R10: ffff8806264d1ca8 R11: 0000000000000005 R12: 0000000000000000
R13: ffff8806261d1098 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88063f2e0000(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000000003c CR3: 0000000001c0b000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 1, threadinfo ffff8806264d0000, task ffff8806264c=
f910)
Stack:
 ffff8806264d1dc8 ffffffff815d02c9 0000000000000000 ffff880600000000
 ffff8806264d1dd8 ffffffff81c64b00 ffff8806261d1098 ffff8806264d1df8
 ffff8806264d1de8 ffffffff815cd5a4 ffffffff81c64b00 ffffffff815cd56a
Call Trace:
 [<ffffffff815d02c9>] intel_iommu_add_device+0x95/0x167
 [<ffffffff815cd5a4>] add_iommu_group+0x3a/0x41
 [<ffffffff815cd56a>] ? bus_set_iommu+0x44/0x44
 [<ffffffff8145eca1>] bus_for_each_dev+0x54/0x81
 [<ffffffff815cd563>] bus_set_iommu+0x3d/0x44
 [<ffffffff81cd3fa3>] intel_iommu_init+0xae5/0xb5e
 [<ffffffff81ca0277>] ? free_initrd+0x9e/0x9e
 [<ffffffff81ca4248>] ? memblock_find_dma_reserve+0x13f/0x13f
 [<ffffffff81ca425e>] pci_iommu_init+0x16/0x41
 [<ffffffff81cc4140>] ? pci_proc_init+0x6b/0x6b
 [<ffffffff81000231>] do_one_initcall+0x7a/0x129
 [<ffffffff816dac14>] kernel_init+0x139/0x2a2
 [<ffffffff81c9d4c7>] ? loglevel+0x31/0x31
 [<ffffffff816daadb>] ? rest_init+0x6f/0x6f
 [<ffffffff816f66ac>] ret_from_fork+0x7c/0xb0
 [<ffffffff816daadb>] ? rest_init+0x6f/0x6f
Code: ff c1 75 04 ff d0 eb 12 48 83 c2 10 48 8b 42 08 48 85 c0 75 d3 b8 e=
7 ff ff ff c9 c3 55 48 c7 c2 f0 24 86 81 48 89 e5 eb 24 8b 0a <66> 3b 4f =
3c 74 05 66 ff c1 75 13 66 8b 4a 02 66 3b 4f 3e 74 05=20
RIP  [<ffffffff813bd796>] pci_get_dma_source+0xf/0x41
 RSP <ffff8806264d1d88>
CR2: 000000000000003c
---[ end trace 5c5a2ceca067e0ec ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=3D0x00000009=


------------[ cut here ]------------
WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x25/0x5=
1()
Hardware name: Relion 1751
Modules linked in:
Pid: 1, comm: swapper/0 Tainted: G      D      3.7.0-rc5 #1
Call Trace:
 <IRQ>  [<ffffffff810968ee>] warn_slowpath_common+0x80/0x98
 [<ffffffff8109691b>] warn_slowpath_null+0x15/0x17
 [<ffffffff8104e1a3>] native_smp_send_reschedule+0x25/0x51
 [<ffffffff810bc81b>] trigger_load_balance+0x1e8/0x214
 [<ffffffff810b731f>] scheduler_tick+0xd8/0xe1
 [<ffffffff810a132f>] update_process_times+0x62/0x73
 [<ffffffff810cb78b>] tick_sched_timer+0x7c/0x9b
 [<ffffffff810b0f83>] __run_hrtimer.clone.24+0x4e/0xc1
 [<ffffffff810b15b0>] hrtimer_interrupt+0xc7/0x1ac
 [<ffffffff8104ef01>] smp_apic_timer_interrupt+0x81/0x94
 [<ffffffff816f71ca>] apic_timer_interrupt+0x6a/0x70
 <EOI>  [<ffffffff81097ffc>] ? console_unlock+0x2c2/0x2ed
 [<ffffffff816f32fc>] ? panic+0x189/0x1c5
 [<ffffffff816f3261>] ? panic+0xee/0x1c5
 [<ffffffff8109ab6b>] do_exit+0x357/0x7b2
 [<ffffffff810371b8>] oops_end+0xb2/0xba
 [<ffffffff8105841d>] no_context+0x266/0x275
 [<ffffffff810585e7>] __bad_area_nosemaphore+0x1bb/0x1db
 [<ffffffff8118de46>] ? sysfs_addrm_finish+0x2f/0xa6
 [<ffffffff81058615>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81058bdb>] __do_page_fault+0x360/0x39f
 [<ffffffff81394afa>] ? ida_get_new_above+0xf9/0x19e
 [<ffffffff8112a077>] ? slab_node+0x59/0xa2
 [<ffffffff816f3ffd>] ? mutex_unlock+0x9/0xb
 [<ffffffff816da653>] ? klist_put+0x4c/0x70
 [<ffffffff816da581>] ? klist_next+0x30/0xb6
 [<ffffffff813b8cf9>] ? pci_do_find_bus+0x49/0x49
 [<ffffffff81058c42>] do_page_fault+0x9/0xb
 [<ffffffff816f6232>] page_fault+0x22/0x30
 [<ffffffff813bd3a8>] ? nv_msi_ht_cap_quirk_all+0x10/0x10
 [<ffffffff813bd796>] ? pci_get_dma_source+0xf/0x41
 [<ffffffff815d02c9>] intel_iommu_add_device+0x95/0x167
 [<ffffffff815cd5a4>] add_iommu_group+0x3a/0x41
 [<ffffffff815cd56a>] ? bus_set_iommu+0x44/0x44
 [<ffffffff8145eca1>] bus_for_each_dev+0x54/0x81
 [<ffffffff815cd563>] bus_set_iommu+0x3d/0x44
 [<ffffffff81cd3fa3>] intel_iommu_init+0xae5/0xb5e
 [<ffffffff81ca0277>] ? free_initrd+0x9e/0x9e
 [<ffffffff81ca4248>] ? memblock_find_dma_reserve+0x13f/0x13f
 [<ffffffff81ca425e>] pci_iommu_init+0x16/0x41
 [<ffffffff81cc4140>] ? pci_proc_init+0x6b/0x6b
 [<ffffffff81000231>] do_one_initcall+0x7a/0x129
 [<ffffffff816dac14>] kernel_init+0x139/0x2a2
 [<ffffffff81c9d4c7>] ? loglevel+0x31/0x31
 [<ffffffff816daadb>] ? rest_init+0x6f/0x6f
 [<ffffffff816f66ac>] ret_from_fork+0x7c/0xb0
 [<ffffffff816daadb>] ? rest_init+0x6f/0x6f
---[ end trace 5c5a2ceca067e0ed ]---

--------------090205050801070509070204
Content-Type: text/plain; charset=UTF-8;
 name="pipacs-pci-null-deref.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="pipacs-pci-null-deref.log"

14:25 <  prometheanfire > pipacs: intrested in a null pointer deref in th=
e kernel (not pax)?
14:25 <          pipacs > define 'interested' ;)
14:25 <  prometheanfire > http://bpaste.net/show/v5y2sI6l3WWx3Rcpu5CS/
14:26 <          pipacs > what do you expect me to do with it?
14:26 <          pipacs > help debug it?
14:26 <  prometheanfire > sure lol
14:26 <  prometheanfire > it only happens when I have this one pci card i=
n, so I'm confused, if you have something better to do, do that though :P=

14:27 <          pipacs > do you have CONFIG_PCI_QUIRKS?
14:28 <  prometheanfire > dunno
14:28 <  prometheanfire > gonna have to reboot to get to it
14:28 <  prometheanfire > I saw that too
14:28 <          pipacs > like, check it? ;P
14:28 <          pipacs > my guess is that 'dev' is null
14:28 <          pipacs > the one passed to pci_get_dma_source
14:30 <          pipacs > better the kernel devs
14:30 <  prometheanfire > probably
14:30 <          pipacs > i don't know if the code is supposed to handle =
a null dev there or not
14:30 <  prometheanfire > it's a pcie-pci bridge
14:32 <  prometheanfire > CONFIG_PCI_QUIRKS=3Dy

--------------090205050801070509070204--

--------------enigD6F4FF116F9EF02826A8BF54
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQoDKHAAoJECRx6z5ArFrDoRgQAIE5tqC/3iD0b9kAL0yOP+ew
I48lNOW/SE5KL3feJzGgFk0Z1CFIGyGsWC9ONmT6Gt0dKJ2GD002XPZCIR2xvoxu
vVL7CkHbLa9e8P5BXnNxjCXgNJ+QhdK1C0hTaXeErTYArSEgMTl9EYwafEOPhewf
bMaFync+VuzMoZTH8COj5wpoc1qonv0uUwP478ptgYJdt1/0+9Ri2HXnlWOmrNTp
WtRoF0nsvOLzVerGOHqvrmJGvTQjGME18nE6dNSeC5fgptPG7OvMsgZSnqj1hQ29
59qCKxaCXuYqm+2kK11+zGOSm2QJe31GaT2QLXaNgIA81oRP0048zVhGgeoDPWqL
PEsUROhOOWUZk5pMM/vmFKL4THEceUAZYngCMMFWL3lgGT4yhgA457098pDqFNlP
skx6qPwe82Jyk6vmoaS5PcS53fjuCT5LWdHKz9VMQsNuRAxi7A7YsBRcq4ATLLZ0
nKgRaQz4qA00yVJiD6gsbHqe9RI6Zdg5PJUb3PjR6O2w23P+01BDCi6FAeDDQw9T
s2aNu5pn0kgIi7w3wREgpSMveOTVh3NdM9/wXKSq6OldHrMI6g3RsZ9ojxNnoz/6
VdRnSOCvfwOVyuYQ3QAZvPtP5kjr7XqAyfwoAFzJ24dEueMwDAQu0RZRL9Rcrqtw
/UES7hzgb2w/es498prM
=ydZK
-----END PGP SIGNATURE-----

--------------enigD6F4FF116F9EF02826A8BF54--
