Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab0GWDZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 23:25:19 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:40020 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751005Ab0GWDZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 23:25:16 -0400
Date: Thu, 22 Jul 2010 23:25:15 -0400 (EDT)
From: caiqian@redhat.com
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dave Anderson <anderson@redhat.com>, Avi Kivity <avi@redhat.com>
Message-ID: <198123598.1050221279855515402.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1289916563.1050101279855288046.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: 2.6.35-rc5 panic at __br_deliver+0x64/0xe0 with kvm bridge
 networking
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_56377_113474362.1279855515400"
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_56377_113474362.1279855515400
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

I met consistently host panic when operated under kvm guest with bridge networking. I got a vmcore (unfortunately, the crash utility had some problems to analyse it fully), and full panic log is attached.

general protection fault: 0000 [#1] SMP
last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/energy_full
CPU 0
Modules linked in: xfs exportfs sit tunnel4 fuse ebtable_nat ebtables rfcomm sco bridge stp llc bnep l2cap autofs4 sunrpc xt_physdev ipt_MASQUERADE iptable_nat nf_nat ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_table mperf dm_mirror dm_region_hash dm_log vhost_net macvtap macvlan tun kvm_intel kvm uinput usb_storage sr_mod cdrom pcspkr xhci_hcd ext4 mbcache jbd2 cryptd aes_x86_64 aes_generic xts gf128mul dm_crypt sg sd_mod crc_t10dif i2c_i801 ahci libahci arc4 iTCO_wdt ecb iTCO_vendor_support iwlagn iwlcore mac80211 cfg80211 snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd_page_alloc thinkpad_acpi hwmon snd soundcore wmi e1000e btusb bluetooth rfkill i915 drm_kms_helper drm i2c_algo_bit i2c_core video output dm_mod [last unloaded: microcode]

Pid: 1604, comm: cups-polld Not tainted 2.6.35-rc5 #1 7459H94/7459H94
RIP: 0010:[<ffffffffa061cb54>]  [<ffffffffa061cb54>] __br_deliver+0x64/0xe0 [bridge]
RSP: 0018:ffff880134cbb778  EFLAGS: 00010296
RAX: 5a5a5a5a5a5a5a5a RBX: ffff880035d2c980 RCX: 0000000000000003
RDX: 0000000000001c70 RSI: ffff880125154c98 RDI: 0000000000000000
RBP: ffff880134cbb798 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88012331c288
R13: ffff88012331c2b0 R14: ffff88012e252c16 R15: ffff880035d2c000
FS:  00007ffa879807c0(0000) GS:ffff88000b000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f99ba6c5020 CR3: 0000000125c6d000 CR4: 00000000000426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cups-polld (pid: 1604, threadinfo ffff880134cba000, task ffff8801251542d0)
Stack:
 ffff880180000000 ffffffff81098ebd ffff88012331c288 ffff880035d2c980
<0> ffff880134cbb7a8 ffffffffa061cc05 ffff880134cbb7d8 ffffffffa061b7b4
<0> ffff88012331c288 ffffffff81c3e5c0 ffff88012331cac8 ffffffff81c3e600
Call Trace:
 [<ffffffff81098ebd>] ? lock_release_holdtime+0x3d/0x190
 [<ffffffffa061cc05>] br_deliver+0x35/0x40 [bridge]
 [<ffffffffa061b7b4>] br_dev_xmit+0xb4/0x160 [bridge]
 [<ffffffff814105bd>] dev_hard_start_xmit+0x2fd/0x450
 [<ffffffff81410329>] ? dev_hard_start_xmit+0x69/0x450
 [<ffffffff81050931>] ? get_parent_ip+0x11/0x50
 [<ffffffff81413046>] dev_queue_xmit+0x4f6/0x7b0
 [<ffffffff81412b9f>] ? dev_queue_xmit+0x4f/0x7b0
 [<ffffffff810997ed>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8106a247>] ? local_bh_enable_ip+0x97/0x100
 [<ffffffff8141bc63>] neigh_resolve_output+0x113/0x3f0
 [<ffffffff81454e74>] ip_finish_output+0x1a4/0x4b0
 [<ffffffff8145550b>] ip_output+0xbb/0x110
 [<ffffffff81453e6d>] ip_local_out+0x2d/0x80
 [<ffffffff81454762>] ip_queue_xmit+0x1c2/0x500
 [<ffffffff814545a0>] ? ip_queue_xmit+0x0/0x500
 [<ffffffff8114db77>] ? __kmalloc_node_track_caller+0x87/0x110
 [<ffffffff8114d9eb>] ? kmem_cache_alloc_node_notrace+0x10b/0x210
 [<ffffffff8114db77>] ? __kmalloc_node_track_caller+0x87/0x110
 [<ffffffff8146a308>] tcp_transmit_skb+0x3f8/0x8a0
 [<ffffffff8146bf0d>] tcp_send_ack+0xdd/0x130
 [<ffffffff8145c666>] tcp_cleanup_rbuf+0x76/0x110
 [<ffffffff8145ee90>] tcp_recvmsg+0x450/0xd10
 [<ffffffff814837fd>] inet_recvmsg+0xcd/0xf0
 [<ffffffff813fbb8d>] sock_recvmsg+0xfd/0x130
 [<ffffffff813fb853>] ? sock_sendmsg+0xf3/0x130
 [<ffffffff810127b9>] ? sched_clock+0x9/0x10
 [<ffffffff81089435>] ? sched_clock_local+0x25/0x90
 [<ffffffff81089558>] ? sched_clock_cpu+0xb8/0x110
 [<ffffffff810956fd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8108961f>] ? cpu_clock+0x6f/0x80
 [<ffffffff8109979d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff810997ed>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff813fbd01>] sys_recvfrom+0xe1/0x170
 [<ffffffff81087662>] ? hrtimer_nanosleep+0x132/0x190
 [<ffffffff8100b06a>] ? sysret_check+0x2e/0x69
 [<ffffffff8109979d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff814e4ef2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100b032>] system_call_fastpath+0x16/0x1b
Code: c9 49 c7 c1 90 ca 61 a0 4c 89 e2 be 03 00 00 00 bf 07 00 00 00 c7 04 24 00 00 00 80 e8 96 c6 e1 e0 83 f8 01 74 31 49 8b 44 24 20 <48> 8b 80 08 05 00 00 48 85 c0 74 0e 48 8b 80 d0 01 00 00 48 8b
RIP  [<ffffffffa061cb54>] __br_deliver+0x64/0xe0 [bridge]
 RSP <ffff880134cbb778>
------=_Part_56377_113474362.1279855515400
Content-Type: application/octet-stream; name=log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=log

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.35-rc5 (root@dhcp-65-141.nay.redhat.com) (gcc version 4.4.4 20100630 (Red Hat 4.4.4-10) (GCC) ) #1 SMP Fri Jul 16 18:59:17 CST 2010
Command line: ro root=/dev/mapper/VolGroup-lv_root rd_LVM_LV=VolGroup/lv_root rd_LUKS_UUID=luks-fb264012-c3c0-4582-ab76-23b4454215b3 rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us rdshell rdinitdebug crashkernel=128M 1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bd4a1000 (usable)
 BIOS-e820: 00000000bd4a1000 - 00000000bd4a7000 (reserved)
 BIOS-e820: 00000000bd4a7000 - 00000000bd5b7000 (usable)
 BIOS-e820: 00000000bd5b7000 - 00000000bd60f000 (reserved)
 BIOS-e820: 00000000bd60f000 - 00000000bd6c6000 (usable)
 BIOS-e820: 00000000bd6c6000 - 00000000bd6d1000 (ACPI NVS)
 BIOS-e820: 00000000bd6d1000 - 00000000bd6d4000 (ACPI data)
 BIOS-e820: 00000000bd6d4000 - 00000000bd6d8000 (reserved)
 BIOS-e820: 00000000bd6d8000 - 00000000bd6dc000 (ACPI NVS)
 BIOS-e820: 00000000bd6dc000 - 00000000bd6df000 (reserved)
 BIOS-e820: 00000000bd6df000 - 00000000bd706000 (ACPI NVS)
 BIOS-e820: 00000000bd706000 - 00000000bd708000 (ACPI data)
 BIOS-e820: 00000000bd708000 - 00000000bd90f000 (reserved)
 BIOS-e820: 00000000bd90f000 - 00000000bd99f000 (ACPI NVS)
 BIOS-e820: 00000000bd99f000 - 00000000bd9ff000 (ACPI data)
 BIOS-e820: 00000000bd9ff000 - 00000000bda00000 (usable)
 BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
 BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
NX (Execute Disable) protection: active
DMI present.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x13c000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-D3FFF write-protect
  D4000-DBFFF uncachable
  DC000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 13C000000 mask FFC000000 uncachable
  1 base 0BE000000 mask FFE000000 uncachable
  2 base 000000000 mask F80000000 write-back
  3 base 080000000 mask FC0000000 write-back
  4 base 100000000 mask FC0000000 write-back
  5 base 0BDE00000 mask FFFE00000 uncachable
  6 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 5056MB, range: 64MB, type UC
reg 1, base: 3040MB, range: 32MB, type UC
reg 2, base: 0GB, range: 2GB, type WB
reg 3, base: 2GB, range: 1GB, type WB
reg 4, base: 4GB, range: 1GB, type WB
reg 5, base: 3038MB, range: 2MB, type UC
total RAM covered: 3998M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2GB, range: 1GB, type WB
reg 2, base: 3038MB, range: 2MB, type UC
reg 3, base: 3040MB, range: 32MB, type UC
reg 4, base: 4GB, range: 1GB, type WB
reg 5, base: 5056MB, range: 64MB, type UC
e820 update range: 00000000bde00000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xbda00 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
found SMP MP-table at [ffff8800000f72e0] f72e0
init_memory_mapping: 0000000000000000-00000000bda00000
 0000000000 - 00bda00000 page 2M
kernel direct mapping tables up to bda00000 @ 8000-c000
init_memory_mapping: 0000000100000000-000000013c000000
 0100000000 - 013c000000 page 2M
kernel direct mapping tables up to 13c000000 @ a000-10000
RAMDISK: 3410a000 - 37ff0000
Reserving 128MB of memory at 48MB for crashkernel (System RAM: 5056MB)
ACPI: RSDP 00000000000f72a0 00024 (v02 LENOVO)
ACPI: XSDT 00000000bd95b8ab 00094 (v01 LENOVO TP-6D    00003100  LTP 00000000)
ACPI: FACP 00000000bd95ba00 000F4 (v03 LENOVO TP-6D    00003100 LNVO 00000001)
ACPI: DSDT 00000000bd95bdf4 0DF28 (v01 LENOVO TP-6D    00003100 MSFT 03000000)
ACPI: FACS 00000000bd98e000 00040
ACPI: SSDT 00000000bd95bbb4 00240 (v01 LENOVO TP-6D    00003100 MSFT 03000000)
ACPI: ECDT 00000000bd969d1c 00052 (v01 LENOVO TP-6D    00003100 LNVO 00000001)
ACPI: APIC 00000000bd969d6e 00078 (v01 LENOVO TP-6D    00003100 LNVO 00000001)
ACPI: MCFG 00000000bd969de6 0003C (v01 LENOVO TP-6D    00003100 LNVO 00000001)
ACPI: HPET 00000000bd969e22 00038 (v01 LENOVO TP-6D    00003100 LNVO 00000001)
ACPI: BOOT 00000000bd969f38 00028 (v01 LENOVO TP-6D    00003100  LTP 00000001)
ACPI: ASF! 00000000bd969f60 000A0 (v16 LENOVO TP-6D    00003100 PTL  00000001)
ACPI: SSDT 00000000bd98d1ea 00578 (v01 LENOVO TP-6D    00003100 INTL 20050513)
ACPI: TCPA 00000000bd707000 00032 (v00                 00000000      00000000)
ACPI: DMAR 00000000bd706000 00120 (v01               ? 00000001      00000000)
ACPI: SSDT 00000000bd6d3000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
ACPI: SSDT 00000000bd6d2000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
ACPI: SSDT 00000000bd6d1000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-000000013c000000
Initmem setup node 0 0000000000000000-000000013c000000
  NODE_DATA [0000000100000000 - 0000000100026fff]
 [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880100200000-ffff8801039fffff] on node 0
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x0013c000
Movable zone start PFN for each node
early_node_map[6] active PFN ranges
    0: 0x00000001 -> 0x0000009e
    0: 0x00000100 -> 0x000bd4a1
    0: 0x000bd4a7 -> 0x000bd5b7
    0: 0x000bd60f -> 0x000bd6c6
    0: 0x000bd9ff -> 0x000bda00
    0: 0x00100000 -> 0x0013c000
On node 0 totalpages: 1021446
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3941 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 757409 pages, LIFO batch:31
  Normal zone: 3360 pages used for memmap
  Normal zone: 242400 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 4 CPUs, 2 hotplug CPUs
nr_irqs_gsi: 40
early_res array is doubled to 64 at [7000 - 77ff]
early_res array is doubled to 128 at [b000 - bfff]
PM: Registered nosave memory: 000000000009e000 - 000000000009f000
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
PM: Registered nosave memory: 00000000bd4a1000 - 00000000bd4a7000
PM: Registered nosave memory: 00000000bd5b7000 - 00000000bd60f000
PM: Registered nosave memory: 00000000bd6c6000 - 00000000bd6d1000
PM: Registered nosave memory: 00000000bd6d1000 - 00000000bd6d4000
PM: Registered nosave memory: 00000000bd6d4000 - 00000000bd6d8000
PM: Registered nosave memory: 00000000bd6d8000 - 00000000bd6dc000
PM: Registered nosave memory: 00000000bd6dc000 - 00000000bd6df000
PM: Registered nosave memory: 00000000bd6df000 - 00000000bd706000
PM: Registered nosave memory: 00000000bd706000 - 00000000bd708000
PM: Registered nosave memory: 00000000bd708000 - 00000000bd90f000
PM: Registered nosave memory: 00000000bd90f000 - 00000000bd99f000
PM: Registered nosave memory: 00000000bd99f000 - 00000000bd9ff000
PM: Registered nosave memory: 00000000bda00000 - 00000000bdc00000
PM: Registered nosave memory: 00000000bdc00000 - 00000000c0000000
PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
PM: Registered nosave memory: 00000000fed00000 - 00000000fed10000
PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 479 pages/cpu @ffff88000b000000 s1932352 r8192 d21440 u2097152
pcpu-alloc: s1932352 r8192 d21440 u2097152 alloc=1*2097152
pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1003750
Policy zone: Normal
Kernel command line: ro root=/dev/mapper/VolGroup-lv_root rd_LVM_LV=VolGroup/lv_root rd_LUKS_UUID=luks-fb264012-c3c0-4582-ab76-23b4454215b3 rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us rdshell rdinitdebug crashkernel=128M 1
PID hash table entries: 4096 (order: 3, 32768 bytes)
xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
Checking aperture...
No AGP bridge found
Subtract (85 early reservations)
  #1 [0001000000 - 0002ea71f8]   TEXT DATA BSS
  #2 [003410a000 - 0037ff0000]         RAMDISK
  #3 [0002ea8000 - 0002ea814c]             BRK
  #4 [00000f72f0 - 0000100000]   BIOS reserved
  #5 [00000f72e0 - 00000f72f0]    MP-table mpf
  #6 [000009ec00 - 000009f171]   BIOS reserved
  #7 [000009f27d - 00000f72e0]   BIOS reserved
  #8 [000009f171 - 000009f27d]    MP-table mpc
  #9 [0000001000 - 0000003000]      TRAMPOLINE
  #10 [0000003000 - 0000007000]     ACPI WAKEUP
  #11 [0000008000 - 000000a000]         PGTABLE
  #12 [000000a000 - 000000b000]         PGTABLE
  #13 [0003000000 - 000b000000]    CRASH KERNEL
  #14 [0100000000 - 0100027000]       NODE_DATA
  #15 [0002ea8180 - 0002ea9180]         BOOTMEM
  #16 [0002ea7200 - 0002ea7500]         BOOTMEM
  #17 [0100027000 - 0100028000]         BOOTMEM
  #18 [0100028000 - 0100029000]         BOOTMEM
  #19 [0100200000 - 0103a00000]        MEMMAP 0
  #20 [0002ea9180 - 0002ef9180]         BOOTMEM
  #21 [0002ef9180 - 0002f49180]         BOOTMEM
  #22 [0002f49180 - 0002f99180]         BOOTMEM
  #23 [0002f9a000 - 0002f9b000]         BOOTMEM
  #24 [0002ea7500 - 0002ea7541]         BOOTMEM
  #25 [0002ea7580 - 0002ea75c3]         BOOTMEM
  #26 [0002ea7600 - 0002ea7c90]         BOOTMEM
  #27 [0002ea7cc0 - 0002ea7d28]         BOOTMEM
  #28 [0002ea7d40 - 0002ea7da8]         BOOTMEM
  #29 [0002ea7dc0 - 0002ea7e28]         BOOTMEM
  #30 [0002ea7e40 - 0002ea7ea8]         BOOTMEM
  #31 [0002ea7ec0 - 0002ea7f28]         BOOTMEM
  #32 [0002ea7f40 - 0002ea7fa8]         BOOTMEM
  #33 [0002f99180 - 0002f991e8]         BOOTMEM
  #34 [0002f99200 - 0002f99268]         BOOTMEM
  #35 [0002f99280 - 0002f992e8]         BOOTMEM
  #36 [0002f99300 - 0002f99368]         BOOTMEM
  #37 [0002f99380 - 0002f993e8]         BOOTMEM
  #38 [0002f99400 - 0002f99468]         BOOTMEM
  #39 [0002f99480 - 0002f994e8]         BOOTMEM
  #40 [0002f99500 - 0002f99568]         BOOTMEM
  #41 [0002f99580 - 0002f995e8]         BOOTMEM
  #42 [0002f99600 - 0002f99668]         BOOTMEM
  #43 [0002f99680 - 0002f996e8]         BOOTMEM
  #44 [0002f99700 - 0002f99768]         BOOTMEM
  #45 [0002f99780 - 0002f997e8]         BOOTMEM
  #46 [0002f99800 - 0002f99868]         BOOTMEM
  #47 [0002f99880 - 0002f998e8]         BOOTMEM
  #48 [0002f99900 - 0002f99968]         BOOTMEM
  #49 [0002f99980 - 0002f999e8]         BOOTMEM
  #50 [0002f99a00 - 0002f99a68]         BOOTMEM
  #51 [0002f99a80 - 0002f99ae8]         BOOTMEM
  #52 [0002f99b00 - 0002f99b68]         BOOTMEM
  #53 [0002f99b80 - 0002f99be8]         BOOTMEM
  #54 [0002f99c00 - 0002f99c68]         BOOTMEM
  #55 [0002f99c80 - 0002f99ce8]         BOOTMEM
  #56 [0002ea7fc0 - 0002ea7fe0]         BOOTMEM
  #57 [0002f99d00 - 0002f99d20]         BOOTMEM
  #58 [0002f99d40 - 0002f99d60]         BOOTMEM
  #59 [0002f99d80 - 0002f99da0]         BOOTMEM
  #60 [0002f99dc0 - 0002f99de0]         BOOTMEM
  #61 [0002f99e00 - 0002f99ef7]         BOOTMEM
  #62 [0002f99f00 - 0002f99ff7]         BOOTMEM
  #63 [000b000000 - 000b1df000]         BOOTMEM
  #64 [000b200000 - 000b3df000]         BOOTMEM
  #65 [000b400000 - 000b5df000]         BOOTMEM
  #66 [000b600000 - 000b7df000]         BOOTMEM
  #67 [0002f9d000 - 0002f9d008]         BOOTMEM
  #68 [0002f9d040 - 0002f9d048]         BOOTMEM
  #69 [0002f9d080 - 0002f9d090]         BOOTMEM
  #70 [0002f9d0c0 - 0002f9d0e0]         BOOTMEM
  #71 [0002f9d100 - 0002f9d250]         BOOTMEM
  #72 [0002f9d280 - 0002f9d300]         BOOTMEM
  #73 [0002f9d300 - 0002f9d380]         BOOTMEM
  #74 [0002f9b000 - 0002f9b200]         BOOTMEM
  #75 [0002f9b200 - 0002f9b400]         BOOTMEM
  #76 [0002f9b400 - 0002f9b600]         BOOTMEM
  #77 [0002f9b600 - 0002f9b800]         BOOTMEM
  #78 [0002f9b800 - 0002f9ba00]         BOOTMEM
  #79 [0002f9d380 - 0002fa5380]         BOOTMEM
  #80 [0002f9ba00 - 0002f9bc40]         BOOTMEM
  #81 [000b7df000 - 000f7df000]         BOOTMEM
  #82 [0002fa5380 - 0002fc5380]         BOOTMEM
  #83 [000f7df000 - 000f81f000]         BOOTMEM
  #84 [000000c000 - 0000014000]         BOOTMEM
Memory: 3726740k/5177344k available (5054k kernel code, 1091560k absent, 359044k reserved, 7493k data, 3428k init)
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:262400 nr_irqs:712
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 6367 kB
 per task-struct memory footprint: 2688 bytes
allocated 41943040 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
ODEBUG: 12 of 12 active objects replaced
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2393.634 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.26 BogoMIPS (lpj=2393634)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
ACPI: Core revision 20100428
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 18587 entries in 73 pages
DMAR: Host address width 36
DMAR: DRHD base: 0x000000feb03000 flags: 0x0
IOMMU 0: reg_base_addr feb03000 ver 1:0 cap c9008020e30260 ecap 1000
DMAR: DRHD base: 0x000000feb01000 flags: 0x0
IOMMU 1: reg_base_addr feb01000 ver 1:0 cap c0000020630260 ecap 1000
DMAR: DRHD base: 0x000000feb00000 flags: 0x0
IOMMU 2: reg_base_addr feb00000 ver 1:0 cap c0000020630270 ecap 1000
DMAR: DRHD base: 0x000000feb02000 flags: 0x1
IOMMU 3: reg_base_addr feb02000 ver 1:0 cap c9008020630260 ecap 1000
DMAR: RMRR base: 0x000000f2826c00 end: 0x000000f28273ff
DMAR: RMRR base: 0x000000bdc00000 end: 0x000000bfffffff
DMAR: No ATSR found
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz stepping 0a
lockdep: fixing up alternatives.
Booting Node   0, Processors  #1
Brought up 2 CPUs
Total of 2 processors activated (9575.02 BogoMIPS).
devtmpfs: initialized
regulator: core version 0.5
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: EC description table is found, configuring boot EC
ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
ACPI: SSDT 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
ACPI: SSDT 00000000bd6d5f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
ACPI: Power Resource [PUBS] (on)
ACPI: ACPI Dock Station Driver: 3 docks/bays found
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
DMAR: Forcing write-buffer flush capability
DMAR: Disabling IOMMU for graphics on this chipset
pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
pci 0000:00:02.1: reg 10: [mem 0xf2400000-0xf24fffff 64bit]
pci 0000:00:03.0: reg 10: [mem 0xf2826800-0xf282680f 64bit]
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.3: reg 10: [io  0x1830-0x1837]
pci 0000:00:03.3: reg 14: [mem 0xf2624000-0xf2624fff]
pci 0000:00:19.0: reg 10: [mem 0xf2600000-0xf261ffff]
pci 0000:00:19.0: reg 14: [mem 0xf2625000-0xf2625fff]
pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
pci 0000:00:1a.7: reg 10: [mem 0xf2826c00-0xf2826fff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10: [mem 0xf2620000-0xf2623fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
pci 0000:00:1d.7: reg 10: [mem 0xf2827000-0xf28273ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
pci 0000:00:1f.2: reg 24: [mem 0xf2826000-0xf28267ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10: [mem 0xf2827400-0xf28274ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:03:00.0: reg 10: [mem 0xf2500000-0xf2501fff 64bit]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:05:00.0: reg 10: [mem 0xf1f00000-0xf1f01fff 64bit]
pci 0000:05:00.0: PME# supported from D0 D3hot
pci 0000:05:00.0: PME# disabled
pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 0d-0d] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
reserve RAM buffer: 00000000bd4a1000 - 00000000bfffffff 
reserve RAM buffer: 00000000bd5b7000 - 00000000bfffffff 
reserve RAM buffer: 00000000bd6c6000 - 00000000bfffffff 
reserve RAM buffer: 00000000bda00000 - 00000000bfffffff 
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
system 00:02: [io  0x1000-0x107f] has been reserved
system 00:02: [io  0x1180-0x11ff] has been reserved
system 00:02: [io  0x0800-0x080f] has been reserved
system 00:02: [io  0x15e0-0x15ef] has been reserved
system 00:02: [io  0x1600-0x167f] has been reserved
system 00:02: [io  0x1680-0x169f] has been reserved
system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0000000-0xc01fffff]
pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
pci 0000:00:1c.0: BAR 13: assigned [io  0x3000-0x3fff]
pci 0000:00:1c.1: BAR 13: assigned [io  0x4000-0x4fff]
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 0d-0d]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem disabled]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
  alloc irq_desc for 20 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
pci 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 21 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
pci 0000:00:1c.1: setting latency timer to 64
  alloc irq_desc for 23 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:0d: resource 7 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:0d: resource 8 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:0d: resource 9 [mem 0xc0000000-0xfebfffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 6, 327680 bytes)
UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 64408k freed
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
DMAR: Device scope device [0000:00:03.02] not found
DMAR: Device scope device [0000:00:03.02] not found
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff88000b7df000 - ffff88000f7df000
software IO TLB at phys 0xb7df000 - 0xf7df000
Simple Boot Flag at 0x35 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1279766654.219:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 7404
SELinux:  Registering netfilter hooks
cryptomgr_test used greatest stack depth: 5832 bytes left
cryptomgr_test used greatest stack depth: 5768 bytes left
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 40 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.1: setting latency timer to 64
  alloc irq_desc for 41 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.3: setting latency timer to 64
  alloc irq_desc for 42 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 2940 ss_vid 17aa ss_did 20f3
pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2942 ss_vid 17aa ss_did 20f3
pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 2946 ss_vid 17aa ss_did 20f3
pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_glue: Slot 1 already registered by another hotplug driver
pci-stub: invalid id string ""
ACPI: AC Adapter [AC] (on-line)
input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
ACPI: acpi_idle registered with cpuidle
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
Marking TSC unstable due to TSC halts in idle
Switching to clocksource hpet
kwatchdog used greatest stack depth: 5688 bytes left
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (64 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Thermal Zone [THM1] (64 C)
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel GM45 Chipset
agpgart-intel 0000:00:00.0: detected 32764K stolen memory
ACPI: Battery Slot [BAT0] (battery present)
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
  alloc irq_desc for 17 on node -1
  alloc kstat_irqs on node -1
serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
0000:00:03.3: ttyS0 at I/O 0x1830 (irq = 17) is a 16550A
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.35-rc5 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
  alloc irq_desc for 19 on node -1
  alloc kstat_irqs on node -1
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.35-rc5 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.35-rc5 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.35-rc5 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
  alloc irq_desc for 22 on node -1
  alloc kstat_irqs on node -1
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.35-rc5 uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
  alloc irq_desc for 16 on node -1
  alloc kstat_irqs on node -1
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.35-rc5 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.35-rc5 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
  alloc irq_desc for 18 on node -1
  alloc kstat_irqs on node -1
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.35-rc5 uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:07: RTC can wake from S4
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
IMA: No TPM chip found, activating TPM-bypass!
rtc_cmos 00:07: setting system clock to 2010-07-22 02:44:15 UTC (1279766655)
Initalizing network drop monitor service
Freeing unused kernel memory: 3428k freed
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 1072k freed
Freeing unused kernel memory: 1728k freed
mknod used greatest stack depth: 5504 bytes left
mount used greatest stack depth: 5296 bytes left
dracut: + mkdir /dev/shm
dracut: + mkdir /dev/pts
dracut: + mount -t devpts -o gid=5,mode=620 devpts /dev/pts
dracut: + mount -t tmpfs tmpfs /dev/shm
dracut: + udevadm --version
dracut: + UDEVVERSION=147
dracut: + source_conf /etc/conf.d
dracut: + local f
dracut: + [ /etc/conf.d ]
dracut: + [ -d //etc/conf.d ]
dracut: + return
dracut: + getarg rdbreak=cmdline
dracut: + set +x
dracut: + return 1
dracut: + source_all cmdline
dracut: + local f
dracut: + [ cmdline ]
dracut: + [ -d /cmdline ]
dracut: + [ -e /cmdline/01parse-kernel.sh ]
dracut: + . /cmdline/01parse-kernel.sh
dracut: + getargs rdloaddriver=
dracut: + set +x
dracut: + return 1
dracut: + [ -e /cmdline/01version.sh ]
dracut: + . /cmdline/01version.sh
dracut: + [ -f dracut-004-23.el6 ]
dracut: + vinfo
dracut: + read line
dracut: dracut-004-23.el6
dracut: + info dracut-004-23.el6
dracut: + check_quiet
dracut: + [ -z  ]
dracut: + DRACUT_QUIET=yes
dracut: + getarg rdinfo
dracut: + set +x
dracut: + return 1
dracut: + getarg quiet
dracut: + set +x
dracut: + return 1
dracut: + DRACUT_QUIET=yes
dracut: + echo <6>dracut: dracut-004-23.el6
dracut: + [ yes != yes ]
dracut: + read line
dracut: + unset i
dracut: + [ -e /cmdline/10parse-resume.sh ]
dracut: + . /cmdline/10parse-resume.sh
dracut: + getarg resume=
dracut: + set +x
dracut: + return 1
dracut: + resume=
dracut: + unset resume
dracut: + [ -e /cmdline/10parse-root-opts.sh ]
dracut: + . /cmdline/10parse-root-opts.sh
dracut: + getarg root=
dracut: + set +x
dracut: + return 0
dracut: + root=/dev/mapper/VolGroup-lv_root
dracut: + getarg rootflags=
dracut: + set +x
dracut: + return 1
dracut: + rflags=
dracut: + getarg rw
dracut: + set +x
dracut: + return 1
dracut: + rflags=ro
dracut: + getarg rootfstype=
dracut: + set +x
dracut: + return 1
dracut: + fstype=
dracut: + [ -z  ]
dracut: + fstype=auto
dracut: + [ -e /cmdline/20parse-blacklist.sh ]
dracut: + . /cmdline/20parse-blacklist.sh
dracut: + getargs rdblacklist=
dracut: + set +x
dracut: + return 1
dracut: + [ -e /cmdline/20parse-i18n.sh ]
dracut: + . /cmdline/20parse-i18n.sh
dracut: + mkdir -p /etc/sysconfig
dracut: + inst_key_val KEYBOARDTYPE /etc/sysconfig/keyboard
dracut: + local value
dracut: + getarg KEYBOARDTYPE
dracut: + set +x
dracut: + return 0
dracut: + value=pc
dracut: + [ -n pc ]
dracut: + printf %s="%s"n KEYBOARDTYPE pc
dracut: + inst_key_val KEYTABLE /etc/sysconfig/keyboard
dracut: + local value
dracut: + getarg KEYTABLE
dracut: + set +x
dracut: + return 0
dracut: + value=us
dracut: + [ -n us ]
dracut: + printf %s="%s"n KEYTABLE us
dracut: + inst_key_val SYSFONT /etc/sysconfig/i18n
dracut: + local value
dracut: + getarg SYSFONT
dracut: + set +x
dracut: + return 0
dracut: + value=latarcyrheb-sun16
dracut: + [ -n latarcyrheb-sun16 ]
dracut: + printf %s="%s"n SYSFONT latarcyrheb-sun16
dracut: + inst_key_val SYSFONTACM /etc/sysconfig/i18n
dracut: + local value
dracut: + getarg SYSFONTACM
dracut: + set +x
dracut: + return 1
dracut: + value=
dracut: + [ -n  ]
dracut: + inst_key_val UNIMAP /etc/sysconfig/i18n
dracut: + local value
dracut: + getarg UNIMAP
dracut: + set +x
dracut: + return 1
dracut: + value=
dracut: + [ -n  ]
dracut: + inst_key_val LANG /etc/sysconfig/i18n
dracut: + local value
dracut: + getarg LANG
dracut: + set +x
dracut: + return 0
dracut: + value=en_US.UTF-8
dracut: + [ -n en_US.UTF-8 ]
dracut: + printf %s="%s"n LANG en_US.UTF-8
dracut: + [ -f /etc/sysconfig/i18n ]
dracut: + . /etc/sysconfig/i18n
dracut: + SYSFONT=latarcyrheb-sun16
dracut: + LANG=en_US.UTF-8
dracut: + export LANG
dracut: + [ -e /cmdline/30parse-crypt.sh ]
dracut: + . /cmdline/30parse-crypt.sh
dracut: + getarg rd_NO_LUKS
dracut: + set +x
dracut: + return 1
dracut: + [ -e /cmdline/30parse-dmsquash-live.sh ]
dracut: + . /cmdline/30parse-dmsquash-live.sh
dracut: + [ -z /dev/mapper/VolGroup-lv_root ]
dracut: + getarg liveimg
dracut: + set +x
dracut: + return 1
dracut: + [ /dev/mapper/VolGroup-lv_root = live ]
dracut: + [  = live ]
dracut: + return
dracut: + [ -e /cmdline/30parse-lvm.sh ]
dracut: + . /cmdline/30parse-lvm.sh
dracut: + getarg rd_NO_LVM
dracut: + set +x
dracut: + return 1
dracut: + [ -e /etc/lvm/lvm.conf ]
dracut: + getarg rd_NO_LVMCONF
dracut: + set +x
dracut: + return 1
dracut: + [ -e /cmdline/95parse-block.sh ]
dracut: + . /cmdline/95parse-block.sh
dracut: + root=block:/dev/mapper/VolGroup-lv_root
dracut: + rootok=1
dracut: + [ -z block:/dev/mapper/VolGroup-lv_root ]
dracut: + [ -z 1 ]
dracut: + echo root='block:/dev/mapper/VolGroup-lv_root'
dracut: + echo rflags='ro'
dracut: + echo fstype='auto'
dracut: + echo netroot=''
dracut: + echo NEWROOT='/sysroot'
dracut: + getarg rdbreak=pre-udev
dracut: + set +x
dracut: + return 1
dracut: + source_all pre-udev
dracut: + local f
dracut: + [ pre-udev ]
dracut: + [ -d /pre-udev ]
dracut: + [ -e /pre-udev/30block-genrules.sh ]
dracut: + . /pre-udev/30block-genrules.sh
dracut: + [ block = block ]
dracut: + [ -d /dev/.udev/rules.d ]
dracut: + mkdir -p /dev/.udev/rules.d
dracut: + printf KERNEL=="%s", SYMLINK+="root"n mapper/VolGroup-lv_root
dracut: + printf SYMLINK=="%s", SYMLINK+="root"n mapper/VolGroup-lv_root
dracut: + printf [ -e "%s" ] && { ln -s "%s" /dev/root 2>/dev/null; rm "$job"; }n /dev/mapper/VolGroup-lv_root /dev/mapper/VolGroup-lv_root
dracut: + echo [ -e /dev/root ]
dracut: + [ -e /pre-udev/30dm-pre-udev.sh ]
dracut: + . /pre-udev/30dm-pre-udev.sh
dracut: + modprobe dm_mod
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
dracut: + [ -e /pre-udev/30dmsquash-live-genrules.sh ]
dracut: + . /pre-udev/30dmsquash-live-genrules.sh
dracut: + [ block = live ]
dracut: + [ -e /pre-udev/30dmsquash-liveiso-genrules.sh ]
dracut: + . /pre-udev/30dmsquash-liveiso-genrules.sh
dracut: + [ block = liveiso ]
dracut: + [ -e /pre-udev/30mdmon-pre-udev.sh ]
dracut: + . /pre-udev/30mdmon-pre-udev.sh
dracut: + mkdir /dev/.mdadm
dracut: + [ -e /var/run/mdadm ]
dracut: + ln -s /dev/.mdadm /var/run/mdadm
dracut: + [ -e /pre-udev/30resume-genrules.sh ]
dracut: + . /pre-udev/30resume-genrules.sh
dracut: + [ -n  ]
dracut: + getarg noresume
dracut: + set +x
dracut: + return 1
dracut: + echo SUBSYSTEM=="block", ACTION=="add|change", ENV{ID_FS_TYPE}=="suspend|swsuspend|swsupend",  RUN+="/bin/sh -c 'echo %M:%m > /sys/power/resume'"
dracut: + udevd --daemon --resolve-names=never
udev: starting version 147
dracut: + UDEV_LOG_PRIO_ARG=--log-priority
dracut: + UDEV_QUEUE_EMPTY=udevadm settle --timeout=0
dracut: + [ 147 -lt 140 ]
dracut: + getarg rdudevinfo
dracut: + set +x
dracut: + return 1
dracut: + getarg rdudevdebug
dracut: + set +x
dracut: + return 1
dracut: + getarg rdbreak=pre-trigger
dracut: + set +x
dracut: + return 1
dracut: + source_all pre-trigger
dracut: + local f
dracut: + [ pre-trigger ]
dracut: + [ -d /pre-trigger ]
dracut: + [ -e /pre-trigger/10plymouth-pretrigger.sh ]
dracut: + . /pre-trigger/10plymouth-pretrigger.sh
dracut: + getarg rd_NO_PLYMOUTH
dracut: + set +x
dracut: + return 1
dracut: + [ -c /dev/null ]
dracut: + udevadm trigger --attr-match=class=0x030000
udevadm used greatest stack depth: 5232 bytes left
dracut: + udevadm trigger --subsystem-match=graphics --subsystem-match=drm --subsystem-match=tty
dracut: + udevadm settle --timeout=30
dracut: + vinfo
dracut: + read line
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
usb 1-5: new high speed USB device using ehci_hcd and address 4
  alloc irq_desc for 43 on node -1
  alloc kstat_irqs on node -1
i915 0000:00:02.0: irq 43 for MSI/MSI-X
[drm] set up 31M of stolen space
IBM TrackPoint firmware: 0x0e, buttons: 3/3
usb 1-5: New USB device found, idVendor=17ef, idProduct=1005
usb 1-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-5:1.0: USB hub found
hub 1-5:1.0: 4 ports detected
input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
usb 4-1: new full speed USB device using uhci_hcd and address 2
async/0 used greatest stack depth: 2904 bytes left
usb 4-1: New USB device found, idVendor=08ff, idProduct=2810
usb 4-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 4-1: Product: Fingerprint Sensor
usb 4-2: new full speed USB device using uhci_hcd and address 3
fbcon: inteldrmfb (fb0) is primary device
usb 4-2: New USB device found, idVendor=0a5c, idProduct=2145
usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
usb 4-2: Manufacturer: Lenovo Computer Corp
Console: switching to colour frame buffer device 160x50
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
Slow work thread pool: Starting up
Slow work thread pool: Ready
acpi device:01: registered as cooling_device2
input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
modprobe used greatest stack depth: 2496 bytes left
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: Generic Bluetooth USB driver ver 0.6
usbcore: registered new interface driver btusb
dracut: + [ -c /dev/zero ]
dracut: + [ -c /dev/systty ]
dracut: + mknod /dev/systty c 4 0
dracut: + [ -c /dev/fb ]
dracut: + mknod /dev/fb c 29 0
dracut: + [ -c /dev/hvc0 ]
dracut: + mknod /dev/hvc0 c 229 0
dracut: + info Starting plymouth daemon
dracut: Starting plymouth daemon
dracut: + check_quiet
dracut: + [ -z yes ]
dracut: + echo <6>dracut: Starting plymouth daemon
dracut: + [ yes != yes ]
dracut: + [ -x /bin/plymouthd ]
dracut: + /bin/plymouthd --attach-to-session
dracut: + /lib/udev/console_init tty0
dracut: + vinfo
dracut: + read line
dracut: + /bin/plymouth --show-splash
dracut: + [ -e /pre-trigger/30parse-dm.sh ]
dracut: + . /pre-trigger/30parse-dm.sh
dracut: + getarg rd_NO_DM
dracut: + set +x
dracut: + return 0
dracut: rd_NO_DM: removing DM RAID activation
dracut: + info rd_NO_DM: removing DM RAID activation
dracut: + check_quiet
dracut: + [ -z yes ]
dracut: + echo <6>dracut: rd_NO_DM: removing DM RAID activation
dracut: + [ yes != yes ]
dracut: + udevproperty rd_NO_DM=1
dracut: + [ -z 147 ]
dracut: + [ 147 -ge 143 ]
dracut: + udevadm control --property=rd_NO_DM=1
dracut: rd_NO_MD: removing MD RAID activation
dracut: + [ -e /pre-trigger/30parse-md.sh ]
dracut: + . /pre-trigger/30parse-md.sh
dracut: + getarg rd_NO_MD
dracut: + set +x
dracut: + return 0
dracut: + info rd_NO_MD: removing MD RAID activation
dracut: + check_quiet
dracut: + [ -z yes ]
dracut: + echo <6>dracut: rd_NO_MD: removing MD RAID activation
dracut: + [ yes != yes ]
dracut: + udevproperty rd_NO_MD=1
dracut: + [ -z 147 ]
dracut: + [ 147 -ge 143 ]
dracut: + udevadm control --property=rd_NO_MD=1
dracut: + [ -e /etc/mdadm.conf ]
dracut: + getarg rd_NO_MDIMSM
dracut: + set +x
dracut: + return 1
dracut: + getarg noiswmd
dracut: + set +x
dracut: + return 1
dracut: + getarg nodmraid
dracut: + set +x
dracut: + return 1
dracut: + udevadm trigger --action=add
dracut: + getarg rdbreak=initqueue
dracut: + set +x
dracut: + return 1
dracut: + i=0
dracut: + :
dracut: + check_finished
dracut: + local f
dracut: + [ -e /initqueue-finished/block.sh ]
dracut: + . /initqueue-finished/block.sh
dracut: + [ -e /dev/root ]
dracut: + return 1
dracut: + udevsettle
dracut: + [ -z 147 ]
dracut: + [ 147 -ge 143 ]
dracut: + udevadm settle --exit-if-exists=/initqueue/work
e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: setting latency timer to 64
  alloc irq_desc for 44 on node -1
  alloc kstat_irqs on node -1
e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:32:0e:33
e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008ff-0ff
ACPI: WMI: Mapper loaded
thinkpad_acpi: ThinkPad ACPI Extras v0.24
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 6DET60WW (3.10 ), EC 7XHT22WW-1.04
thinkpad_acpi: Lenovo ThinkPad X200, model 7459H94
thinkpad_acpi: detected a 16-level brightness capable ThinkPad
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
Registered led device: tpacpi::thinklight
Registered led device: tpacpi::power
Registered led device: tpacpi::standby
Registered led device: tpacpi::thinkvantage
thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
  alloc irq_desc for 45 on node -1
  alloc kstat_irqs on node -1
HDA Intel 0000:00:1b.0: irq 45 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
cfg80211: Calling CRDA to update world regulatory domain
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
iwlagn: Copyright(c) 2003-2010 Intel Corporation
iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:03:00.0: setting latency timer to 64
iwlagn 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
  alloc irq_desc for 46 on node -1
  alloc kstat_irqs on node -1
iwlagn 0000:03:00.0: irq 46 for MSI/MSI-X
iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x1060)
phy0: Selected rate control algorithm 'iwl-agn-rs'
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
  alloc irq_desc for 47 on node -1
  alloc kstat_irqs on node -1
ahci 0000:00:1f.2: irq 47 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826100 irq 47
ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826180 irq 47
ata3: DUMMY
ata4: DUMMY
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ATA-8: ST9160412AS, 0003LVM1, max UDMA/100
ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/100
ata1.00: configured for UDMA/100
ata1: EH complete
scsi 0:0:0:0: Direct-Access     ATA      ST9160412AS      0003 PQ: 0 ANSI: 5
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: ATAPI: HL-DT-ST DVDRAM GU10N, MX05, max UDMA/133
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata2.00: configured for UDMA/133
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GU10N     MX05 PQ: 0 ANSI: 5
i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Attached scsi generic sg1 type 5
dracut: + check_finished
dracut: + local f
dracut: + [ -e /initqueue-finished/block.sh ]
dracut: + . /initqueue-finished/block.sh
dracut: + [ -e /dev/root ]
dracut: + return 1
dracut: + [ -f /initqueue/work ]
dracut: + rm /initqueue/work
dracut: + [ -e /initqueue/cryptroot-ask-sda2.sh ]
dracut: + job=/initqueue/cryptroot-ask-sda2.sh . /initqueue/cryptroot-ask-sda2.sh
dracut: + [ -e /initqueue/cryptroot-ask-sda2.sh ]
dracut: + rm /initqueue/cryptroot-ask-sda2.sh
dracut: + /sbin/cryptroot-ask /dev/sda2 luks-fb264012-c3c0-4582-ab76-23b4454215b3
dracut: + luksname=luks-fb264012-c3c0-4582-ab76-23b4454215b3
dracut: + [ /dev/sda2 != /dev/sda2 ]
dracut: + device=/dev/sda2
dracut: + [ -f /etc/crypttab ]
dracut: + getargs rd_NO_CRYPTTAB
dracut: + set +x
dracut: + return 1
dracut: + read name dev rest
dracut: + [ -z luks-fb264012-c3c0-4582-ab76-23b4454215b3 -o luks-fb264012-c3c0-4582-ab76-23b4454215b3 != luks-fb264012-c3c0-4582-ab76-23b4454215b3 ]
dracut: + [ UUID = UUID ]
dracut: + [ luks-fb264012-c3c0-4582-ab76-23b4454215b3 = luks-fb264012-c3c0-4582-ab76-23b4454215b3 ]
dracut: + luksname=luks-fb264012-c3c0-4582-ab76-23b4454215b3
dracut: + break
dracut: + unset name dev rest
dracut: + getargs rd_LUKS_UUID=
dracut: + set +x
dracut: + return 0
dracut: + LUKS=luks-fb264012-c3c0-4582-ab76-23b4454215b3
dracut: + ask=1
dracut: + num=0
dracut: + [ -n luks-fb264012-c3c0-4582-ab76-23b4454215b3  ]
dracut: + ask=0
dracut: + luuid=fb264012-c3c0-4582-ab76-23b4454215b3
dracut: + num=1
dracut: + luks=fb264012-c3c0-4582-ab76-23b4454215b3
dracut: + [  != fb264012-c3c0-4582-ab76-23b4454215b3 ]
dracut: + ask=1
dracut: + [ 1 -ge 2 -a 1 = 1 ]
dracut: luksOpen /dev/sda2 luks-fb264012-c3c0-4582-ab76-23b4454215b3
dracut: + unset LUKS luks luuid
dracut: + [ 1 -gt 0 ]
dracut: + info luksOpen /dev/sda2 luks-fb264012-c3c0-4582-ab76-23b4454215b3
dracut: + check_quiet
dracut: + [ -z  ]
dracut: + DRACUT_QUIET=yes
dracut: + getarg rdinfo
dracut: + set +x
dracut: + return 1
dracut: + getarg quiet
dracut: + set +x
dracut: + return 1
dracut: + DRACUT_QUIET=yes
dracut: + echo <6>dracut: luksOpen /dev/sda2 luks-fb264012-c3c0-4582-ab76-23b4454215b3
dracut: + [ yes != yes ]
dracut: + [ 1 -eq 1 ]
dracut: + prompt=Password for filesystem
dracut: + flock -s 9
dracut: + /bin/plymouth ask-for-password --prompt Password for filesystem --command=/sbin/cryptsetup luksOpen -T1 /dev/sda2 luks-fb264012-c3c0-4582-ab76-23b4454215b3
padlock: VIA PadLock not detected.
Intel AES-NI instructions are not detected.
dracut: + unset ask device luksname
dracut: +
dracut: + udevsettle
dracut: + [ -z  ]
dracut: + udevadm --version
dracut: + UDEVVERSION=147
dracut: + [ 147 -ge 143 ]
dracut: + udevadm settle --exit-if-exists=/initqueue/work
dracut: + exit 0
dracut: + check_finished
dracut: + local f
dracut: + [ -e /initqueue-finished/block.sh ]
dracut: + . /initqueue-finished/block.sh
dracut: + [ -e /dev/root ]
dracut: + return 1
dracut: + udevadm settle --timeout=0
dracut: + modprobe scsi_wait_scan
dracut: + rmmod scsi_wait_scan
dracut: + udevadm settle --timeout=0
dracut: + [ -e /initqueue-settled/blocksymlink.sh ]
dracut: + job=/initqueue-settled/blocksymlink.sh . /initqueue-settled/blocksymlink.sh
dracut: + [ -e /dev/mapper/VolGroup-lv_root ]
dracut: + check_finished
dracut: + local f
dracut: + [ -e /initqueue-finished/block.sh ]
dracut: + . /initqueue-finished/block.sh
dracut: + [ -e /dev/root ]
dracut: + return 1
dracut: + [ -e /initqueue-settled/lvm_scan.sh ]
dracut: + job=/initqueue-settled/lvm_scan.sh . /initqueue-settled/lvm_scan.sh
dracut: + [ -e /initqueue-settled/lvm_scan.sh ]
dracut: + rm /initqueue-settled/lvm_scan.sh
dracut: + /sbin/lvm_scan
dracut: + getargs rd_LVM_VG=
dracut: + set +x
dracut: + return 1
dracut: + VGS=
dracut: + getargs rd_LVM_LV=
dracut: + set +x
dracut: + return 0
dracut: + LVS=VolGroup/lv_root
dracut: + [ -d /etc/lvm ]
dracut: + [ -e /tmp/.lvm_scan-dm-0 ]
dracut: + echo -n dm-0
dracut: + lvmdevs=dm-0
dracut: + [ ! -e /etc/lvm/lvm.conf ]
dracut: + lvm version
dracut: + nopoll= --poll n
dracut: + [ -n VolGroup/lv_root  ]
dracut: + info Scanning devices dm-0  for LVM logical volumes VolGroup/lv_root
dracut: + check_quiet
dracut: + [ -z  ]
dracut: + DRACUT_QUIET=yes
dracut: + getarg rdinfo
dracut: + set +x
dracut: + return 1
dracut: Scanning devices dm-0  for LVM logical volumes VolGroup/lv_root 
dracut: + getarg quiet
dracut: + set +x
dracut: + return 1
dracut: + DRACUT_QUIET=yes
dracut: + echo <6>dracut: Scanning devices dm-0  for LVM logical volumes VolGroup/lv_root
dracut: + [ yes != yes ]
dracut: + lvm lvscan --ignorelockingfailure
dracut: + vinfo
dracut: + read line
dracut: + info inactive '/dev/VolGroup/lv_root' [50.00 GiB] inherit
dracut: + check_quiet
dracut: + [ -z yes ]
dracut: inactive '/dev/VolGroup/lv_root' [50.00 GiB] inherit
dracut: + echo <6>dracut: inactive '/dev/VolGroup/lv_root' [50.00 GiB] inherit
dracut: + [ yes != yes ]
dracut: + read line
dracut: + info inactive '/dev/VolGroup/lv_home' [94.83 GiB] inherit
dracut: inactive '/dev/VolGroup/lv_home' [94.83 GiB] inherit
dracut: + check_quiet
dracut: + [ -z yes ]
dracut: + echo <6>dracut: inactive '/dev/VolGroup/lv_home' [94.83 GiB] inherit
dracut: + [ yes != yes ]
dracut: + read line
dracut: + info inactive '/dev/VolGroup/lv_swap' [3.72 GiB] inherit
dracut: inactive '/dev/VolGroup/lv_swap' [3.72 GiB] inherit
dracut: + check_quiet
dracut: + [ -z yes ]
dracut: + echo <6>dracut: inactive '/dev/VolGroup/lv_swap' [3.72 GiB] inherit
dracut: + [ yes != yes ]
dracut: + read line
dracut: + lvm lvchange -ay --ignorelockingfailure --poll n+  --ignoremonitoringvinfo
dracut: + read line
dracut: VolGroup/lv_root
dracut: + [ -z VolGroup/lv_root  -o -n  ]
dracut: + [  ]
dracut: + unset lvmwritten
dracut: + check_finished
dracut: + local f
dracut: + [ -e /initqueue-finished/block.sh ]
dracut: + . /initqueue-finished/block.sh
dracut: + [ -e /dev/root ]
dracut: + return 0
dracut: + break 2
dracut: + unset job
dracut: + unset queuetriggered
dracut: + getarg rdbreak=pre-mount
dracut: + set +x
dracut: + return 1
dracut: + source_all pre-mount
dracut: + local f
dracut: + [ pre-mount ]
dracut: + [ -d /pre-mount ]
dracut: + return
dracut: + getarg rdbreak=mount
dracut: + set +x
dracut: + return 1
dracut: + i=0
dracut: + :
dracut: + [ -d /sysroot/proc ]
dracut: + [ -f /mount/10resume.sh ]
dracut: + . /mount/10resume.sh
dracut: + [ -s /.resume -a -b  ]
dracut: + [ -d /sysroot/proc ]
dracut: + [ -f /mount/99mount-root.sh ]
dracut: + . /mount/99mount-root.sh
dracut: + . /lib/dracut-lib.sh
dracut: + setdebug
dracut: + [ -z yes ]
dracut: + [ yes = yes ]
dracut: + set -x
dracut: + [ -n block:/dev/mapper/VolGroup-lv_root -a -z  ]
dracut: + mount -t auto -o ro /dev/mapper/VolGroup-lv_root /sysroot
EXT4-fs (dm-1): INFO: recovery required on readonly filesystem
EXT4-fs (dm-1): write access will be enabled during recovery
EXT4-fs (dm-1): recovery complete
EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
dracut: + ROOTFS_MOUNTED=yes
dracut: + getarg rd_NO_FSTAB
dracut: + set +x
dracut: + return 1
dracut: + getarg rootflags
dracut: + set +x
dracut: + return 1
dracut: + [ -f /sysroot/etc/fstab ]
dracut: + [ -L /sysroot/etc/fstab ]
dracut: + rootfs=auto
dracut: + rootopts=defaults
dracut: + read dev mp fs opts rest
dracut: + [  !=  ]
dracut: + [  = / ]
dracut: + read dev mp fs opts rest
dracut: + [  != # ]
dracut: + continue
dracut: + read dev mp fs opts rest
dracut: + [  != # ]
dracut: + continue
dracut: + read dev mp fs opts rest
dracut: + [  != # ]
dracut: + continue
dracut: + read dev mp fs opts rest
dracut: + [  != # ]
dracut: + continue
dracut: + read dev mp fs opts rest
dracut: + [  != # ]
dracut: + continue
dracut: + read dev mp fs opts rest
dracut: + [  != # ]
dracut: + continue
dracut: + read dev mp fs opts rest
dracut: + [  != # ]
dracut: + continue
dracut: + read dev mp fs opts rest
dracut: + [ /dev/mapper/VolGroup-lv_root != /dev/mapper/VolGroup-lv_root ]
dracut: + [ / = / ]
dracut: + rootfs=ext4
dracut: + rootopts=defaults
dracut: + break
dracut: + filter_rootopts defaults
dracut: + rootopts=defaults
dracut: + local OLDIFS=
dracut: 
dracut: + IFS=,
dracut: + set -- defaults
dracut: + IFS=
dracut: 
dracut: + local v
dracut: + [ 1 -gt 0 ]
dracut: + shift
dracut: + [ 0 -gt 0 ]
dracut: + rootopts=
dracut: + echo
dracut: + rootopts=
dracut: + [ -n  ]
dracut: + [ -d /sysroot/proc ]
dracut: + break
dracut: + i=1
dracut: + [ 1 -gt 20 ]
dracut: + :
dracut: + [ -d /sysroot/proc ]
dracut: + break
dracut: + + echo -n Mounted root filesystem
dracut: vinfo
dracut: + + read lineread dev mp rest
dracut: 
dracut: + [ / = /sysroot ]
dracut: + read dev mp rest
dracut: + [ /proc = /sysroot ]
dracut: + read dev mp rest
dracut: + [ /sys = /sysroot ]
dracut: + read dev mp rest
dracut: + [ /dev = /sysroot ]
dracut: + read dev mp rest
dracut: + [ /dev/pts = /sysroot ]
dracut: + read dev mp rest
dracut: + [ /dev/shm = /sysroot ]
dracut: + read dev mp rest
dracut: + [ /sysroot = /sysroot ]
dracut: + echo /dev/mapper/VolGroup-lv_root
dracut: + read dev mp rest
dracut: + info Mounted root filesystem /dev/mapper/VolGroup-lv_root
dracut: + check_quiet
dracut: Mounted root filesystem /dev/mapper/VolGroup-lv_root
dracut: + [ -z yes ]
dracut: + echo <6>dracut: Mounted root filesystem /dev/mapper/VolGroup-lv_root
dracut: + [ yes != yes ]
dracut: + read line
dracut: + getarg rdbreak=pre-pivot
dracut: + set +x
dracut: + return 1
dracut: + source_all pre-pivot
dracut: + local f
dracut: + [ pre-pivot ]
dracut: + [ -d /pre-pivot ]
dracut: + [ -e /pre-pivot/30crypt-cleanup.sh ]
dracut: + . /pre-pivot/30crypt-cleanup.sh
dracut: + cryptsetup luksClose /dev/mapper/luks-fb264012-c3c0-4582-ab76-23b4454215b3
dracut: + [ -e /pre-pivot/31crypt-cleanup.sh ]
dracut: + . /pre-pivot/31crypt-cleanup.sh
dracut: + cryptsetup luksClose /dev/mapper/luks-fb264012-c3c0-4582-ab76-23b4454215b3
dracut: + [ -e /pre-pivot/50selinux-loadpolicy.sh ]
dracut: + . /pre-pivot/50selinux-loadpolicy.sh
dracut: + rd_load_policy
dracut: + getarg selinux=0
dracut: + set +x
dracut: + return 1
dracut: + SELINUX=enforcing
dracut: + [ -e /sysroot/etc/selinux/config ]
dracut: + . /sysroot/etc/selinux/config
dracut: + SELINUX=enforcing
dracut: + SELINUXTYPE=targeted
dracut: + permissive=0
dracut: + getarg enforcing=0
dracut: + set +x
dracut: + return 1
dracut: + [ 1 -eq 0 -o enforcing = permissive ]
dracut: + [ -x /sysroot/usr/sbin/load_policy -o -x /sysroot/sbin/load_policy ]
dracut: Loading SELinux policy
dracut: + ret=0
dracut: + info Loading SELinux policy
dracut: + check_quiet
dracut: + [ -z yes ]
dracut: + echo <6>dracut: Loading SELinux policy
dracut: + [ yes != yes ]
dracut: + vinfo
dracut: + read line
dracut: + info + [ -x /sysroot/sbin/load_policy ]
dracut: + check_quiet
dracut: + [ -z yes ]
dracut: + echo <6>dracut: + [ -x /sysroot/sbin/load_policy ]
dracut: + [ -x /sysroot/sbin/load_policy ]
dracut: + [ yes != yes ]
dracut: + read line
dracut: + info + chroot /sysroot /sbin/load_policy -i
dracut: + chroot /sysroot /sbin/load_policy -i
dracut: + check_quiet
dracut: + [ -z yes ]
dracut: + echo <6>dracut: + chroot /sysroot /sbin/load_policy -i
dracut: + [ yes != yes ]
dracut: + read line
type=1404 audit(1279766668.584:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
SELinux: 2048 avtab hash slots, 198429 rules.
SELinux: 2048 avtab hash slots, 198429 rules.
SELinux:  9 users, 13 roles, 3305 types, 164 bools, 1 sens, 1024 cats
SELinux:  77 classes, 198429 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev dm-1, type ext4), uses xattr
type=1403 audit(1279766669.412:3): policy loaded auid=4294967295 ses=4294967295
dracut: + info + ret=0
dracut: + check_quiet
dracut: + [ -z yes ]
dracut: + ret=0
dracut: + echo <6>dracut: + ret=0
dracut: + [ yes != yes ]
dracut: + read line
dracut: + [ enforcing = disabled ]
dracut: + [ 0 -eq 0 -o 0 -eq 2 ]
dracut: + [ -e /sysroot/.autorelabel ]
dracut: + mount --bind /dev /sysroot/dev
dracut: + chroot /sysroot /sbin/restorecon -R /dev
dracut: + return 0
dracut: + [ -e /pre-pivot/90plymouth-newroot.sh ]
dracut: + . /pre-pivot/90plymouth-newroot.sh
dracut: + [ -x /bin/plymouth ]
dracut: + /bin/plymouth --newroot=/sysroot
dracut: + getarg init=
dracut: + set +x
dracut: + return 1
dracut: + [ -f /sysroot -a -x /sysroot ]
dracut: + [ -f /sysroot/sbin/init -a -x /sysroot/sbin/init ]
dracut: + INIT=/sbin/init
dracut: + break
dracut: + [ /sbin/init ]
dracut: + getarg rdbreak
dracut: + set +x
dracut: + return 1
dracut: + udevadm control --stop-exec-queue
dracut: + HARD=
dracut: + pidof udevd
dracut: + pidof udevd
dracut: + kill 362
dracut: + kill 354
dracut: + kill 83
dracut: + HARD=-9
dracut: + pidof udevd
dracut: + pidof udevd
dracut: + kill -9 354
dracut: + HARD=-9
dracut: + pidof udevd
dracut: + export -p
dracut: + i=export
dracut: + i=
dracut: + i=
dracut: + [  = root -o  = PATH -o  = HOME -o  = TERM ]
dracut: + unset
dracut: + i=HOME='/'
dracut: + i=HOME='/'
dracut: + i=HOME
dracut: + [ HOME = root -o HOME = PATH -o HOME = HOME -o HOME = TERM ]
dracut: + i=export
dracut: + i=
dracut: + i=
dracut: + [  = root -o  = PATH -o  = HOME -o  = TERM ]
dracut: + unset
dracut: + i=KEYBOARDTYPE='pc'
dracut: + i=KEYBOARDTYPE='pc'
dracut: + i=KEYBOARDTYPE
dracut: + [ KEYBOARDTYPE = root -o KEYBOARDTYPE = PATH -o KEYBOARDTYPE = HOME -o KEYBOARDTYPE = TERM ]
dracut: + unset KEYBOARDTYPE
dracut: + i=export
dracut: + i=
dracut: + i=
dracut: + [  = root -o  = PATH -o  = HOME -o  = TERM ]
dracut: + unset
dracut: + i=KEYTABLE='us'
dracut: + i=KEYTABLE='us'
dracut: + i=KEYTABLE
dracut: + [ KEYTABLE = root -o KEYTABLE = PATH -o KEYTABLE = HOME -o KEYTABLE = TERM ]
dracut: + unset KEYTABLE
dracut: + i=export
dracut: + i=
dracut: + i=
dracut: + [  = root -o  = PATH -o  = HOME -o  = TERM ]
dracut: + unset
dracut: + i=LANG='en_US.UTF-8'
dracut: + i=LANG='en_US.UTF-8'
dracut: + i=LANG
dracut: + [ LANG = root -o LANG = PATH -o LANG = HOME -o LANG = TERM ]
dracut: + unset LANG
dracut: + i=export
dracut: + i=
dracut: + i=
dracut: + [  = root -o  = PATH -o  = HOME -o  = TERM ]
dracut: + unset
dracut: + i=PATH='/sbin:/bin:/usr/sbin:/usr/bin'
dracut: + i=PATH='/sbin:/bin:/usr/sbin:/usr/bin'
dracut: + i=PATH
dracut: + [ PATH = root -o PATH = PATH -o PATH = HOME -o PATH = TERM ]
dracut: + i=export
dracut: + i=
dracut: + i=
dracut: + [  = root -o  = PATH -o  = HOME -o  = TERM ]
dracut: + unset
dracut: + i=PWD='/'
dracut: + i=PWD='/'
dracut: + i=PWD
dracut: + [ PWD = root -o PWD = PATH -o PWD = HOME -o PWD = TERM ]
dracut: + unset PWD
dracut: + i=export
dracut: + i=
dracut: + i=
dracut: + [  = root -o  = PATH -o  = HOME -o  = TERM ]
dracut: Switching root
dracut: + unset
dracut: + i=SYSFONT='latarcyrheb-sun16'
dracut: + i=SYSFONT='latarcyrheb-sun16'
dracut: + i=SYSFONT
dracut: + [ SYSFONT = root -o SYSFONT = PATH -o SYSFONT = HOME -o SYSFONT = TERM ]
dracut: + unset SYSFONT
dracut: + i=export
dracut: + i=
dracut: + i=
dracut: + [  = root -o  = PATH -o  = HOME -o  = TERM ]
dracut: + unset
dracut: + i=TERM='linux'
dracut: + i=TERM='linux'
dracut: + i=TERM
dracut: + [ TERM = root -o TERM = PATH -o TERM = HOME -o TERM = TERM ]
dracut: + i=export
dracut: + i=
dracut: + i=
dracut: + [  = root -o  = PATH -o  = HOME -o  = TERM ]
dracut: + unset
dracut: + i=crashkernel='128M'
dracut: + i=crashkernel='128M'
dracut: + i=crashkernel
dracut: + [ crashkernel = root -o crashkernel = PATH -o crashkernel = HOME -o crashkernel = TERM ]
dracut: + unset crashkernel
dracut: + i=export
dracut: + i=
dracut: + i=
dracut: + [  = root -o  = PATH -o  = HOME -o  = TERM ]
dracut: + unset
dracut: + i=rd_LUKS_UUID='luks-fb264012-c3c0-4582-ab76-23b4454215b3'
dracut: + i=rd_LUKS_UUID='luks-fb264012-c3c0-4582-ab76-23b4454215b3'
dracut: + i=rd_LUKS_UUID
dracut: + [ rd_LUKS_UUID = root -o rd_LUKS_UUID = PATH -o rd_LUKS_UUID = HOME -o rd_LUKS_UUID = TERM ]
dracut: + unset rd_LUKS_UUID
dracut: + i=export
dracut: + i=
dracut: + i=
dracut: + [  = root -o  = PATH -o  = HOME -o  = TERM ]
dracut: + unset
dracut: + i=rd_LVM_LV='VolGroup/lv_root'
dracut: + i=rd_LVM_LV='VolGroup/lv_root'
dracut: + i=rd_LVM_LV
dracut: + [ rd_LVM_LV = root -o rd_LVM_LV = PATH -o rd_LVM_LV = HOME -o rd_LVM_LV = TERM ]
dracut: + unset rd_LVM_LV
dracut: + initargs=
dracut: + read CLINE
dracut: + getarg init=
dracut: + set +x
dracut: + return 1
dracut: + set ro root=/dev/mapper/VolGroup-lv_root rd_LVM_LV=VolGroup/lv_root rd_LUKS_UUID=luks-fb264012-c3c0-4582-ab76-23b4454215b3 rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us rdshell rdinitdebug crashkernel=128M 1
dracut: + shift
dracut: + initargs= 1
dracut: + getarg rdcopystate
dracut: + set +x
dracut: + return 1
dracut: + info Switching root
dracut: + check_quiet
dracut: + [ -z yes ]
dracut: + echo <6>dracut: Switching root
dracut: + [ yes != yes ]
dracut: + wait_for_loginit
dracut: + getarg rdinitdebug
dracut: + set +x
dracut: + return 0
dracut: + set +x
udev: starting version 147
WARNING! power/level is deprecated; use power/control instead
cfg80211: Calling CRDA for country: CN
xhci_hcd 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
xhci_hcd 0000:05:00.0: setting latency timer to 64
xhci_hcd 0000:05:00.0: xHCI Host Controller
xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 9
xhci_hcd 0000:05:00.0: irq 19, io mem 0xf1f00000
usb usb9: No SuperSpeed endpoint companion for config 1  interface 0 altsetting 0 ep 129: using minimum values
usb usb9: New USB device found, idVendor=1d6b, idProduct=0003
usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb9: Product: xHCI Host Controller
usb usb9: Manufacturer: Linux 2.6.35-rc5 xhci_hcd
usb usb9: SerialNumber: 0000:05:00.0
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 9-0:1.0: USB hub found
hub 9-0:1.0: 4 ports detected
usb 9-1: new SuperSpeed USB device using xhci_hcd and address 2
xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
usb 9-1: New USB device found, idVendor=1058, idProduct=1123
usb 9-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 9-1: Product: My Book 3.0
usb 9-1: Manufacturer: Western Digital
usb 9-1: SerialNumber: 574341545230383135353130
input: PC Speaker as /devices/platform/pcspkr/input/input11
cfg80211: Regulatory domain changed to country: CN
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (N/A, 3000 mBm)
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
Initializing USB Mass Storage driver...
scsi4 : usb-storage 9-1:1.0
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
scsi 4:0:0:0: Direct-Access     WD       My Book 3.0 1123 1006 PQ: 0 ANSI: 4
sd 4:0:0:0: Attached scsi generic sg2 type 0
sd 4:0:0:0: [sdb] 1953519616 512-byte logical blocks: (1.00 TB/931 GiB)
xhci_hcd 0000:05:00.0: WARN: Stalled endpoint
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 0a 00 10 00
sd 4:0:0:0: [sdb] Assuming drive cache: write through
xhci_hcd 0000:05:00.0: WARN: Stalled endpoint
sd 4:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
xhci_hcd 0000:05:00.0: WARN: Stalled endpoint
sd 4:0:0:0: [sdb] Assuming drive cache: write through
sd 4:0:0:0: [sdb] Attached SCSI disk
EXT4-fs (dm-1): re-mounted. Opts: (null)
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
SELinux: initialized (dev sda1, type ext4), uses xattr
EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
SELinux: initialized (dev dm-2, type ext4), uses xattr
Adding 3899388k swap on /dev/mapper/VolGroup-lv_swap.  Priority:-1 extents:1 across:3899388k 
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
microcode: CPU1 sig=0x1067a, pf=0x80, revision=0xa07
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
microcode: Microcode Update Driver: v2.00 removed.
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
ADDRCONF(NETDEV_UP): wlan0: link is not ready
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
Bluetooth: L2CAP ver 2.14
Bluetooth: L2CAP socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Ebtables v2.0 registered
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
lo: Disabled Privacy Extensions
SELinux: initialized (dev proc, type proc), uses genfs_contexts
fuse init (API version 7.14)
EXT4-fs (sdb1): recovery complete
EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
SELinux: initialized (dev sdb1, type ext4), uses xattr
wlan0: deauthenticating from 00:1c:f6:62:f3:00 by local choice (reason=3)
wlan0: direct probe to 00:1c:f6:62:f1:d0 (try 1)
wlan0: direct probe to 00:1c:f6:62:f1:d0 (try 1)
wlan0: authenticate with 00:1c:f6:62:f3:00 (try 1)
wlan0: authenticated
wlan0: associate with 00:1c:f6:62:f3:00 (try 1)
wlan0: RX AssocResp from 00:1c:f6:62:f3:00 (capab=0x431 status=0 aid=1)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
lo: Disabled Privacy Extensions
e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
device eth0 entered promiscuous mode
e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
br0: port 1(eth0) entering forwarding state
br0: port 1(eth0) entering forwarding state
br0: no IPv6 routers present
eth0: no IPv6 routers present
device vnet0 entered promiscuous mode
br0: new device vnet0 does not support netpoll (disabling)
br0: port 2(vnet0) entering forwarding state
br0: port 2(vnet0) entering forwarding state
vnet0: no IPv6 routers present
kvm: 19605: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0x0
kvm: 19605: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x130079
kvm: 19605: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0xffdb79de
kvm: 19605: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x530079
kvm: 19605: cpu1 unimplemented perfctr wrmsr: 0xc1 data 0x0
kvm: 19605: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x130079
kvm: 19605: cpu1 unimplemented perfctr wrmsr: 0xc1 data 0xffdb79de
kvm: 19605: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x530079
br0: port 2(vnet0) entering forwarding state
device vnet0 left promiscuous mode
br0: port 2(vnet0) entering disabled state
xhci_hcd 0000:05:00.0: WARN: Stalled endpoint
sd 4:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1 sdb2
SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem sdb2
Ending clean XFS mount for filesystem: sdb2
SELinux: initialized (dev sdb2, type xfs), uses xattr
flush-8:16 used greatest stack depth: 2136 bytes left
device vnet0 entered promiscuous mode
br0: new device vnet0 does not support netpoll (disabling)
br0: port 2(vnet0) entering forwarding state
br0: port 2(vnet0) entering forwarding state
vnet0: no IPv6 routers present
kvm: 21822: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0x0
kvm: 21822: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x130079
kvm: 21822: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0xffdb79de
kvm: 21822: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x530079
kvm: 21822: cpu1 unimplemented perfctr wrmsr: 0xc1 data 0x0
kvm: 21822: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x130079
kvm: 21822: cpu1 unimplemented perfctr wrmsr: 0xc1 data 0xffdb79de
kvm: 21822: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x530079
br0: port 2(vnet0) entering forwarding state
device vnet0 left promiscuous mode
br0: port 2(vnet0) entering disabled state
device vnet0 entered promiscuous mode
br0: new device vnet0 does not support netpoll (disabling)
br0: port 2(vnet0) entering forwarding state
br0: port 2(vnet0) entering forwarding state
vnet0: no IPv6 routers present
kvm: 23215: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0x0
kvm: 23215: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x130079
kvm: 23215: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0xffdb79de
kvm: 23215: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x530079
kvm: 23215: cpu1 unimplemented perfctr wrmsr: 0xc1 data 0x0
kvm: 23215: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x130079
kvm: 23215: cpu1 unimplemented perfctr wrmsr: 0xc1 data 0xffdb79de
kvm: 23215: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x530079
kvm: 23215: cpu0 unhandled wrmsr: 0x198 data 0
kvm: 23215: cpu1 unhandled wrmsr: 0x198 data 0
kvm: 23215: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0x0
kvm: 23215: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x130079
kvm: 23215: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0xffdb79de
kvm: 23215: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x530079
kvm: 23215: cpu1 unimplemented perfctr wrmsr: 0xc1 data 0x0
kvm: 23215: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x130079
kvm: 23215: cpu1 unimplemented perfctr wrmsr: 0xc1 data 0xffdb79de
kvm: 23215: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x530079
general protection fault: 0000 [#1] SMP 
last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/energy_full
CPU 0 
Modules linked in: xfs exportfs sit tunnel4 fuse ebtable_nat ebtables rfcomm sco bridge stp llc bnep l2cap autofs4 sunrpc xt_physdev ipt_MASQUERADE iptable_nat nf_nat ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_table mperf dm_mirror dm_region_hash dm_log vhost_net macvtap macvlan tun kvm_intel kvm uinput usb_storage sr_mod cdrom pcspkr xhci_hcd ext4 mbcache jbd2 cryptd aes_x86_64 aes_generic xts gf128mul dm_crypt sg sd_mod crc_t10dif i2c_i801 ahci libahci arc4 iTCO_wdt ecb iTCO_vendor_support iwlagn iwlcore mac80211 cfg80211 snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd_page_alloc thinkpad_acpi hwmon snd soundcore wmi e1000e btusb bluetooth rfkill i915 drm_kms_helper drm i2c_algo_bit i2c_core video output dm_mod [last unloaded: microcode]

Pid: 1604, comm: cups-polld Not tainted 2.6.35-rc5 #1 7459H94/7459H94
RIP: 0010:[<ffffffffa061cb54>]  [<ffffffffa061cb54>] __br_deliver+0x64/0xe0 [bridge]
RSP: 0018:ffff880134cbb778  EFLAGS: 00010296
RAX: 5a5a5a5a5a5a5a5a RBX: ffff880035d2c980 RCX: 0000000000000003
RDX: 0000000000001c70 RSI: ffff880125154c98 RDI: 0000000000000000
RBP: ffff880134cbb798 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88012331c288
R13: ffff88012331c2b0 R14: ffff88012e252c16 R15: ffff880035d2c000
FS:  00007ffa879807c0(0000) GS:ffff88000b000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f99ba6c5020 CR3: 0000000125c6d000 CR4: 00000000000426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cups-polld (pid: 1604, threadinfo ffff880134cba000, task ffff8801251542d0)
Stack:
 ffff880180000000 ffffffff81098ebd ffff88012331c288 ffff880035d2c980
<0> ffff880134cbb7a8 ffffffffa061cc05 ffff880134cbb7d8 ffffffffa061b7b4
<0> ffff88012331c288 ffffffff81c3e5c0 ffff88012331cac8 ffffffff81c3e600
Call Trace:
 [<ffffffff81098ebd>] ? lock_release_holdtime+0x3d/0x190
 [<ffffffffa061cc05>] br_deliver+0x35/0x40 [bridge]
 [<ffffffffa061b7b4>] br_dev_xmit+0xb4/0x160 [bridge]
 [<ffffffff814105bd>] dev_hard_start_xmit+0x2fd/0x450
 [<ffffffff81410329>] ? dev_hard_start_xmit+0x69/0x450
 [<ffffffff81050931>] ? get_parent_ip+0x11/0x50
 [<ffffffff81413046>] dev_queue_xmit+0x4f6/0x7b0
 [<ffffffff81412b9f>] ? dev_queue_xmit+0x4f/0x7b0
 [<ffffffff810997ed>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8106a247>] ? local_bh_enable_ip+0x97/0x100
 [<ffffffff8141bc63>] neigh_resolve_output+0x113/0x3f0
 [<ffffffff81454e74>] ip_finish_output+0x1a4/0x4b0
 [<ffffffff8145550b>] ip_output+0xbb/0x110
 [<ffffffff81453e6d>] ip_local_out+0x2d/0x80
 [<ffffffff81454762>] ip_queue_xmit+0x1c2/0x500
 [<ffffffff814545a0>] ? ip_queue_xmit+0x0/0x500
 [<ffffffff8114db77>] ? __kmalloc_node_track_caller+0x87/0x110
 [<ffffffff8114d9eb>] ? kmem_cache_alloc_node_notrace+0x10b/0x210
 [<ffffffff8114db77>] ? __kmalloc_node_track_caller+0x87/0x110
 [<ffffffff8146a308>] tcp_transmit_skb+0x3f8/0x8a0
 [<ffffffff8146bf0d>] tcp_send_ack+0xdd/0x130
 [<ffffffff8145c666>] tcp_cleanup_rbuf+0x76/0x110
 [<ffffffff8145ee90>] tcp_recvmsg+0x450/0xd10
 [<ffffffff814837fd>] inet_recvmsg+0xcd/0xf0
 [<ffffffff813fbb8d>] sock_recvmsg+0xfd/0x130
 [<ffffffff813fb853>] ? sock_sendmsg+0xf3/0x130
 [<ffffffff810127b9>] ? sched_clock+0x9/0x10
 [<ffffffff81089435>] ? sched_clock_local+0x25/0x90
 [<ffffffff81089558>] ? sched_clock_cpu+0xb8/0x110
 [<ffffffff810956fd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8108961f>] ? cpu_clock+0x6f/0x80
 [<ffffffff8109979d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff810997ed>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff813fbd01>] sys_recvfrom+0xe1/0x170
 [<ffffffff81087662>] ? hrtimer_nanosleep+0x132/0x190
 [<ffffffff8100b06a>] ? sysret_check+0x2e/0x69
 [<ffffffff8109979d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff814e4ef2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100b032>] system_call_fastpath+0x16/0x1b
Code: c9 49 c7 c1 90 ca 61 a0 4c 89 e2 be 03 00 00 00 bf 07 00 00 00 c7 04 24 00 00 00 80 e8 96 c6 e1 e0 83 f8 01 74 31 49 8b 44 24 20 <48> 8b 80 08 05 00 00 48 85 c0 74 0e 48 8b 80 d0 01 00 00 48 8b 
RIP  [<ffffffffa061cb54>] __br_deliver+0x64/0xe0 [bridge]
 RSP <ffff880134cbb778>

------=_Part_56377_113474362.1279855515400--
