Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab1DGMHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:07:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55863 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab1DGMHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=LjJ8wU/QjuQjrJwMj8D0rcRApqp8hOKVY8mUk9UN0nM1AVVei74UlFCZDphGJr72ph
         tTaRC9l8bJuMjMFKS21CKgHqEH5/3/YtoC16Jq+fa5i+6EhD6OeGoa3BgmY4uqS/Mpl1
         j3Sz7KaTkKPoyekMyJL3I068TdiBabpeZTnO0=
Message-ID: <4D9DA8EC.7070604@gmail.com>
Date: Thu, 07 Apr 2011 16:07:08 +0400
From: Igor Plyatov <plyatov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Hong Xu <hong.xu@atmel.com>, linux-kernel@vger.kernel.org
CC: David Woodhouse <David.Woodhouse@intel.com>,
        =?UTF-8?B?QW5kcmVhcyBCaWU=?= =?UTF-8?B?w59tYW5u?= 
	<biessmann@corscience.de>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: MTD: atmel_nand.c: bug in the DMA support
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hong,

My machine is a Stamp9G20 module, from Taskit company, based on the 
AT91SAM9G20 chip.
More details is here 
http://armbedded.eu/documentation/pdf/stamp9g20technicalreference.pdf

I have try to use Linux-2.6.39-rc2 (from Linus GIT) and discovered a bug 
in the atmel_nand.c after yours patch.

With the Linux-2.6.38.2 everything operate fine and here is a console 
output shown:

...
Linux version 2.6.38.2 (plyatov@homepc) (gcc version 4.3.3 (GCC) ) #12 
PREEMPT Wed Apr 6 11:07:32 MSD 2011
CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
CPU: VIVT data cache, VIVT instruction cache
Machine: GS_IA18_S
Memory policy: ECC disabled, Data cache writeback
Clocks: CPU 396 MHz, master 132 MHz, main 18.432 MHz
On node 0 totalpages: 16384
free_area_init_node: node 0, pgdat c04410c4, node_mem_map c0459000
   Normal zone: 128 pages used for memmap
   Normal zone: 0 pages reserved
   Normal zone: 16256 pages, LIFO batch:3
pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
pcpu-alloc: [0] 0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
Kernel command line: console=ttyS0,115200 mem=64M 
mtdparts=atmel_nand:128k(bootstrap)ro,256k(uboot)ro,128k(env1),128k(env2),3M(linux0),57M(rootfs0),3M(linux1),57M(rootfs1),-(config)rw 
root=/dev/mtdblock7 rootfstype=jffs2
PID hash table entries: 256 (order: -2, 1024 bytes)
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 64MB = 64MB total
Memory: 60476k/60476k available, 5060k reserved, 0K highmem
Virtual kernel memory layout:
     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
     DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
     vmalloc : 0xc4800000 - 0xfee00000   ( 934 MB)
     lowmem  : 0xc0000000 - 0xc4000000   (  64 MB)
     modules : 0xbf000000 - 0xc0000000   (  16 MB)
       .init : 0xc0008000 - 0xc0026000   ( 120 kB)
       .text : 0xc0026000 - 0xc041b000   (4052 kB)
       .data : 0xc041c000 - 0xc0441a60   ( 151 kB)
Preemptable hierarchical RCU implementation.
     RCU-based detection of stalled CPUs is disabled.
     Verbose stalled-CPUs detection is disabled.
NR_IRQS:192
AT91: 96 gpio irqs in 3 banks
Console: colour dummy device 80x30
console [ttyS0] enabled
Calibrating delay loop... 197.83 BogoMIPS (lpj=989184)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
NET: Registered protocol family 16
AT91: Power Management (with slow clock mode)
AT91: Starting after general reset
bio: create slab <bio-0> at 0
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
pcf857x 0-0020: gpios 192..199 on a pcf8574
i2c-gpio i2c-gpio: using pins 55 (SDA) and 56 (SCL)
cfg80211: Calling CRDA to update world regulatory domain
Switching to clocksource pit
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 2048 (order: 2, 16384 bytes)
TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
TCP: Hash tables configured (established 2048 bind 2048)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
JFFS2 version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
msgmni has been set to 118
io scheduler noop registered
io scheduler cfq registered (default)
atmel_usart.0: ttyS0 at MMIO 0xfefff200 (irq = 1) is a ATMEL_SERIAL
atmel_usart.1: ttyS1 at MMIO 0xfffb0000 (irq = 6) is a ATMEL_SERIAL
atmel_usart.2: ttyS2 at MMIO 0xfffb4000 (irq = 7) is a ATMEL_SERIAL
atmel_usart.3: ttyS3 at MMIO 0xfffb8000 (irq = 8) is a ATMEL_SERIAL
atmel_usart.4: ttyS4 at MMIO 0xfffd0000 (irq = 23) is a ATMEL_SERIAL
atmel_usart.5: ttyS5 at MMIO 0xfffd4000 (irq = 24) is a ATMEL_SERIAL
brd: module loaded
loop: module loaded
at24 0-0050: 131072 byte 24c1024 EEPROM, writable, 1 bytes/write
at24 0-0053: 128 byte 24c01 EEPROM, writable, 1 bytes/write
ONFI flash detected
ONFI param page 0 valid
NAND device: Manufacturer ID: 0x2c, Chip ID: 0xa1 (Micron MT29F1G08ABC)
Scanning device for bad blocks
Bad eraseblock 715 at 0x000005960000
mtd: bad character after partition (r)
9 cmdlinepart partitions found on MTD device atmel_nand
Creating 9 MTD partitions on "atmel_nand":
0x000000000000-0x000000020000 : "bootstrap"
0x000000020000-0x000000060000 : "uboot"
0x000000060000-0x000000080000 : "env1"
0x000000080000-0x0000000a0000 : "env2"
0x0000000a0000-0x0000003a0000 : "linux0"
0x0000003a0000-0x000003ca0000 : "rootfs0"
0x000003ca0000-0x000003fa0000 : "linux1"
0x000003fa0000-0x0000078a0000 : "rootfs1"
0x0000078a0000-0x000008000000 : "config"
atmel_spi atmel_spi.0: Atmel SPI Controller at 0xfffc8000 (irq 12)
atmel_spi atmel_spi.1: Atmel SPI Controller at 0xfffcc000 (irq 13)
...


But, when I try to use the Linux-2.6.39-rc2, then system stops and here 
is a console output shown:

...
Linux version 2.6.39-rc2 (plyatov@homepc) (gcc version 4.3.3 (GCC) ) #66 
PREEMPT Thu Apr 7 14:49:20 MSD 2011
CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
CPU: VIVT data cache, VIVT instruction cache
Machine: taskit Stamp9G20
Memory policy: ECC disabled, Data cache writeback
Clocks: CPU 396 MHz, master 132 MHz, main 18.432 MHz
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
Kernel command line: console=ttyS0,115200 mem=64M 
mtdparts=atmel_nand:128k(bootstrap)ro,256k(uboot)ro,128k(env1),128k(env2),3M(linux0),57M(rootfs0),3M(linux1),57M(rootfs1),-(config)rw 
root=/dev/mtdblock7 rootfstype=jffs2
PID hash table entries: 256 (order: -2, 1024 bytes)
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 64MB = 64MB total
Memory: 60136k/60136k available, 5400k reserved, 0K highmem
Virtual kernel memory layout:
     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
     DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
     vmalloc : 0xc4800000 - 0xfee00000   ( 934 MB)
     lowmem  : 0xc0000000 - 0xc4000000   (  64 MB)
     modules : 0xbf000000 - 0xc0000000   (  16 MB)
       .init : 0xc0008000 - 0xc0027000   ( 124 kB)
       .text : 0xc0027000 - 0xc046832c   (4357 kB)
       .data : 0xc046a000 - 0xc04971e0   ( 181 kB)
Preemptable hierarchical RCU implementation.
NR_IRQS:192
AT91: 96 gpio irqs in 3 banks
Console: colour dummy device 80x30
console [ttyS0] enabled
Calibrating delay loop... 197.01 BogoMIPS (lpj=985088)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
i2c-gpio i2c-gpio: using pins 55 (SDA) and 56 (SCL)
cfg80211: Calling CRDA to update world regulatory domain
Switching to clocksource pit
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
IPv4 FIB: Using LC-trie version 0.409
TCP established hash table entries: 2048 (order: 2, 16384 bytes)
TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
TCP: Hash tables configured (established 2048 bind 2048)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
JFFS2 version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
msgmni has been set to 117
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
atmel_usart.0: ttyS0 at MMIO 0xfefff200 (irq = 1) is a ATMEL_SERIAL
atmel_usart.1: ttyS1 at MMIO 0xfffb0000 (irq = 6) is a ATMEL_SERIAL
brd: module loaded
loop: module loaded
atmel_nand atmel_nand: Using DMA for NAND access.
ONFI flash detected
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 5 [#1] PREEMPT
last sysfs file:
Modules linked in:
CPU: 0    Not tainted  (2.6.39-rc2 #66)
PC is at atmel_nand_dma_op+0xb4/0x1dc
LR is at atmel_read_buf+0x40/0x9c
pc : [<c02052ac>]    lr : [<c02054b4>]    psr: 80000013
sp : c381be78  ip : c39dac00  fp : 0000018a
r10: 0000002c  r9 : 00000002  r8 : 00000100
r7 : 239dac8c  r6 : 00000001  r5 : c39dac00  r4 : c39dac8c
r3 : 00000000  r2 : 00000002  r1 : 00000100  r0 : c39dac8c
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0005317f  Table: 20004000  DAC: 00000017
Process swapper (pid: 1, stack limit = 0xc381a270)
Stack: (0xc381be78 to 0xc381c000)
be60:                                                       00000000 
c39dac00
be80: 00000100 c39dae30 c39dac00 c39dac8c c04843c4 00000000 0000002c 
c02054b4
bea0: c39dac00 00000000 c39dac00 c39dac8c c39dae30 c0202330 c040ec7f 
c0400e6c
bec0: 000000a1 00000001 c381a12c c0480c28 00000000 c39dac00 c047106c 
c39dae30
bee0: 00000000 c04708f8 00000000 00000000 00000000 c001aec8 00000000 
00000000
bf00: c04708f8 c04708f8 c048484c c048484c c0480c28 c01c9bdc c048484c 
c01c8b14
bf20: 00000000 c04708f8 c047092c c048484c c381bf48 c01c8c58 00000000 
c01c8bf8
bf40: c048484c c01c82f4 c382dbf8 c3863f30 c0480c28 c002115c c048484c 
c048484c
bf60: c39d62a0 c01c7bc4 c03f6ab0 c0491bac c0491bac c002115c c0484838 
c048484c
bf80: 00000013 c001acf0 00000000 c01c9074 c002115c c0484838 c0028e3c 
00000013
bfa0: c001acf0 c01c9e7c c002115c c002124c c0028e3c c00273f8 00000037 
00000000
bfc0: 00000000 000000c0 c0473f9c c002115c c002124c c0028e3c 00000013 
00000000
bfe0: 00000000 c000839c 00000000 00000000 c000830c c0028e3c 00800100 
00000000
[<c02052ac>] (atmel_nand_dma_op+0xb4/0x1dc) from [<c02054b4>] 
(atmel_read_buf+0x40/0x9c)
[<c02054b4>] (atmel_read_buf+0x40/0x9c) from [<c0202330>] 
(nand_scan_ident+0x308/0xa9c)
[<c0202330>] (nand_scan_ident+0x308/0xa9c) from [<c001aec8>] 
(atmel_nand_probe+0x1c4/0x3bc)
[<c001aec8>] (atmel_nand_probe+0x1c4/0x3bc) from [<c01c9bdc>] 
(platform_drv_probe+0x1c/0x24)
[<c01c9bdc>] (platform_drv_probe+0x1c/0x24) from [<c01c8b14>] 
(driver_probe_device+0xb4/0x198)
[<c01c8b14>] (driver_probe_device+0xb4/0x198) from [<c01c8c58>] 
(__driver_attach+0x60/0x84)
[<c01c8c58>] (__driver_attach+0x60/0x84) from [<c01c82f4>] 
(bus_for_each_dev+0x4c/0x8c)
[<c01c82f4>] (bus_for_each_dev+0x4c/0x8c) from [<c01c7bc4>] 
(bus_add_driver+0xa0/0x220)
[<c01c7bc4>] (bus_add_driver+0xa0/0x220) from [<c01c9074>] 
(driver_register+0xc0/0x150)
[<c01c9074>] (driver_register+0xc0/0x150) from [<c01c9e7c>] 
(platform_driver_probe+0x18/0xa4)
[<c01c9e7c>] (platform_driver_probe+0x18/0xa4) from [<c00273f8>] 
(do_one_initcall+0x94/0x164)
[<c00273f8>] (do_one_initcall+0x94/0x164) from [<c000839c>] 
(kernel_init+0x90/0x140)
[<c000839c>] (kernel_init+0x90/0x140) from [<c0028e3c>] 
(kernel_thread_exit+0x0/0x8)
Code: e59533e0 e2807206 e1a01008 e1a02009 (e5934000)
---[ end trace 0a8f589c04e10d68 ]---
Kernel panic - not syncing: Attempted to kill init!
[<c002d124>] (unwind_backtrace+0x0/0xec) from [<c036a878>] 
(panic+0x60/0x19c)
[<c036a878>] (panic+0x60/0x19c) from [<c003cb88>] (do_exit+0x98/0x6e8)
[<c003cb88>] (do_exit+0x98/0x6e8) from [<c002b384>] (die+0x2e0/0x320)
[<c002b384>] (die+0x2e0/0x320) from [<c002de68>] 
(__do_kernel_fault+0x64/0x84)
[<c002de68>] (__do_kernel_fault+0x64/0x84) from [<c002e054>] 
(do_page_fault+0x1cc/0x1e4)
[<c002e054>] (do_page_fault+0x1cc/0x1e4) from [<c00272d8>] 
(do_DataAbort+0x34/0x94)
[<c00272d8>] (do_DataAbort+0x34/0x94) from [<c0027b2c>] 
(__dabt_svc+0x4c/0x60)
Exception stack(0xc381be30 to 0xc381be78)
be20:                                     c39dac8c 00000100 00000002 
00000000
be40: c39dac8c c39dac00 00000001 239dac8c 00000100 00000002 0000002c 
0000018a
be60: c39dac00 c381be78 c02054b4 c02052ac 80000013 ffffffff
[<c0027b2c>] (__dabt_svc+0x4c/0x60) from [<c02052ac>] 
(atmel_nand_dma_op+0xb4/0x1dc)
[<c02052ac>] (atmel_nand_dma_op+0xb4/0x1dc) from [<c02054b4>] 
(atmel_read_buf+0x40/0x9c)
[<c02054b4>] (atmel_read_buf+0x40/0x9c) from [<c0202330>] 
(nand_scan_ident+0x308/0xa9c)
[<c0202330>] (nand_scan_ident+0x308/0xa9c) from [<c001aec8>] 
(atmel_nand_probe+0x1c4/0x3bc)
[<c001aec8>] (atmel_nand_probe+0x1c4/0x3bc) from [<c01c9bdc>] 
(platform_drv_probe+0x1c/0x24)
[<c01c9bdc>] (platform_drv_probe+0x1c/0x24) from [<c01c8b14>] 
(driver_probe_device+0xb4/0x198)
[<c01c8b14>] (driver_probe_device+0xb4/0x198) from [<c01c8c58>] 
(__driver_attach+0x60/0x84)
[<c01c8c58>] (__driver_attach+0x60/0x84) from [<c01c82f4>] 
(bus_for_each_dev+0x4c/0x8c)
[<c01c82f4>] (bus_for_each_dev+0x4c/0x8c) from [<c01c7bc4>] 
(bus_add_driver+0xa0/0x220)
[<c01c7bc4>] (bus_add_driver+0xa0/0x220) from [<c01c9074>] 
(driver_register+0xc0/0x150)
[<c01c9074>] (driver_register+0xc0/0x150) from [<c01c9e7c>] 
(platform_driver_probe+0x18/0xa4)
[<c01c9e7c>] (platform_driver_probe+0x18/0xa4) from [<c00273f8>] 
(do_one_initcall+0x94/0x164)
[<c00273f8>] (do_one_initcall+0x94/0x164) from [<c000839c>] 
(kernel_init+0x90/0x140)
[<c000839c>] (kernel_init+0x90/0x140) from [<c0028e3c>] 
(kernel_thread_exit+0x0/0x8)
...

So, can you please recommend how to resolve this issue?
I can test yours patches for that if needed.

Best regards!
--
Igor Plyatov
