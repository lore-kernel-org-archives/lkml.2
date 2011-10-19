Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab1JSKcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 06:32:33 -0400
Received: from [78.129.251.5] ([78.129.251.5]:56030 "EHLO n00bsys0p.co.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753511Ab1JSKcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 06:32:31 -0400
X-Greylist: delayed 1101 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Oct 2011 06:32:30 EDT
Message-ID: <4E9EA2EC.2090900@n00bsys0p.co.uk>
Date: Wed, 19 Oct 2011 11:14:04 +0100
From: n00b <n00b@n00bsys0p.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Possible bug in via-velocity on 3.0+
References: <j7k7sf$vbf$1@dough.gmane.org> <CAErSpo7mhAsft5L4ifeWGhB+s2JQc8rbFEjJCfWEq7hW_8kR6A@mail.gmail.com>
In-Reply-To: <CAErSpo7mhAsft5L4ifeWGhB+s2JQc8rbFEjJCfWEq7hW_8kR6A@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060408030704040100050701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060408030704040100050701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 18/10/11 17:15, Bjorn Helgaas wrote:
> On Tue, Oct 18, 2011 at 10:01 AM, n00bsys0p<n00b@n00bsys0p.co.uk>  wrote:
>> Hi,
>>
>> I've been trying to get a custom 3.0 kernel to boot via PXE on a VIA EPIA
>> EN15000G, and have run into a problem where once the thin client starts to
>> load the kernel, the entire screen turns into a mosaic of random colours and
>> characters.
>>
>> I've tested this serving a 2.6.35.8 kernel (configured identically to the
>> 3.0) to the thin client where the master and client are both fitted with
>> EPIA EN1500G, and it works perfectly. Also, I tried swapping the master's
>> motherboard to a Gigabyte GA-D525TUD (Realtek LAN chip), and it succeeded in
>> serving the 3.0 kernel to an EN15000G without a fault.
>>
>> In all test cases, the master was using a 3.0 kernel.
>>
>> Through this testing, I surmise that it is something to do with the LAN
>> driver which is used, as this is the only thing I can see to have changed
>> between the two running systems. Could it be accidentally overwriting the
>> video RAM or something along those lines?
>>
>> Here's a link to a photo of what the screen looks like when it goes wrong:
>> https://lh3.googleusercontent.com/-sXFP41oaF9U/TpyMFg89CqI/AAAAAAAAA-I/PBrltIm0cB4/s720/PXEFail.jpg
> Let me see if I understand this correctly:
>
>    - The problem is on the EN15000G client.
>    - It occurs when the client boots 3.0 from a EN1500G server, but not
> when booting the same 3.0 kernel image from a GA-D525TUD server.
>    - It doesn't occur when booting 2.6.35.8 from a EN1500G server.
>    - The client boots successfully and is usable, i.e., the only
> problem is the temporary garbage on the screen during boot.
>
> It would be useful to see the complete dmesg log from 2.6.35.8 on the
> client.  If 3.0 actually does boot on the client, a dmesg log from 3.0
> would also be useful.  There might be a clue if we can compare them.
>
> Bjorn
In answer:
  - Yes, the problem is a client machine with an EN15000G board
  - Correct, the 3.0 kernel image booted the client using a GA-D525TUD 
server, but not when using an EN15000G
  - Correct again, the 2.6.35.8 image booted correctly from an EN15000G 
server
  - Not correct. The problem is permanent when it occurs. The client 
machine has been left for hours, and all that is visible is the garbage 
on screen.

I'm not sure if it was a one-off, but I can't appear to get it to serve 
the 3.0 kernel from the Gigabyte motherboard now. Exactly the same thing 
is happening as with the EN15000G (garbage mosaic).

I've attached the dmesg log from the client for the 2.6.35.8 kernel. If 
I manage to get the 3.0 kernel to boot again, I'll send over the dmesg 
log for that.

Alex

--------------060408030704040100050701
Content-Type: text/plain;
 name="dmesg.client.2.6.35.8"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.client.2.6.35.8"

Linux version 2.6.35.8-bfj (root@bfj0) (gcc version 4.2.4) #2 Thu Jul 14 15:32:32 BST 2011
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001bee0000 (usable)
 BIOS-e820: 000000001bee0000 - 000000001bee3000 (ACPI NVS)
 BIOS-e820: 000000001bee3000 - 000000001bef0000 (ACPI data)
 BIOS-e820: 000000001bef0000 - 000000001bf00000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
DMI 2.3 present.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x1bee0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CEFFF write-protect
  CF000-EFFFF uncachable
  F0000-F7FFF write-through
  F8000-F8FFF uncachable
  F9000-FFFFF write-through
MTRR variable ranges enabled:
  0 base 000000000 mask FE0000000 write-back
  1 base 01C000000 mask FFC000000 uncachable
  2 base 0E8000000 mask FF8000000 write-combining
  3 base 01BF00000 mask FFFF00000 write-through
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 02000000
found SMP MP-table at [c00f3600] f3600
init_memory_mapping: 0000000000000000-000000001bee0000
 0000000000 - 0000400000 page 4k
 0000400000 - 001bc00000 page 2M
 001bc00000 - 001bee0000 page 4k
kernel direct mapping tables up to 1bee0000 @ 7000-c000
RAMDISK: 1bd00000 - 1bebf000
ACPI: RSDP 000f7790 00014 (v00 P4M80P)
ACPI: RSDT 1bee3040 0002C (v01 P4M80P AWRDACPI 42302E31 AWRD 00000000)
ACPI: FACP 1bee30c0 00074 (v01 P4M80P AWRDACPI 42302E31 AWRD 00000000)
ACPI: DSDT 1bee3180 04F3D (v01 P4M80P AWRDACPI 00001000 MSFT 0100000E)
ACPI: FACS 1bee0000 00040
ACPI: APIC 1bee8100 0005A (v01 P4M80P AWRDACPI 42302E31 AWRD 00000000)
ACPI: no DMI BIOS year, acpi=force is required to enable ACPI
ACPI: Disabling ACPI support
0MB HIGHMEM available.
446MB LOWMEM available.
  mapped low ram: 0 - 1bee0000
  low ram: 0 - 1bee0000
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  Normal   0x00001000 -> 0x0001bee0
  HighMem  empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000001 -> 0x0000009f
    0: 0x00000100 -> 0x0001bee0
On node 0 totalpages: 114302
free_area_init_node: node 0, pgdat c19e8680, node_mem_map c1b17020
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3966 pages, LIFO batch:0
  Normal zone: 862 pages used for memmap
  Normal zone: 109442 pages, LIFO batch:31
Using APIC driver default
SFI: Simple Firmware Interface v0.81 http://simplefirmware.org
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
MPTABLE: OEM ID: OEM00000
MPTABLE: Product ID: PROD00000000
MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
I/O APIC #2 Version 17 at 0xFEC00000.
IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
Processors: 1
nr_irqs_gsi: 40
early_res array is doubled to 64 at [5000 - 57ff]
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 1bf00000 (gap: 1bf00000:e2d00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 113408
Kernel command line: nfs=/dev/nfs nfsroot=10.44.55.200:/tftpboot ip=10.44.55.201:10.44.55.200:0.0.0.0:255.255.255.0 vga=0x317 initrd=initrd-PXE.gz ramdisk_size=6464 splash=silent BOOT_IMAGE=bfjImage-2.6.35.8 
bootsplash: silent mode.
PID hash table entries: 2048 (order: 1, 8192 bytes)
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Subtract (35 early reservations)
  #1 [0001000000 - 0001b0c980]   TEXT DATA BSS
  #2 [001bd00000 - 001bebf000]         RAMDISK
  #3 [0001b0d000 - 0001b1503e]             BRK
  #4 [00000f3610 - 0000100000]   BIOS reserved
  #5 [00000f3600 - 00000f3610]    MP-table mpf
  #6 [000009f400 - 00000f1c00]   BIOS reserved
  #7 [00000f1d20 - 00000f3600]   BIOS reserved
  #8 [00000f1c00 - 00000f1d20]    MP-table mpc
  #9 [0000001000 - 0000005000]     ACPI WAKEUP
  #10 [0000007000 - 0000008000]         PGTABLE
  #11 [0001b16000 - 0001b17000]         BOOTMEM
  #12 [0001b17000 - 0001e97000]         BOOTMEM
  #13 [0001b0c980 - 0001b0c984]         BOOTMEM
  #14 [0001b0c9c0 - 0001b0ca40]         BOOTMEM
  #15 [0001b0ca40 - 0001b0ca6c]         BOOTMEM
  #16 [0001e97000 - 0001e98000]         BOOTMEM
  #17 [0001b0ca80 - 0001b0caa7]         BOOTMEM
  #18 [0001b0cac0 - 0001b0cbf4]         BOOTMEM
  #19 [0001b0cc00 - 0001b0cc40]         BOOTMEM
  #20 [0001b0cc40 - 0001b0cc80]         BOOTMEM
  #21 [0001b0cc80 - 0001b0ccc0]         BOOTMEM
  #22 [0001b0ccc0 - 0001b0cd00]         BOOTMEM
  #23 [0001b0cd00 - 0001b0cd40]         BOOTMEM
  #24 [0001b0cd40 - 0001b0cd80]         BOOTMEM
  #25 [0001b0cd80 - 0001b0cdc0]         BOOTMEM
  #26 [0001b0cdc0 - 0001b0ce00]         BOOTMEM
  #27 [0001b0ce00 - 0001b0ce40]         BOOTMEM
  #28 [0001b0ce40 - 0001b0ce80]         BOOTMEM
  #29 [0001b0ce80 - 0001b0ce90]         BOOTMEM
  #30 [0001b0cec0 - 0001b0cf7c]         BOOTMEM
  #31 [0001b15040 - 0001b150fc]         BOOTMEM
  #32 [0001e98000 - 0001e9a000]         BOOTMEM
  #33 [0001e9a000 - 0001eda000]         BOOTMEM
  #34 [0001eda000 - 0001efa000]         BOOTMEM
Initializing HighMem for node 0 (00000000:00000000)
Memory: 440064k/457600k available (7544k kernel code, 17144k reserved, 2636k data, 576k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xdc6e0000 - 0xff7fe000   ( 561 MB)
    lowmem  : 0xc0000000 - 0xdbee0000   ( 446 MB)
      .init : 0xc19f2000 - 0xc1a82000   ( 576 kB)
      .data : 0xc175e133 - 0xc19f1484   (2636 kB)
      .text : 0xc1000000 - 0xc175e133   (7544 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:288
Console: colour dummy device 80x25
console [tty0] enabled
Fast TSC calibration using PIT
Detected 1496.437 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 2992.87 BogoMIPS (lpj=1496437)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Mount-cache hash table entries: 512
Performance Events: 
CPU: Centaur VIA C7 Processor 1500MHz stepping 00
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 27771 entries in 55 pages
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ExtINT not setup in hardware but reported by MP table
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
devtmpfs: initialized
xor: automatically using best checksumming function: pIII_sse
   pIII_sse  :  3316.000 MB/sec
xor: using function: pIII_sse (3316.000 MB/sec)
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xf9310, last bus=1
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Interpreter disabled.
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
raid6: int32x1    152 MB/s
raid6: int32x2    238 MB/s
raid6: int32x4    230 MB/s
raid6: int32x8    187 MB/s
raid6: mmxx1      570 MB/s
raid6: mmxx2      800 MB/s
raid6: sse1x1     398 MB/s
raid6: sse1x2     628 MB/s
raid6: sse2x1     742 MB/s
raid6: sse2x2     960 MB/s
raid6: using algorithm sse2x2 (960 MB/s)
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
pci 0000:00:00.0: reg 10: [mem 0xe8000000-0xefffffff pref]
pci 0000:00:01.0: supports D1
pci 0000:00:0d.0: reg 10: [mem 0xfdfff000-0xfdfff7ff]
pci 0000:00:0d.0: reg 14: [io  0xfc00-0xfc7f]
pci 0000:00:0d.0: supports D2
pci 0000:00:0d.0: PME# supported from D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: reg 10: [io  0xf800-0xf8ff]
pci 0000:00:0e.0: reg 14: [mem 0xfdffe000-0xfdffe0ff]
pci 0000:00:0e.0: supports D1 D2
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
pci 0000:00:0f.0: reg 10: [io  0xf400-0xf407]
pci 0000:00:0f.0: reg 14: [io  0xf000-0xf003]
pci 0000:00:0f.0: reg 18: [io  0xec00-0xec07]
pci 0000:00:0f.0: reg 1c: [io  0xe800-0xe803]
pci 0000:00:0f.0: reg 20: [io  0xe400-0xe40f]
pci 0000:00:0f.0: reg 24: [io  0xe000-0xe0ff]
pci 0000:00:0f.1: reg 20: [io  0xdc00-0xdc0f]
pci 0000:00:10.0: reg 20: [io  0xd800-0xd81f]
pci 0000:00:10.0: supports D1 D2
pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.0: PME# disabled
pci 0000:00:10.1: reg 20: [io  0xd400-0xd41f]
pci 0000:00:10.1: supports D1 D2
pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.1: PME# disabled
pci 0000:00:10.2: reg 20: [io  0xd000-0xd01f]
pci 0000:00:10.2: supports D1 D2
pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.2: PME# disabled
pci 0000:00:10.4: reg 10: [mem 0xfdffd000-0xfdffd0ff]
pci 0000:00:10.4: supports D1 D2
pci 0000:00:10.4: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.4: PME# disabled
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:11.5: reg 10: [io  0xc800-0xc8ff]
pci 0000:00:11.5: supports D1 D2
pci 0000:01:00.0: reg 10: [mem 0xf4000000-0xf7ffffff pref]
pci 0000:01:00.0: reg 14: [mem 0xfb000000-0xfbffffff]
pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
pci 0000:01:00.0: supports D1 D2
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:01.0:   bridge window [mem 0xfb000000-0xfcffffff]
pci 0000:00:01.0:   bridge window [mem 0xf4000000-0xf7ffffff pref]
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009f800 - 000000000009ffff 
reserve RAM buffer: 000000001bee0000 - 000000001bffffff 
Switching to clocksource tsc
pnp: PnP ACPI: disabled
pci 0000:01:00.0: BAR 6: assigned [mem 0xfc000000-0xfc00ffff pref]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:01.0:   bridge window [mem 0xfb000000-0xfcffffff]
pci 0000:00:01.0:   bridge window [mem 0xf4000000-0xf7ffffff pref]
pci 0000:00:01.0: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
pci_bus 0000:01: resource 1 [mem 0xfb000000-0xfcffffff]
pci_bus 0000:01: resource 2 [mem 0xf4000000-0xf7ffffff pref]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:01.0: disabling DAC on VIA PCI bridge
pci 0000:00:11.0: Bypassing VIA 8237 APIC De-Assert Message
pci 0000:01:00.0: Boot video device
PCI: CLS 32 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 1788k freed
platform rtc_cmos: registered platform RTC device (no PNP device found)
audit: initializing netlink socket (disabled)
type=2000 audit(1319020882.429:1): initialized
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.29 [Flags: R/W].
ROMFS MTD (C) 2007 Red Hat, Inc.
fuse init (API version 7.14)
JFS: nTxBlock = 3451, nTxLock = 27615
msgmni has been set to 862
alg: No test for cipher_null (cipher_null-generic)
alg: No test for ecb(cipher_null) (ecb-cipher_null)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
alg: No test for fcrypt (fcrypt-generic)
alg: No test for stdrng (krng)
async_tx: api initialized (async)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
vesafb: framebuffer at 0xf4000000, mapped to 0xdc980000, using 6144k, total 65536k
vesafb: mode is 1024x768x16, linelength=2048, pages=41
vesafb: protected mode interface info at c000:aa5e
vesafb: pmi: set display start = c00caaac, set palette = c00cab1d
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
bootsplash 3.1.6-2004/03/31: looking for picture...
 silentjpeg size 267344 bytes,
...found (1024x768, 226090 bytes, v3).
Console: switching to colour frame buffer device 118x36
fb0: VESA VGA frame buffer device
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is unknown type 15 (usb?), fd1 is unknown type 15 (usb?)
floppy0: no floppy controllers found
brd: module loaded
loop: module loaded
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.20)
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
Loading iSCSI transport class v2.0-870.
fnic: Cisco FCoE HBA Driver, ver 1.4.0.145
Adaptec aacraid driver 1.1-5[26400]-ms
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
scsi: <fdomain> Detection failed (no card)
QLogic Fibre Channel HBA Driver: 8.03.02-k2
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.3.12
Copyright(c) 2004-2009 Emulex.  All rights reserved.
Brocade BFA FC/FCOE SCSI driver - version: 2.1.2.1
DC390: clustering now enabled by default. If you get problems load
       with "disable_clustering=1" and report to maintainers
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.04.17.1-rc1 Thu. Oct. 29, 11:41:51 PST 2009
mpt2sas version 05.100.00.02 loaded
GDT-HA: Storage RAID Controller Driver. Version: 3.05
3ware Storage Controller device driver for Linux v1.26.02.003.
3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
LSI 3ware SAS/SATA-RAID Controller device driver for Linux v3.26.02.000.
ipr: IBM Power RAID SCSI Device Driver version: 2.5.0 (February 11, 2010)
RocketRAID 3xxx/4xxx Controller driver v1.6 (090910)
stex: Promise SuperTrak EX Driver version: 4.6.0000.4
st: Version 20081215, fixed bufsize 32768, s/g segs 256
sata_via 0000:00:0f.0: version 2.6
sata_via 0000:00:0f.0: PCI->APIC IRQ transform: INT B -> IRQ 20
sata_via 0000:00:0f.0: routed to hard irq line 11
scsi0 : sata_via
scsi1 : sata_via
ata1: SATA max UDMA/133 cmd 0xf400 ctl 0xf000 bmdma 0xe400 irq 20
ata2: SATA max UDMA/133 cmd 0xec00 ctl 0xe800 bmdma 0xe408 irq 20
pata_via 0000:00:0f.1: version 0.3.4
pata_via 0000:00:0f.1: PCI->APIC IRQ transform: INT A -> IRQ 20
scsi2 : pata_via
scsi3 : pata_via
ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xdc00 irq 14
ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xdc08 irq 15
VIA Networking Velocity Family Gigabit Ethernet Adapter Driver Ver. 1.15
Copyright (c) 2002, 2003 VIA Networking Technologies, Inc.
Copyright (c) 2004 Red Hat Inc.
via-velocity 0000:00:0e.0: PCI->APIC IRQ transform: INT A -> IRQ 18
eth0: VIA Networking Velocity Family Gigabit Ethernet Adapter
eth0: Ethernet Address: 00:1f:f2:00:d9:ba
I2O subsystem v1.325
i2o: max drivers = 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
Fusion MPT base driver 3.04.15
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.15
Fusion MPT FC Host driver 3.04.15
Fusion MPT SAS Host driver 3.04.15
Fusion MPT misc device (ioctl) driver 3.04.15
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
Fusion MPT LAN driver 3.04.15
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:10.4: PCI->APIC IRQ transform: INT C -> IRQ 21
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.4: irq 21, io mem 0xfdffd000
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.35.8-bfj ehci_hcd
usb usb1: SerialNumber: 0000:00:10.4
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
116x: driver isp116x-hcd, 03 Nov 2005
driver isp1362-hcd, 2005-04-04
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:10.0: PCI->APIC IRQ transform: INT A -> IRQ 21
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.0: irq 21, io base 0x0000d800
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.35.8-bfj uhci_hcd
usb usb2: SerialNumber: 0000:00:10.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:10.1: PCI->APIC IRQ transform: INT A -> IRQ 21
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.1: irq 21, io base 0x0000d400
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.35.8-bfj uhci_hcd
usb usb3: SerialNumber: 0000:00:10.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:10.2: PCI->APIC IRQ transform: INT B -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.2: irq 21, io base 0x0000d000
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.35.8-bfj uhci_hcd
usb usb4: SerialNumber: 0000:00:10.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
sl811: driver sl811-hcd, 19 May 2005
r8a66597_hcd: driver r8a66597_hcd, 2009-05-26
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver ums-alauda
usbcore: registered new interface driver ums-cypress
usbcore: registered new interface driver ums-datafab
usbcore: registered new interface driver ums-freecom
usbcore: registered new interface driver ums-isd200
usbcore: registered new interface driver ums-jumpshot
usbcore: registered new interface driver ums-karma
usbcore: registered new interface driver ums-onetouch
usbcore: registered new interface driver ums-sddr09
usbcore: registered new interface driver ums-sddr55
usbcore: registered new interface driver ums-usbat
PNP: No PS/2 controller found. Probing ports directly.
ata1: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
Using IPI Shortcut mode
Clocksource tsc unstable (delta = 1110521537 ns)
Switching to clocksource jiffies
usb 4-1: new full speed USB device using uhci_hcd and address 2
registered taskstats version 1
usb 4-1: New USB device found, idVendor=0403, idProduct=6010
usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-1: Product: Dual RS232
usb 4-1: Manufacturer: FTDI
via-velocity 0000:00:0e.0: BAR 0: set to [io  0xf800-0xf8ff] (PCI address [0xf800-0xf8ff]
via-velocity 0000:00:0e.0: BAR 1: set to [mem 0xfdffe000-0xfdffe0ff] (PCI address [0xfdffe000-0xfdffe0ff]
Velocity is AUTO mode
IP-Config: Complete:
     device=eth0, addr=10.44.55.201, mask=255.255.255.0, gw=255.255.255.255,
     host=10.44.55.201, domain=, nis-domain=(none),
     bootserver=10.44.55.200, rootserver=10.44.55.200, rootpath=
Freeing unused kernel memory: 576k freed
Write protecting the kernel text: 7548k
Write protecting the kernel read-only data: 2156k
eth0: Link auto-negotiation speed 1000M bps full duplex
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Linux agpgart interface v0.103
agpgart: Detected VIA VT3314 chipset
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 114 bytes nvram
usbcore: registered new interface driver usbserial
agpgart-via 0000:00:00.0: AGP aperture is 128M @ 0xe8000000
USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
USB Serial support registered for FTDI USB Serial Device
ftdi_sio 4-1:1.0: FTDI USB Serial Device converter detected
usb 4-1: Detected FT2232C
usb 4-1: Number of endpoints 2
usb 4-1: Endpoint 1 MaxPacketSize 64
usb 4-1: Endpoint 2 MaxPacketSize 64
usb 4-1: Setting MaxPacketSize 64
usb 4-1: FTDI USB Serial Device converter now attached to ttyUSB0
ftdi_sio 4-1:1.1: FTDI USB Serial Device converter detected
usb 4-1: Detected FT2232C
usb 4-1: Number of endpoints 2
usb 4-1: Endpoint 1 MaxPacketSize 64
usb 4-1: Endpoint 2 MaxPacketSize 64
usb 4-1: Setting MaxPacketSize 64
ohci1394 0000:00:0d.0: PCI->APIC IRQ transform: INT A -> IRQ 17
usb 4-1: FTDI USB Serial Device converter now attached to ttyUSB1
usbcore: registered new interface driver ftdi_sio
ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[fdfff000-fdfff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
VIA 82xx Audio 0000:00:11.5: PCI->APIC IRQ transform: INT C -> IRQ 22
VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00406350000c7dfd]
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
svc: failed to register lockdv1 RPC service (errno 97).
warning: `named' uses 32-bit capabilities (legacy support in use)
eth0: no IPv6 routers present

--------------060408030704040100050701--
