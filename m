Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab0ITIAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 04:00:51 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:44985 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755688Ab0ITIAt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 04:00:49 -0400
Date: Mon, 20 Sep 2010 04:00:36 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: graff yang <graff.yang@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kexec <kexec@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        sonic adi <sonic.adi@gmail.com>,
        Chris Lalancette <clalance@redhat.com>, Avi Kivity <avi@redhat.com>
Message-ID: <411686968.1342961284969636518.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4C962617.4020308@kernel.org>
Subject: Re: kvm kdump regression
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Tejun Heo" <tj@kernel.org> wrote:

> On 09/18/2010 02:36 PM, CAI Qian wrote:
> >> Can you please apply the following patch, reproduce the problem
> and
> >> report the kernel log?
> > Tejun, which version this patch is against? Both 2.6.36-rc2-mm1 and
> 2.6.36-rc4-mm1 failed to apply it,
> 
> The patch was against percpu#for-next branch.  Below is a patch
> regenerated against the current linux-next.
Here were the messages when triggering kdump after applied this patch.
SysRq : Trigger a crash
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff812cbaa6>] sysrq_handle_crash+0x16/0x20
PGD c638be067 PUD c61eb1067 PMD 0 
Oops: 0002 [#1] SMP 
last sysfs file: /sys/devices/virtio-pci/virtio2/block/vda/dev
CPU 4 
Modules linked in: ipv6 xfs exportfs virtio_net pcspkr snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc i2c_piix4 i2c_core ext4 mbcache jbd2 floppy virtio_blk virtio_pci virtio_ring virtio ata_generic pata_acpi ata_piix dm_mod [last unloaded: scsi_wait_scan]

Pid: 5055, comm: bash Not tainted 2.6.36-rc4-mm1+ #24 /KVM
RIP: 0010:[<ffffffff812cbaa6>]  [<ffffffff812cbaa6>] sysrq_handle_crash+0x16/0x20
RSP: 0018:ffff880c638a7e38  EFLAGS: 00010092
RAX: 0000000000000010 RBX: 0000000000000063 RCX: 00000000000016b5
RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000063
RBP: ffff880c638a7e38 R08: 0000000000000000 R09: ffffffff8163f5a0
R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff81a73480
R13: 0000000000000286 R14: 0000000000000007 R15: 0000000000000000
FS:  00007f342adb9700(0000) GS:ffff880002880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000c63d8d000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 5055, threadinfo ffff880c638a6000, task ffff880c608e7560)
Stack:
 ffff880c638a7e78 ffffffff812cc0b9 ffff880c674bf680 0000000000000002
<0> ffff880c602e4d80 00007f342adbb000 0000000000000002 fffffffffffffffb
<0> ffff880c638a7ea8 ffffffff812cc16a ffff880c00000002 00007f342adbb000
Call Trace:
 [<ffffffff812cc0b9>] __handle_sysrq+0x129/0x190
 [<ffffffff812cc16a>] write_sysrq_trigger+0x4a/0x50
 [<ffffffff8119f236>] proc_reg_write+0x76/0xb0
 [<ffffffff81145928>] vfs_write+0xc8/0x190
 [<ffffffff811462c1>] sys_write+0x51/0x90
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
Code: d0 88 81 43 6d 25 82 c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f 44 00 00 c7 05 99 ca b3 00 01 00 00 00 0f ae f8 <c6> 04 25 00 00 00 00 01 c9 c3 55 48 89 e5 0f 1f 44 00 00 8d 47 
RIP  [<ffffffff812cbaa6>] sysrq_handle_crash+0x16/0x20
 RSP <ffff880c638a7e38>
CR2: 0000000000000000
Initializing cgroup subsys cpuset
Linux version 2.6.36-rc4-mm1+ (root@localhost.localdomain) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #24 SMP Mon Sep 20 03:44:24 EDT 2010
Command line: ro root=/dev/mapper/VolGroup-lv_root console=tty0 console=ttyS0,115200 SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us no_console_suspend irqpoll maxcpus=1 reset_devices cgroup_disable=memory  memmap=exactmap memmap=640K@0K memmap=130412K@49792K elfcorehdr=180204K memmap=64K$960K memmap=20K$3669996K memmap=272K$4194032K
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000100 - 000000000009a800 (usable)
 BIOS-e820: 000000000009a800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dfffb000 (usable)
 BIOS-e820: 00000000dfffb000 - 00000000e0000000 (reserved)
 BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000ca0000000 (usable)
last_pfn = 0xca0000 max_arch_pfn = 0x400000000
NX (Execute Disable) protection: active
user-defined physical RAM map:
 user: 0000000000000000 - 00000000000a0000 (usable)
 user: 00000000000f0000 - 0000000000100000 (reserved)
 user: 00000000030a0000 - 000000000affb000 (usable)
 user: 00000000dfffb000 - 00000000e0000000 (reserved)
 user: 00000000fffbc000 - 0000000100000000 (reserved)
DMI 2.4 present.
No AGP bridge found
last_pfn = 0xaffb max_arch_pfn = 0x400000000
PAT not supported by CPU.
found SMP MP-table at [ffff8800000f7d40] f7d40
init_memory_mapping: 0000000000000000-000000000affb000
RAMDISK: 0ab4c000 - 0afef000
ACPI: RSDP 00000000000f7cf0 00014 (v00 BOCHS )
ACPI: RSDT 00000000dfffd0d0 00030 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
ACPI: FACP 00000000dffff4f0 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
ACPI: DSDT 00000000dfffd630 01E4B (v01   BXPC   BXDSDT 00000001 INTL 20090123)
ACPI: FACS 00000000dffff480 00040
ACPI: SSDT 00000000dfffd370 002B5 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
ACPI: APIC 00000000dfffd100 001FA (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
No NUMA configuration found
Faking a node at 0000000000000000-000000000affb000
Initmem setup node 0 0000000000000000-000000000affb000
  NODE_DATA [00000000030a0000 - 00000000030c6fff]
kvm-clock: Using msrs 12 and 11
kvm-clock: cpu 0, msr 0:4af5c01, boot clock
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x000000a0
    0: 0x000030a0 -> 0x0000affb
ACPI: PM-Timer IO Port: 0xb008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] enabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] enabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] enabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] enabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] enabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] enabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] enabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x11] lapic_id[0x11] enabled)
ACPI: LAPIC (acpi_id[0x12] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x13] lapic_id[0x13] enabled)
ACPI: LAPIC (acpi_id[0x14] lapic_id[0x14] enabled)
ACPI: LAPIC (acpi_id[0x15] lapic_id[0x15] enabled)
ACPI: LAPIC (acpi_id[0x16] lapic_id[0x16] enabled)
ACPI: LAPIC (acpi_id[0x17] lapic_id[0x17] enabled)
ACPI: LAPIC (acpi_id[0x18] lapic_id[0x18] enabled)
ACPI: LAPIC (acpi_id[0x19] lapic_id[0x19] enabled)
ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x1a] enabled)
ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x1b] enabled)
ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x1c] enabled)
ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x1d] enabled)
ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x1e] enabled)
ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x1f] enabled)
ACPI: LAPIC (acpi_id[0x20] lapic_id[0x20] enabled)
ACPI: LAPIC (acpi_id[0x21] lapic_id[0x21] enabled)
ACPI: LAPIC (acpi_id[0x22] lapic_id[0x22] enabled)
ACPI: LAPIC (acpi_id[0x23] lapic_id[0x23] enabled)
ACPI: LAPIC (acpi_id[0x24] lapic_id[0x24] enabled)
ACPI: LAPIC (acpi_id[0x25] lapic_id[0x25] enabled)
ACPI: LAPIC (acpi_id[0x26] lapic_id[0x26] enabled)
ACPI: LAPIC (acpi_id[0x27] lapic_id[0x27] enabled)
ACPI: LAPIC (acpi_id[0x28] lapic_id[0x28] enabled)
ACPI: LAPIC (acpi_id[0x29] lapic_id[0x29] enabled)
ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x2a] enabled)
ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x2b] enabled)
ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x2c] enabled)
ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x2d] enabled)
ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x2e] enabled)
ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x2f] enabled)
ACPI: LAPIC (acpi_id[0x30] lapic_id[0x30] enabled)
ACPI: LAPIC (acpi_id[0x31] lapic_id[0x31] enabled)
ACPI: IOAPIC (id[0x32] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 50, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 50 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 0000000000100000 - 00000000030a0000
Allocating PCI resources starting at affb000 (gap: affb000:d5000000)
Booting paravirtualized kernel on KVM
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:50 nr_cpu_ids:50 nr_node_ids:1
XXX areas[0]=ffff880005400000
XXX base_addr=ffff880005400000 0
PERCPU: Embedded 29 pages/cpu @ffff880005400000 s88128 r8192 d22464 u131072
pcpu-alloc: s88128 r8192 d22464 u131072 alloc=1*2097152
pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
pcpu-alloc: [0] 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
pcpu-alloc: [0] 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 
pcpu-alloc: [0] 48 49 -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
XXX CPU->UNIT M/O 0:0 1:20000 2:40000 3:60000 4:80000 5:a0000 6:c0000 7:e0000 8:100000 9:120000 10:140000 11:160000 12:180000 13:1a0000 14:1c0000 15:1e0000 16:200000 17:220000 18:240000 19:260000 20:280000 21:2a0000 22:2c0000 23:2e0000 24:300000 25:320000 26:340000 27:360000 28:380000 29:3a0000 30:3c0000 31:3e0000 32:400000 33:420000 34:440000 35:460000 36:480000 37:4a0000 38:4c0000 39:4e0000 40:500000 41:520000 42:540000 43:560000 44:580000 45:5a0000 46:5c0000 47:5e0000 48:600000 49:620000
XXX ss=88128 up=32 us=131072 ns=17 rs=8192 ds=22464
XXX reserved chunk
XXX   -1(f=8192,c=8192,u=2,a=128) -88128 8192 free=8192 contig=8192
XXX percpu allocator dump
XXX  SLOT[12]
XXX   0(f=22464,c=22464,u=2,a=128) -96320 22464 free=22464 contig=22464
kvm-clock: cpu 0, msr 0:5414c01, primary cpu clock
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 32131
Policy zone: DMA32
Kernel command line: ro root=/dev/mapper/VolGroup-lv_root console=tty0 console=ttyS0,115200 SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us no_console_suspend irqpoll maxcpus=1 reset_devices cgroup_disable=memory  memmap=exactmap memmap=640K@0K memmap=130412K@49792K elfcorehdr=180204K memmap=64K$960K memmap=20K$3669996K memmap=272K$4194032K
Misrouted IRQ fixup and polling support enabled
This may significantly impact system performance
Disabling memory control group subsystem
PID hash table entries: 512 (order: 0, 4096 bytes)
Checking aperture...
No AGP bridge found
Subtract (95 early reservations)
  #1 [0004000000 - 0005298a08]   TEXT DATA BSS
  #2 [000ab4c000 - 000afef000]         RAMDISK
  #3 [0005299000 - 0005299079]             BRK
  #4 [000009a800 - 00000f7d40]   BIOS reserved
  #5 [00000f7d40 - 00000f7d50]    MP-table mpf
  #6 [00000f8224 - 0000100000]   BIOS reserved
  #7 [00000f7d50 - 00000f8224]    MP-table mpc
  #8 [0000010000 - 0000012000]      TRAMPOLINE
  #9 [0000012000 - 0000016000]     ACPI WAKEUP
  #10 [0000016000 - 0000017000]         PGTABLE
  #11 [00030a0000 - 00030c7000]       NODE_DATA
  #12 [00030c7000 - 00030c8000]         BOOTMEM
  #13 [00034c8000 - 00034c8030]         BOOTMEM
  #14 [00038c9000 - 00038ca000]         BOOTMEM
  #15 [00038ca000 - 00038cb000]         BOOTMEM
  #16 [0003a00000 - 0003e00000]        MEMMAP 0
  #17 [00030c8000 - 00030c8180]         BOOTMEM
  #18 [00030c8180 - 00030c9980]         BOOTMEM
  #19 [00030ca000 - 00030cb000]         BOOTMEM
  #20 [00030c9980 - 00030c99c3]         BOOTMEM
  #21 [00030c9a00 - 00030c9b50]         BOOTMEM
  #22 [00030c9b80 - 00030c9be8]         BOOTMEM
  #23 [00030c9c00 - 00030c9c68]         BOOTMEM
  #24 [00030c9c80 - 00030c9ce8]         BOOTMEM
  #25 [00030c9d00 - 00030c9d68]         BOOTMEM
  #26 [00030c9d80 - 00030c9de8]         BOOTMEM
  #27 [00030c9e00 - 00030c9e68]         BOOTMEM
  #28 [00030c9e80 - 00030c9ee8]         BOOTMEM
  #29 [00030c9f00 - 00030c9f20]         BOOTMEM
  #30 [00030cb000 - 00030cb149]         BOOTMEM
  #31 [00030cb180 - 00030cb2c9]         BOOTMEM
  #32 [0005400000 - 000541d000]         BOOTMEM
  #33 [0005420000 - 000543d000]         BOOTMEM
  #34 [0005440000 - 000545d000]         BOOTMEM
  #35 [0005460000 - 000547d000]         BOOTMEM
  #36 [0005480000 - 000549d000]         BOOTMEM
  #37 [00054a0000 - 00054bd000]         BOOTMEM
  #38 [00054c0000 - 00054dd000]         BOOTMEM
  #39 [00054e0000 - 00054fd000]         BOOTMEM
  #40 [0005500000 - 000551d000]         BOOTMEM
  #41 [0005520000 - 000553d000]         BOOTMEM
  #42 [0005540000 - 000555d000]         BOOTMEM
  #43 [0005560000 - 000557d000]         BOOTMEM
  #44 [0005580000 - 000559d000]         BOOTMEM
  #45 [00055a0000 - 00055bd000]         BOOTMEM
  #46 [00055c0000 - 00055dd000]         BOOTMEM
  #47 [00055e0000 - 00055fd000]         BOOTMEM
  #48 [0005600000 - 000561d000]         BOOTMEM
  #49 [0005620000 - 000563d000]         BOOTMEM
  #50 [0005640000 - 000565d000]         BOOTMEM
  #51 [0005660000 - 000567d000]         BOOTMEM
  #52 [0005680000 - 000569d000]         BOOTMEM
  #53 [00056a0000 - 00056bd000]         BOOTMEM
  #54 [00056c0000 - 00056dd000]         BOOTMEM
  #55 [00056e0000 - 00056fd000]         BOOTMEM
  #56 [0005700000 - 000571d000]         BOOTMEM
  #57 [0005720000 - 000573d000]         BOOTMEM
  #58 [0005740000 - 000575d000]         BOOTMEM
  #59 [0005760000 - 000577d000]         BOOTMEM
  #60 [0005780000 - 000579d000]         BOOTMEM
  #61 [00057a0000 - 00057bd000]         BOOTMEM
  #62 [00057c0000 - 00057dd000]         BOOTMEM
  #63 [00057e0000 - 00057fd000]         BOOTMEM
  #64 [0005800000 - 000581d000]         BOOTMEM
  #65 [0005820000 - 000583d000]         BOOTMEM
  #66 [0005840000 - 000585d000]         BOOTMEM
  #67 [0005860000 - 000587d000]         BOOTMEM
  #68 [0005880000 - 000589d000]         BOOTMEM
  #69 [00058a0000 - 00058bd000]         BOOTMEM
  #70 [00058c0000 - 00058dd000]         BOOTMEM
  #71 [00058e0000 - 00058fd000]         BOOTMEM
  #72 [0005900000 - 000591d000]         BOOTMEM
  #73 [0005920000 - 000593d000]         BOOTMEM
  #74 [0005940000 - 000595d000]         BOOTMEM
  #75 [0005960000 - 000597d000]         BOOTMEM
  #76 [0005980000 - 000599d000]         BOOTMEM
  #77 [00059a0000 - 00059bd000]         BOOTMEM
  #78 [00059c0000 - 00059dd000]         BOOTMEM
  #79 [00059e0000 - 00059fd000]         BOOTMEM
  #80 [0005a00000 - 0005a1d000]         BOOTMEM
  #81 [0005a20000 - 0005a3d000]         BOOTMEM
  #82 [00030c9f40 - 00030c9f48]         BOOTMEM
  #83 [00030c9f80 - 00030c9f88]         BOOTMEM
  #84 [00030cd300 - 00030cd3c8]         BOOTMEM
  #85 [00030cd400 - 00030cd590]         BOOTMEM
  #86 [00030cd5c0 - 00030cd6d0]         BOOTMEM
  #87 [00030cd700 - 00030cd750]         BOOTMEM
  #88 [00030cd780 - 00030cd7d0]         BOOTMEM
  #89 [00030cb300 - 00030cb500]         BOOTMEM
  #90 [00030cb500 - 00030cb700]         BOOTMEM
  #91 [00030cb700 - 00030cb900]         BOOTMEM
  #92 [00030cb900 - 00030cbb00]         BOOTMEM
  #93 [00030cbb00 - 00030cbd00]         BOOTMEM
  #94 [00030cbd00 - 00030ccd00]         BOOTMEM
Memory: 97048k/180204k available (4738k kernel code, 49216k absent, 33940k reserved, 6395k data, 2660k init)
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:262400 nr_irqs:1080
Spurious LAPIC timer interrupt on cpu 0
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Detected 1994.626 MHz processor.
Calibrating delay loop (skipped) preset value.. 3989.25 BogoMIPS (lpj=1994626)
pid_max: default: 51200 minimum: 400
Security Framework initialized
SELinux:  Initializing.
Dentry cache hash table entries: 16384 (order: 5, 131072 bytes)
Inode-cache hash table entries: 8192 (order: 4, 65536 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
mce: CPU supports 10 MCE banks
Performance Events: p6 PMU driver.
... version:                0
... bit width:              32
... generic registers:      2
... value mask:             00000000ffffffff
... max period:             000000007fffffff
... fixed-purpose events:   0
... event mask:             0000000000000003
SMP alternatives: switching to UP code
ACPI: Core revision 20100702
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 18398 entries in 73 pages
Setting APIC routing to physical flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel QEMU Virtual CPU version (cpu64-rhel6) stepping 03
Brought up 1 CPUs
Total of 1 processors activated (3989.25 BogoMIPS).
devtmpfs: initialized
regulator: core version 0.5
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
IRQ 9: starting IRQFIXUP_POLL
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Switching to clocksource kvm-clock
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 6 devices
ACPI: ACPI bus type pnp unregistered
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 1, 8192 bytes)
TCP established hash table entries: 4096 (order: 4, 65536 bytes)
TCP bind hash table entries: 4096 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP reno registered
UDP hash table entries: 128 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 128 (order: 0, 4096 bytes)
NET: Registered protocol family 1
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: Activating ISA DMA hang workarounds
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 4748k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1284969484.402:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
ioremap: invalid physical address db74000000000000
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:83 __ioremap_caller+0x307/0x380()
Hardware name: KVM
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.36-rc4-mm1+ #24
Call Trace:
 [<ffffffff8105c0ff>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81030532>] ? copy_oldmem_page+0x52/0xc0
 [<ffffffff8105c15a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8103efd7>] __ioremap_caller+0x307/0x380
 [<ffffffff811213bd>] ? find_vmap_area+0x1d/0x60
 [<ffffffff8103f084>] ioremap_cache+0x14/0x20
 [<ffffffff81030532>] copy_oldmem_page+0x52/0xc0
 [<ffffffff811a9f3a>] read_from_oldmem+0x7a/0xb0
 [<ffffffff81b1f94e>] merge_note_headers_elf64.clone.1+0x6c/0x21f
 [<ffffffff811a9f3a>] ? read_from_oldmem+0x7a/0xb0
 [<ffffffff81b1fc9e>] vmcore_init+0x19d/0x396
 [<ffffffff81b1fb01>] ? vmcore_init+0x0/0x396
 [<ffffffff81002053>] do_one_initcall+0x43/0x190
 [<ffffffff81af78ab>] kernel_init+0x2a0/0x330
 [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
 [<ffffffff81af760b>] ? kernel_init+0x0/0x330
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
---[ end trace 93d72a36b9146f22 ]---
XXX per_cpu_ptry_to_phys((null)) returned invalid address 0xdb74000000000000
XXX percpu allocator dump
XXX  SLOT[10]
XXX   0(f=4424,c=3984,u=116,a=128) -96320 -104 -104 -4 -4 -4 -4 -4 -4 -16 -4 -4 -4 -4 -16 -4 -4 -16 -4 -4 -4 -4 -4 -4 -4 -4 -16 -4 -4 -8 -4 -4 -64 -4 -4 -112 -4 -4 -16 -4 -4 -16 -4 -8 -8 -4 -16 -4 -4 -16 -8 -8 -8 -8 -112 -64 -8 -8 -8 -4 -4 -24 -4 -4 -16 -112 -256 -16 -4 -4 -4 -4 -88 -4 -4 -4 -4 -4 -4 -112 -120 -4 -4 -4 -4 -4 -4 -112 -120 24 -112 -56 -56 32 -112 -56 -56 32 -112 144 -112 -4096 -216 -216 -248 -248 -632 -632 -224 -224 -4096 -4096 -368 208 -112 3984 free=4424 contig=3984
Kdump: vmcore not initialized
msgmni has been set to 198
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp: Slot [1] registered
acpiphp: Slot [2] registered
acpiphp: Slot [3] registered
acpiphp: Slot [4] registered
acpiphp: Slot [5] registered
acpiphp: Slot [6] registered
acpiphp: Slot [7] registered
acpiphp: Slot [8] registered
acpiphp: Slot [9] registered
acpiphp: Slot [10] registered
acpiphp: Slot [11] registered
acpiphp: Slot [12] registered
acpiphp: Slot [13] registered
acpiphp: Slot [14] registered
acpiphp: Slot [15] registered
acpiphp: Slot [16] registered
acpiphp: Slot [17] registered
acpiphp: Slot [18] registered
acpiphp: Slot [19] registered
acpiphp: Slot [20] registered
acpiphp: Slot [21] registered
acpiphp: Slot [22] registered
acpiphp: Slot [23] registered
acpiphp: Slot [24] registered
acpiphp: Slot [25] registered
acpiphp: Slot [26] registered
acpiphp: Slot [27] registered
acpiphp: Slot [28] registered
acpiphp: Slot [29] registered
acpiphp: Slot [30] registered
acpiphp: Slot [31] registered
pci-stub: invalid id string ""
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
hpet_acpi_add: no address or irqs in _CRS
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
�serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
uhci_hcd 0000:00:01.2: PCI INT D -> Link[LNKD] -> GSI 11 (level, high) -> IRQ 11
uhci_hcd 0000:00:01.2: UHCI Host Controller
uhci_hcd 0000:00:01.2: new USB bus registered, assigned bus number 1
IRQ 11: starting IRQFIXUP_POLL
uhci_hcd 0000:00:01.2: irq 11, io base 0x0000c020
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.36-rc4-mm1+ uhci_hcd
usb usb1: SerialNumber: 0000:00:01.2
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
IRQ 12: starting IRQFIXUP_POLL
IRQ 12: polling stopped
IRQ 1: starting IRQFIXUP_POLL
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 114 bytes nvram
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Registering the dns_resolver key type
registered taskstats version 1
IMA: No TPM chip found, activating TPM-bypass!
rtc_cmos 00:01: setting system clock to 2010-09-20 07:58:05 UTC (1284969485)
Initalizing network drop monitor service
IRQ 4: starting IRQFIXUP_POLL
Freeing unused kernel memory: 2660k freed
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 1388k freed
Freeing unused kernel memory: 1896k freed
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
Free memory/Total memory (free %): 71560 / 107740 ( 66.4192 )
Loading jbd2.ko module
Loading mbcache.ko module
Loading ext4.ko module
Loading virtio_ring.ko module
Loading virtio.ko module
Loading virtio_blk.ko module
Loading dm-mod.ko module
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
Loading dm-log.ko module
Loading dm-region-hash.ko module
Loading dm-mirror.ko module
Loading dm-zero.ko module
Loading dm-snapshot.ko module
Loading ipv6.ko module
NET: Registered protocol family 10
XXX chunk 1 allocated base_addr=ffffe8ffff600000
XXX VMS: 8388608@ffffe8ffff600000
lo: Disabled Privacy Extensions
Loading exportfs.ko module
Loading virtio_net.ko module
Loading pcspkr.ko module
input: PC Speaker as /devices/platform/pcspkr/input/input2
Loading ac97_bus.ko module
Loading soundcore.ko module
Loading snd-page-alloc.ko module
Loading i2c-core.ko module
Loading floppy.ko module
FDC 0 is a S82078B
Loading virtio_pci.ko module
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
virtio-pci 0000:00:03.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, high) -> IRQ 10
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
virtio-pci 0000:00:05.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, high) -> IRQ 10
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
virtio-pci 0000:00:06.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, high) -> IRQ 11
 vda: vda1 vda2
virtio-pci 0000:00:07.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, high) -> IRQ 10
 vdb: vdb1
Loading ata_generic.ko module
Loading pata_acpi.ko module
Loading ata_piix.ko module
IRQ 14: starting IRQFIXUP_POLL
IRQ 15: starting IRQFIXUP_POLL
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14+
ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15+
input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
Loading xfs.ko module
SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
Loading snd.ko module
Loading i2c-piix4.ko module
piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
Loading snd-seq-device.ko module
Loading snd-timer.ko module
Loading snd-seq.ko module
Loading snd-pcm.ko module
Loading snd-ac97-codec.ko module
Loading snd-intel8x0.ko module
Intel ICH 0000:00:04.0: PCI INT A -> Link[LNKD] -> GSI 11 (level, high) -> IRQ 11
intel8x0_measure_ac97_clock: measured 50887 usecs (4433 samples)
intel8x0: measured clock 87114 rejected
intel8x0_measure_ac97_clock: measured 50824 usecs (4255 samples)
intel8x0: measured clock 83720 rejected
intel8x0_measure_ac97_clock: measured 51220 usecs (4438 samples)
intel8x0: measured clock 86645 rejected
intel8x0: clocking to 48000
Waiting for required block device discovery
Waiting for 2 vda-like device(s)...cat: can't open '/sys/block/vda/device/model': No such file or directory
cat: can't open '/sys/block/vda/device/rev': No such file or directory
cat: can't open '/sys/block/vda/device/type': No such file or directory
cat: can't open '/sys/block/vdb/device/model': No such file or directory
cat: can't open '/sys/block/vdb/device/rev': No such file or directory
cat: can't open '/sys/block/vdb/device/type': No such file or directory
Found
Creating Block Devices
Creating block device loop0
Creating block device loop1
Creating block device loop2
Creating block device loop3
Creating block device loop4
Creating block device loop5
Creating block device loop6
Creating block device loop7
Creating block device ram0
Creating block device ram1
Creating block device ram10
Creating block device ram11
Creating block device ram12
Creating block device ram13
Creating block device ram14
Creating block device ram15
Creating block device ram2
Creating block device ram3
Creating block device ram4
Creating block device ram5
Creating block device ram6
Creating block device ram7
Creating block device ram8
Creating block device ram9
Creating block device vda
 vda: vda1 vda2
Creating block device vdb
 vdb: vdb1
Making device-mapper control node
mknod: invalid number 'device-mapper'
mdadm: No arrays found in config file or automatically
Free memory/Total memory (free %): 59080 / 107740 ( 54.8357 )
Scanning logical volumes
  Reading all physical volumes.  This may take a while...
  Found volume group "VolGroup" using metadata type lvm2
Activating logical volumes
  2 logical volume(s) in volume group "VolGroup" now active
Free memory/Total memory (free %): 58448 / 107740 ( 54.2491 )
Saving to the local filesystem /dev/mapper/VolGroup-lv_root
e2fsck 1.41.12 (17-May-2010)
/dev/mapper/VolGroup-lv_root: recovering journal
/dev/mapper/VolGroup-lv_root: clean, 74982/624624 files, 2387354/2495488 blocks
EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: 
Free memory/Total memory (free %): 57524 / 107740 ( 53.3915 )
Loading SELINUX policy
type=1404 audit(1284969487.918:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
SELinux:  Permission audit_access in class file not defined in policy.
SELinux:  Permission audit_access in class dir not defined in policy.
SELinux:  Permission execmod in class dir not defined in policy.
SELinux:  Permission audit_access in class lnk_file not defined in policy.
SELinux:  Permission open in class lnk_file not defined in policy.
SELinux:  Permission execmod in class lnk_file not defined in policy.
SELinux:  Permission audit_access in class chr_file not defined in policy.
SELinux:  Permission audit_access in class blk_file not defined in policy.
SELinux:  Permission execmod in class blk_file not defined in policy.
SELinux:  Permission audit_access in class sock_file not defined in policy.
SELinux:  Permission execmod in class sock_file not defined in policy.
SELinux:  Permission audit_access in class fifo_file not defined in policy.
SELinux:  Permission execmod in class fifo_file not defined in policy.
SELinux: the above unknown classes and permissions will be allowed
type=1403 audit(1284969488.606:3): policy loaded auid=4294967295 ses=4294967295
open_dump_memory: Can't open the dump memory(/proc/vmcore). No such file or directory
dropping to initramfs shell
exiting this shell will reboot your system
/ # 
> 
> Thanks.
> 
> diff --git a/arch/x86/kernel/crash_dump_64.c
> b/arch/x86/kernel/crash_dump_64.c
> index bf43188..9510e7d 100644
> --- a/arch/x86/kernel/crash_dump_64.c
> +++ b/arch/x86/kernel/crash_dump_64.c
> @@ -13,6 +13,7 @@
>  /* Stores the physical address of elf header of crash image. */
>  unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
> 
> +void per_cpu_ptr_to_phys_failed(void *addr);
>  /**
>   * copy_oldmem_page - copy one page from "oldmem"
>   * @pfn: page frame number to be copied
> @@ -35,8 +36,10 @@ ssize_t copy_oldmem_page(unsigned long pfn, char
> *buf,
>  		return 0;
> 
>  	vaddr = ioremap_cache(pfn << PAGE_SHIFT, PAGE_SIZE);
> -	if (!vaddr)
> +	if (!vaddr) {
> +		per_cpu_ptr_to_phys_failed(vaddr);
>  		return -ENOMEM;
> +	}
> 
>  	if (userbuf) {
>  		if (copy_to_user(buf, vaddr + offset, csize)) {
> diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
> index 7d9c1d0..357569a 100644
> --- a/mm/percpu-vm.c
> +++ b/mm/percpu-vm.c
> @@ -415,6 +415,7 @@ static struct pcpu_chunk *pcpu_create_chunk(void)
>  {
>  	struct pcpu_chunk *chunk;
>  	struct vm_struct **vms;
> +	int i;
> 
>  	chunk = pcpu_alloc_chunk();
>  	if (!chunk)
> @@ -429,6 +430,13 @@ static struct pcpu_chunk
> *pcpu_create_chunk(void)
> 
>  	chunk->data = vms;
>  	chunk->base_addr = vms[0]->addr - pcpu_group_offsets[0];
> +	chunk->chunkno = ++chunkno;
> +	printk("XXX chunk %d allocated base_addr=%p\n",
> +	       chunk->chunkno, chunk->base_addr);
> +	printk("XXX VMS:");
> +	for (i = 0; i < pcpu_nr_groups; i++)
> +		printk(" %zu@%p", vms[i]->size, vms[i]->addr);
> +	printk("\n");
>  	return chunk;
>  }
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 77e3f5a..f4b094b 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -96,7 +96,10 @@
>  #define __pcpu_ptr_to_addr(ptr)		(void __force *)(ptr)
>  #endif	/* CONFIG_SMP */
> 
> +static int chunkno;
> +
>  struct pcpu_chunk {
> +	int			chunkno;
>  	struct list_head	list;		/* linked to pcpu_slot lists */
>  	int			free_size;	/* free bytes in the chunk */
>  	int			contig_hint;	/* max contiguous size hint */
> @@ -182,6 +185,40 @@ static struct list_head *pcpu_slot __read_mostly;
> /* chunk list slots */
>  static void pcpu_reclaim(struct work_struct *work);
>  static DECLARE_WORK(pcpu_reclaim_work, pcpu_reclaim);
> 
> +void pcpu_dump_chunk(struct pcpu_chunk *chunk)
> +{
> +	int i, contig = 0, free = 0;
> +
> +	printk("XXX   %d(f=%d,c=%d,u=%d,a=%d)", chunk->chunkno,
> +	       chunk->free_size, chunk->contig_hint,
> +	       chunk->map_used, chunk->map_alloc);
> +	for (i = 0; i < chunk->map_used; i++) {
> +		if (chunk->map[i] > 0) {
> +			free += chunk->map[i];
> +			contig = max(contig, chunk->map[i]);
> +		}
> +		printk(" %d", chunk->map[i]);
> +	}
> +	printk(" free=%d contig=%d%s\n", free, contig,
> +	       (free != chunk->free_size || contig != chunk->contig_hint) ?
> +	       " MISMATCH!" : "");
> +}
> +
> +void pcpu_dump_chunk_slots(void)
> +{
> +	struct pcpu_chunk *chunk;
> +	int i;
> +
> +	printk("XXX percpu allocator dump\n");
> +	for (i = 0; i < pcpu_nr_slots; i++) {
> +		if (list_empty(&pcpu_slot[i]))
> +			continue;
> +		printk("XXX  SLOT[%02d]\n", i);
> +		list_for_each_entry(chunk, &pcpu_slot[i], list)
> +			pcpu_dump_chunk(chunk);
> +	}
> +}
> +
>  static bool pcpu_addr_in_first_chunk(void *addr)
>  {
>  	void *first_start = pcpu_first_chunk->base_addr;
> @@ -1021,6 +1058,19 @@ phys_addr_t per_cpu_ptr_to_phys(void *addr)
>  		return page_to_phys(pcpu_addr_to_page(addr));
>  }
> 
> +void per_cpu_ptr_to_phys_failed(void *addr)
> +{
> +	phys_addr_t phys;
> +	unsigned long flags;
> +
> +	phys = per_cpu_ptr_to_phys(addr);
> +	printk("XXX per_cpu_ptry_to_phys(%p) returned invalid address
> 0x%llx\n",
> +	       addr, (unsigned long long)phys);
> +	spin_lock_irqsave(&pcpu_lock, flags);
> +	pcpu_dump_chunk_slots();
> +	spin_unlock_irqrestore(&pcpu_lock, flags);
> +}
> +
>  /**
>   * pcpu_alloc_alloc_info - allocate percpu allocation info
>   * @nr_groups: the number of groups
> @@ -1283,6 +1333,11 @@ int __init pcpu_setup_first_chunk(const struct
> pcpu_alloc_info *ai,
>  	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk) +
>  		BITS_TO_LONGS(pcpu_unit_pages) * sizeof(unsigned long);
> 
> +	printk("XXX CPU->UNIT M/O");
> +	for_each_possible_cpu(cpu)
> +		printk(" %d:%lx", unit_map[cpu], unit_off[cpu]);
> +	printk("\n");
> +
>  	/*
>  	 * Allocate chunk slots.  The additional last slot is for
>  	 * empty chunks.
> @@ -1292,6 +1347,10 @@ int __init pcpu_setup_first_chunk(const struct
> pcpu_alloc_info *ai,
>  	for (i = 0; i < pcpu_nr_slots; i++)
>  		INIT_LIST_HEAD(&pcpu_slot[i]);
> 
> +	printk("XXX ss=%zu up=%d us=%d ns=%d rs=%zd ds=%zd\n",
> +	       ai->static_size, pcpu_unit_pages, pcpu_unit_size,
> +	       pcpu_nr_slots, ai->reserved_size, dyn_size);
> +
>  	/*
>  	 * Initialize static chunk.  If reserved_size is zero, the
>  	 * static chunk covers static area + dynamic allocation area
> @@ -1311,6 +1370,7 @@ int __init pcpu_setup_first_chunk(const struct
> pcpu_alloc_info *ai,
>  		schunk->free_size = ai->reserved_size;
>  		pcpu_reserved_chunk = schunk;
>  		pcpu_reserved_chunk_limit = ai->static_size + ai->reserved_size;
> +		schunk->chunkno = -1;
>  	} else {
>  		schunk->free_size = dyn_size;
>  		dyn_size = 0;			/* dynamic area covered */
> @@ -1340,6 +1400,12 @@ int __init pcpu_setup_first_chunk(const struct
> pcpu_alloc_info *ai,
>  	pcpu_first_chunk = dchunk ?: schunk;
>  	pcpu_chunk_relocate(pcpu_first_chunk, -1);
> 
> +	if (pcpu_reserved_chunk) {
> +		printk("XXX reserved chunk\n");
> +		pcpu_dump_chunk(pcpu_reserved_chunk);
> +	}
> +	pcpu_dump_chunk_slots();
> +
>  	/* we're done */
>  	pcpu_base_addr = base_addr;
>  	return 0;
> @@ -1623,6 +1689,7 @@ int __init pcpu_embed_first_chunk(size_t
> reserved_size, size_t dyn_size,
>  			goto out_free_areas;
>  		}
>  		areas[group] = ptr;
> +		printk("XXX areas[%d]=%p\n", group, areas[group]);
> 
>  		base = min(ptr, base);
> 
> @@ -1639,12 +1706,15 @@ int __init pcpu_embed_first_chunk(size_t
> reserved_size, size_t dyn_size,
>  	}
> 
>  	/* base address is now known, determine group base offsets */
> +	printk("XXX base_addr=%p", base);
>  	max_distance = 0;
>  	for (group = 0; group < ai->nr_groups; group++) {
>  		ai->groups[group].base_offset = areas[group] - base;
>  		max_distance = max_t(size_t, max_distance,
>  				     ai->groups[group].base_offset);
> +		printk(" %lx", ai->groups[group].base_offset);
>  	}
> +	printk("\n");
>  	max_distance += ai->unit_size;
> 
>  	/* warn if maximum distance is further than 75% of vmalloc space */
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
