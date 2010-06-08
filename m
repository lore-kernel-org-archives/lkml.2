Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab0FHLZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 07:25:30 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:42322 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752624Ab0FHLZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 07:25:28 -0400
Message-ID: <4C0E26ED.3040103@ribosome.natur.cuni.cz>
Date: Tue, 08 Jun 2010 13:18:05 +0200
From: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100516 Gentoo/2.0.4-r1 SeaMonkey/2.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.32: <IRQ>  __alloc_pages_nodemask+0x54b/0x595
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I am running a server with 16 GB RAM, which was running some long-time 
CPU intensive job (a week). It has two SATA drives in RAID mirror mode.
Once a week I re-sync the array members (part of the output included below).
The hardware is MSI-P45Neo2 with intel quad cpu.

I just found the following in dmesg:

[cut]
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata8: SATA link down (SStatus 0 SControl 300)
ata7: SATA link down (SStatus 0 SControl 300)
ata1.00: ATA-8: ST31000340NS, SN06, max UDMA/133
ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST31000340NS     SN06 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
usb 3-2: new low speed USB device using uhci_hcd and address 2
usb 3-2: New USB device found, idVendor=051d, idProduct=0002
usb 3-2: New USB device strings: Mfr=3, Product=1, SerialNumber=2
usb 3-2: Product: Smart-UPS 1500 FW:653.18.I USB FW:7.4
usb 3-2: Manufacturer: American Power Conversion
usb 3-2: SerialNumber: AS0940321130
usb 3-2: configuration #1 chosen from 1 choice
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATAPI: PIONEER DVD-RW  DVR-216D, 1.08, max UDMA/66
ata2.00: configured for UDMA/66
scsi 1:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-216D 1.08 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 12x/12x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg1 type 5
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-8: ST31000340NS, SN06, max UDMA/133
ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      ST31000340NS     SN06 PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3
sd 2:0:0:0: [sdb] Attached SCSI disk
ata4: SATA link down (SStatus 0 SControl 300)
generic-usb 0003:051D:0002.0001: hiddev96,hidraw0: USB HID v1.10 Device [American Power Conversion Smart-UPS 1500 FW:653.18.I USB FW:7.4] on usb-0000:00:1a.0-2/input0
ata5: SATA link down (SStatus 0 SControl 300)
usb 6-2: new low speed USB device using uhci_hcd and address 2
usb 6-2: New USB device found, idVendor=046d, idProduct=c018
usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 6-2: Product: USB Optical Mouse
usb 6-2: Manufacturer: Logitech
usb 6-2: configuration #1 chosen from 1 choice
input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.0/input/input2
generic-usb 0003:046D:C018.0002: input,hidraw1: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1d.0-2/input0
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata6.00: ATA-7: ST3500630AS, 3.AAK, max UDMA/133
ata6.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata6.00: configured for UDMA/133
scsi 5:0:0:0: Direct-Access     ATA      ST3500630AS      3.AA PQ: 0 ANSI: 5
sd 5:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 5:0:0:0: Attached scsi generic sg3 type 0
sd 5:0:0:0: [sdc] Write Protect is off
sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 5:0:0:0: [sdc] Attached SCSI disk
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 4 and added 4 devices.
md: autorun ...
md: considering sdb3 ...
md:  adding sdb3 ...
md: sdb1 has different UUID to sdb3
md:  adding sda3 ...
md: sda1 has different UUID to sdb3
md: created md1
md: bind<sda3>
md: bind<sdb3>
md: running: <sdb3><sda3>
raid1: raid set md1 active with 2 out of 2 mirrors
md1: detected capacity change from 0 to 992034488320
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1>
raid1: raid set md0 active with 2 out of 2 mirrors
md0: detected capacity change from 0 to 156172288
md: ... autorun DONE.
 md1: unknown partition table
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with writeback data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 9:1.
[cut]


md: data-check of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
md: using 128k window, over a total of 152512 blocks.
md: delaying data-check of md1 until md0 has finished (they share one or more physical units)
md: md0: data-check done.
md: data-check of RAID array md1
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
md: using 128k window, over a total of 968783680 blocks.
md: md1: data-check done.
swapper: page allocation failure. order:0, mode:0x20
Pid: 0, comm: swapper Not tainted 2.6.32-default #6
Call Trace:
 <IRQ>  [<ffffffff8106c711>] __alloc_pages_nodemask+0x54b/0x595
 [<ffffffff81409b82>] ? tcp_current_mss+0x43/0x62
 [<ffffffff8108bad4>] cache_alloc_refill+0x24f/0x485
 [<ffffffff8108bd90>] __kmalloc+0x86/0xb8
 [<ffffffff813d9186>] __alloc_skb+0x67/0x154
 [<ffffffff813d9d8f>] __netdev_alloc_skb+0x1d/0x3a
 [<ffffffff81316586>] rtl8169_rx_fill+0xa3/0x14f
 [<ffffffff8131698a>] rtl8169_rx_interrupt+0x358/0x3c2
 [<ffffffff813190bc>] rtl8169_poll+0x37/0x19a
 [<ffffffff813df943>] net_rx_action+0x6d/0x139
 [<ffffffff8103ecab>] __do_softirq+0x91/0x11a
 [<ffffffff8100c9bc>] call_softirq+0x1c/0x28
 [<ffffffff8100e447>] do_softirq+0x33/0x6b
 [<ffffffff8103e80a>] irq_exit+0x36/0x38
 [<ffffffff8100db97>] do_IRQ+0xa0/0xb7
 [<ffffffff8100c253>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff81012286>] ? mwait_idle+0x66/0x6b
 [<ffffffff8100ad44>] ? enter_idle+0x20/0x22
 [<ffffffff8100ad8e>] ? cpu_idle+0x48/0x7e
 [<ffffffff817fd147>] ? start_secondary+0x17a/0x17e
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 177
CPU    1: hi:  186, btch:  31 usd: 148
CPU    2: hi:  186, btch:  31 usd:  43
CPU    3: hi:  186, btch:  31 usd: 166
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 193
CPU    1: hi:  186, btch:  31 usd: 208
CPU    2: hi:  186, btch:  31 usd:  37
CPU    3: hi:  186, btch:  31 usd: 186
active_anon:1343533 inactive_anon:140362 isolated_anon:64
 active_file:714465 inactive_file:1753044 isolated_file:0
 unevictable:0 dirty:11429 writeback:64667 unstable:0
 free:18535 slab_reclaimable:106621 slab_unreclaimable:18444
 mapped:11762 shmem:546 pagetables:6610 bounce:0
DMA free:15864kB min:12kB low:12kB high:16kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15240kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2999 16129 16129
DMA32 free:53556kB min:3020kB low:3772kB high:4528kB active_anon:152716kB inactive_anon:39140kB active_file:544600kB inactive_file:1878536kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3071776kB mlocked:0kB dirty:11680kB writeback:70620kB mapped:160kB shmem:4kB slab_reclaimable:115388kB slab_unreclaimable:12992kB kernel_stack:24kB pagetables:484kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 13130 13130
Normal free:4720kB min:13220kB low:16524kB high:19828kB active_anon:5221416kB inactive_anon:522308kB active_file:2313260kB inactive_file:5133640kB unevictable:0kB isolated(anon):256kB isolated(file):0kB present:13445120kB mlocked:0kB dirty:34036kB writeback:188048kB mapped:46888kB shmem:2180kB slab_reclaimable:311096kB slab_unreclaimable:60784kB kernel_stack:2744kB pagetables:25956kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15864kB
DMA32: 1628*4kB 1662*8kB 1702*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 1*4096kB = 53184kB
Normal: 94*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 4472kB
2469490 total pagecache pages
1566 pages in swap cache
Swap cache stats: add 130904, delete 129338, find 316914/317763
Free swap  = 15167368kB
Total swap = 15647288kB
4194288 pages RAM
82473 pages reserved
2444838 pages shared
1693229 pages non-shared
------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:261 dev_watchdog+0xdf/0x13c()
Hardware name: MS-7558
NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
Modules linked in: f71882fg coretemp i2c_i801 firewire_ohci firewire_core
Pid: 0, comm: swapper Not tainted 2.6.32-default #6
Call Trace:
 <IRQ>  [<ffffffff8103a51e>] warn_slowpath_common+0x77/0x8f
 [<ffffffff8103a583>] warn_slowpath_fmt+0x3c/0x3e
 [<ffffffff813ed984>] ? netif_tx_lock+0x3f/0x67
 [<ffffffff813edad3>] dev_watchdog+0xdf/0x13c
 [<ffffffff8104899e>] ? __queue_work+0x35/0x3e
 [<ffffffff81042805>] run_timer_softirq+0x15a/0x1c4
 [<ffffffff813ed9f4>] ? dev_watchdog+0x0/0x13c
 [<ffffffff8101cce3>] ? lapic_next_event+0x10/0x14
 [<ffffffff8103ecab>] __do_softirq+0x91/0x11a
 [<ffffffff8105553d>] ? tick_program_event+0x25/0x27
 [<ffffffff8100c9bc>] call_softirq+0x1c/0x28
 [<ffffffff8100e447>] do_softirq+0x33/0x6b
 [<ffffffff8103e80a>] irq_exit+0x36/0x38
 [<ffffffff8101d39d>] smp_apic_timer_interrupt+0x81/0x8f
 [<ffffffff8100c3b3>] apic_timer_interrupt+0x13/0x20
 <EOI>  [<ffffffff81012286>] ? mwait_idle+0x66/0x6b
 [<ffffffff8100ad44>] ? enter_idle+0x20/0x22
 [<ffffffff8100ad8e>] ? cpu_idle+0x48/0x7e
 [<ffffffff817fd147>] ? start_secondary+0x17a/0x17e
---[ end trace 277e396d24aaa901 ]---
r8169: eth0: link up
md: data-check of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
md: using 128k window, over a total of 152512 blocks.
md: delaying data-check of md1 until md0 has finished (they share one or more physical units)
md: md0: data-check done.


# cat /proc/interrupts 
           CPU0       CPU1       CPU2       CPU3       
  0:       6622       6607       6535       6668   IO-APIC-edge      timer
  1:      25945      26055      25838      26187   IO-APIC-edge      i8042
  2:          0          0          0          0    XT-PIC-XT        cascade
  4:          0          1          0          0   IO-APIC-edge    
  8:         14         14         14         13   IO-APIC-edge      rtc0
 12:          0          0          2          2   IO-APIC-edge      i8042
 16:   10009479    9993440    9960761   10005048   IO-APIC-fasteoi   ahci, uhci_hcd:usb3
 17:      31235      30566      30239      31562   IO-APIC-fasteoi   pata_jmicron, HDA Intel, firewire_ohci
 18:          2          1          1          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb8
 19:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb5, uhci_hcd:usb7
 21:         38         38         34         44   IO-APIC-fasteoi   uhci_hcd:usb4
 22:         50         51         51         51   IO-APIC-fasteoi   HDA Intel
 23:     172113     171807     171735     171915   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb6
 29:   94874235   95288996   95218820   94798524   PCI-MSI-edge      ahci
 30:   54750278   54778157   54873715   54762432   PCI-MSI-edge      eth0
NMI:          0          0          0          0   Non-maskable interrupts
LOC: 3920740067 3913124351 2131868122 2120456788   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance monitoring interrupts
PND:          0          0          0          0   Performance pending work
RES:    7266829    7671287    7183417    8073089   Rescheduling interrupts
CAL:   76080694        505   78997635         84   Function call interrupts
TLB:   34542216   30185814   35666755   33126463   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:      26365      26365      26365      26365   Machine check polls
ERR:          0
MIS:          0


Any clues?
Thanks,
Martin

