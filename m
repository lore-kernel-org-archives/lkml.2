Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab2B2Qg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 11:36:59 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:52715 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758184Ab2B2Qg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 11:36:57 -0500
Message-ID: <4F4E541C.2040002@atmel.com>
Date: Wed, 29 Feb 2012 17:36:44 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Daniel Palmer <me@danielpalmer.co.uk>
CC: linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: at91: SAM9G45 doesn't seem to register HDMAC controller anymore
References: <201202292121.58411.me@danielpalmer.co.uk>
In-Reply-To: <201202292121.58411.me@danielpalmer.co.uk>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 01:21 PM, Daniel Palmer :
> Hi,
> 
> I posted this on the linux-mmc list a few days ago: 
> 
> http://permalink.gmane.org/gmane.linux.kernel.mmc/13014 (oops is include below 
> too)
> 
> The atmel-mmc driver oops when it's using PIO for transfers and the reason 
> it's using PIO seems to be that the HDMAC isn't getting registered so the DMA 
> channels aren't available.
> 
> I have a board file which is based on arch/arm/mach-at91/board-sam9m10g45ek.c 
> with some minor differences. I also have some small changes to the mainline for 
> the memory configuration on the board,.. but taking that out doesn't fix the 
> issue.
> 
> From what I gather by reading the LKML backlog is that a lot of stuff was 
> changed to work out what hardware is available via device tree. I don't have 
> the device tree option enabled and I don't need it either. My guess is that's 
> what is stopping the HDMAC from getting registered.
> 
> Has anyone tested the changes without the device stuff enabled?


Hi,

It seems this bug is related to two setbacks:
1/ the device tree material has not made its way to mainline linux for
  3.3 (and it impacts the non-DT material as well).
- a bug reported by Ludovic did not get merged in 3.3-rc yet (we are working to make it happen).

So, you can find here:
1/ => 
http://git.kernel.org/?p=linux/kernel/git/arm/arm-soc.git;a=commitdiff;h=bdad0b9a1c7222a771d25e2a20e81f5563968002
http://git.kernel.org/?p=linux/kernel/git/arm/arm-soc.git;a=commit;h=2756bf5c03bd6fec9462c0742dddb771838bf080

2/ => 
http://git.kernel.org/?p=linux/kernel/git/cjb/mmc.git;a=commit;h=43df92914ea0623893bcb801791d5d2be2f5e015

You can "cherry-pick" those patches using git.

Hope this helps. Best regards,


> Please CC me as I'm not subscribed.
> 
> Cheers,
> 
> Daniel 
> 
> -- pico-SAM9G45 Bootstrap 3.0.1 --
> -- AT91SAM9G45-EK
> -- Compiled: Oct 17 2011 22:42:24 --
> -I- RTC Config: rcen: 0 osc32en: 1 osc32byp: 0 oscsel: 1
> -I- RTC Config: rcen: 0 osc32en: 1 osc32byp: 0 oscsel: 1
> -I- Setting: MCK = 133MHz
> -I- Init DDRAM
> -I- Init second bank SDRAM
> -I- Loading to 0x20000000
> -I- MEDSdcard init
> -I- DMAD_Initialize channel 0  
> -I- Card Type 1, CSD_STRUCTURE 0
> -I- SD/MMC TRANS SPEED 25000 KBit/s
> -I- SD 4-BITS BUS
> -I- CMD6(1) arg 0x80FFFF01
> -I- SD HS Enable
> -I- SD/MMC TRANS SPEED 50000 KBit/s
> -I- SD/MMC card initialization successful
> -I- Card size: 1886 MB
> -I- Copy "linux.bin" from SdCard to 0x20000000
> -I- load: 20008000 jump: 20008000
> -I- Loading to 0x20007fc0 with size 0x0014f4b0
> -I- MEDSdcard init
> -I- DMAD_Initialize channel 0  
> -I- Card Type 1, CSD_STRUCTURE 0
> -I- SD/MMC TRANS SPEED 25000 KBit/s
> -I- SD 4-BITS BUS
> -I- CMD6(1) arg 0x80FFFF01
> -I- SD HS Enable
> -I- SD/MMC TRANS SPEED 50000 KBit/s
> -I- SD/MMC card initialization successful
> -I- Card size: 1886 MB
> -I- Copy "linux.bin" from SdCard to 0x20007fc0
> -I- Modified jump to 0x20008000
> Uncompressing Linux... done, booting the kernel.
> [    0.000000] Booting Linux on physical CPU 0
> [    0.000000] Linux version 3.3.0-rc5dgp-8be930a+ (jenkins <at> ein) (gcc 
> version 
> 4.6.2 (Debian 4.6.2-15) ) #3 Sun Feb 26 23:59:14 JST 2012
> [    0.000000] CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
> [    0.000000] CPU: VIVT data cache, VIVT instruction cache
> [    0.000000] Machine: Mini Box picoSAM9 G45 Board
> [    0.000000] Memory policy: ECC disabled, Data cache writeback
> [    0.000000] AT91: Detected soc type: at91sam9g45
> [    0.000000] AT91: Detected soc subtype: Unknown
> [    0.000000] AT91: sram at 0x300000 of 0x10000 mapped at 0xfef68000
> [    0.000000] Clocks: CPU 400 MHz, master 133 MHz, main 12.000 MHz
> [    0.000000] gpiochip_add: registered GPIOs 0 to 31 on device: pioA
> [    0.000000] gpiochip_add: registered GPIOs 32 to 63 on device: pioB
> [    0.000000] gpiochip_add: registered GPIOs 64 to 95 on device: pioC
> [    0.000000] gpiochip_add: registered GPIOs 96 to 127 on device: pioD
> [    0.000000] gpiochip_add: registered GPIOs 128 to 159 on device: pioE
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
> pages: 62368
> [    0.000000] Kernel command line: mem=128M <at> 0x20000000 mem=128M <at> 
> 0x70000000 
> console=ttyS0,115200 console=tty0 root=/dev/mmcblk0p2 rw rootdelay=1 
> rootwait=1
> [    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
> [    0.000000] Memory: 128MB 128MB = 256MB total
> [    0.000000] Memory: 256844k/256844k available, 5300k reserved, 0K highmem
> [    0.000000] Virtual kernel memory layout:
> [    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
> [    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
> [    0.000000]     vmalloc : 0xd0800000 - 0xff000000   ( 744 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
> [    0.000000]     modules : 0xbf000000 - 0xc0000000   (  16 MB)
> [    0.000000]       .text : 0xc0008000 - 0xc025ac44   (2380 kB)
> [    0.000000]       .init : 0xc025b000 - 0xc0275000   ( 104 kB)
> [    0.000000]       .data : 0xc0276000 - 0xc0292a40   ( 115 kB)
> [    0.000000]        .bss : 0xc0292a64 - 0xc02a598c   (  76 kB)
> [    0.000000] NR_IRQS:192
> [    0.000000] AT91: 160 gpio irqs in 5 banks
> [    0.000000] Console: colour dummy device 80x30
> [    0.000000] console [tty0] enabled
> [    0.000000] Calibrating delay loop... 199.06 BogoMIPS (lpj=995328)
> [    0.070000] pid_max: default: 32768 minimum: 301
> [    0.070000] Mount-cache hash table entries: 512
> [    0.070000] CPU: Testing write buffer coherency: ok
> [    0.080000] Setting up static identity map for 0x201fa8c0 - 0x201fa8fc
> [    0.140000] NET: Registered protocol family 16
> [    0.210000] AT91: Power Management
> [    0.210000] AT91: Starting after power-restored wakeup
> [    0.280000] bio: create slab <bio-0> at 0
> [    0.310000] Switching to clocksource tcb_clksrc
> [    0.480000] NET: Registered protocol family 2
> [    0.480000] IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.490000] TCP established hash table entries: 8192 (order: 4, 65536 
> bytes)
> [    0.490000] TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
> [    0.490000] TCP: Hash tables configured (established 8192 bind 8192)
> [    0.490000] TCP reno registered
> [    0.490000] UDP hash table entries: 256 (order: 0, 4096 bytes)
> [    0.490000] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
> [    0.510000] msgmni has been set to 501
> [    0.510000] io scheduler noop registered
> [    0.510000] io scheduler cfq registered (default)
> [    0.530000] atmel_lcdfb atmel_lcdfb.0: 255KiB frame buffer at 76f80000 
> (mapped at ffdc0000)
> [    0.880000] Console: switching to colour frame buffer device 60x34
> [    1.060000] atmel_lcdfb atmel_lcdfb.0: fb0: Atmel LCDC at 0x00500000 
> (mapped at d0806000), irq 23
> [    1.060000] atmel_usart.0: ttyS0 at MMIO 0xffffee00 (irq = 1) is a 
> ATMEL_SERIAL
> [    1.420000] console [ttyS0] enabled
> [    1.430000] atmel_usart.1: ttyS1 at MMIO 0xfff8c000 (irq = 7) is a 
> ATMEL_SERIAL
> [    1.440000] atmel_usart.2: ttyS2 at MMIO 0xfff90000 (irq = 8) is a 
> ATMEL_SERIAL
> [    1.460000] atmel_usart.3: ttyS3 at MMIO 0xfff94000 (irq = 9) is a 
> ATMEL_SERIAL
> [    1.480000] atmel_spi atmel_spi.0: Atmel SPI Controller at 0xfffa4000 (irq 
> 14)
> [    1.500000] atmel_spi atmel_spi.1: Atmel SPI Controller at 0xfffa8000 (irq 
> 15)
> [    1.510000] atmel_tsadcc atmel_tsadcc: Master clock is set at: 133333333 Hz
> [    1.530000] atmel_tsadcc atmel_tsadcc: Prescaler is set at: 221
> [    1.540000] input: atmel touch screen controller as 
> /devices/platform/atmel_tsadcc/input/input0
> [    1.560000] rtc-at91sam9 at91_rtt.0: rtc core: registered at91_rtt as rtc0
> [    1.580000] cpuidle: using governor ladder
> [    1.590000] cpuidle: using governor menu
> [    1.610000] TCP cubic registered
> [    1.620000] Registering the dns_resolver key type
> [    1.630000] VFP support v0.3: not present
> [    1.640000] rtc-at91sam9 at91_rtt.0: setting system clock to 2012-02-26 
> 23:44:40 UTC (1330299880)
> [    1.660000] atmel_mci atmel_mci.0: version: 0x410
> [    1.660000] atmel_mci atmel_mci.0: using DMA
> [    1.670000] atmel_mci atmel_mci.0: DMA not available, using PIO
> [    1.680000] atmel_mci atmel_mci.0: Atmel MCI controller at 0xfff80000 irq 
> 11, 1 slots
> [    1.700000] atmel_mci atmel_mci.1: version: 0x410
> [    1.710000] atmel_mci atmel_mci.1: using DMA
> [    1.710000] atmel_mci atmel_mci.1: DMA not available, using PIO
> [    1.730000] atmel_mci atmel_mci.1: Atmel MCI controller at 0xfffd0000 irq 
> 29, 1 slots
> [    1.740000] Waiting 1sec before mounting root device...
> [    1.790000] Unable to handle kernel NULL pointer dereference at virtual 
> address 00000004
> [    1.790000] pgd = c0004000
> [    1.790000] [00000004] *pgd=00000000
> [    1.790000] Internal error: Oops - BUG: 5 [#1]
> [    1.790000] Modules linked in:
> [    1.790000] CPU: 0    Not tainted  (3.3.0-rc5dgp-8be930a+ #3)
> [    1.790000] pc : [<c01794fc>]    lr : [<c0179b38>]    psr: 20000093
> [    1.790000] sp : cf8c7d34  ip : 00010200  fp : c0600020
> [    1.790000] r10: c02822c4  r9 : c029e908  r8 : c0600006
> [    1.790000] r7 : 00000000  r6 : 04000024  r5 : 00000000  r4 : ce995f40
> [    1.790000] r3 : c02978e0  r2 : c027f8a8  r1 : c0000000  r0 : ce995f40
> [    1.790000] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment 
> kernel
> [    1.790000] Control: 0005317f  Table: 20004000  DAC: 00000017
> [    1.790000] Process kworker/u:0 (pid: 5, stack limit = 0xcf8c6270)
> [    1.790000] Stack: (0xcf8c7d34 to 0xcf8c8000)
> [    1.790000] 7d20:                                              ce995f40 
> 04000024 04000024
> [    1.790000] 7d40: 00000000 c0600006 c029de4c c02822c4 c0600020 c0179b38 
> c02812c0 ce995f78
> [    1.790000] 7d60: cf8c1d90 ce86c8a0 0000000b 00000000 00000000 0000000b 
> c029de4c c02822c4
> [    1.790000] 7d80: 00000001 c004cb38 00060000 c02822c4 0000000b 00000000 
> cf8c7e0c 00000000
> [    1.790000] 7da0: c016d514 ce997df4 00000012 c004cc8c c02822c4 c004e778 
> c02896a8 c004c528
> [    1.790000] 7dc0: 000000c0 c000e6ac c0179f48 60000013 fefff000 c000dab8 
> 00000000 00000000
> [    1.790000] 7de0: 0005104d 00000001 ce997c00 ce995f40 cf8c7eb4 00000040 
> 00000000 c016d514
> [    1.790000] 7e00: ce997df4 00000012 00000002 cf8c7e20 c0179de0 c0179f48 
> 60000013 ffffffff
> [    1.790000] 7e20: cf8c7eb4 ce997c00 cf8c7ec4 c016b910 cf8c7eb4 ce997c00 
> cf8c7e84 c016ba50
> [    1.790000] 7e40: 0000000d ce9c3c00 0000000d c01726a0 ce978fe0 0000000d 
> 00000000 00000000
> [    1.790000] 7e60: 00000000 00000000 00000000 000001b5 00000000 ffffff8d 
> 00000000 cf8c7e84
> [    1.790000] 7e80: cf8c7eb4 05f5e100 00000000 00000040 00000001 ffffff8d 
> 00000200 00000000
> [    1.790000] 7ea0: 00000000 cf8c7eb4 00000001 cf8c7ed4 00000000 00000000 
> cf8c7e54 cf8c7e84
> [    1.790000] 7ec0: 00000000 00000000 cf8c7ec8 cf8c7ec8 c016b844 87654321 
> c04b0f32 00000660
> [    1.790000] 7ee0: 00000040 00000000 00000008 ce86c660 ce9c3c00 00000000 
> ce9c3c00 c0171530
> [    1.790000] 7f00: ce997c00 ce9c3c00 00000000 c01719dc 00000000 ce997c00 
> cf8c7f24 c0171b14
> [    1.790000] 7f20: 000000e1 03534453 55303247 80a108b4 6700abed 80ff8000 
> ce997c00 00000000
> [    1.790000] 7f40: c020e800 00061a80 c020e80c c0171dac 00061a80 00ff8000 
> c016d514 ce997c00
> [    1.790000] 7f60: ce997c00 c016d0c0 ce997df4 c016d6b0 cf802ce0 cf16de00 
> cf8c6000 00000000
> [    1.790000] 7f80: 00000000 c002d694 ce997df4 cf802ce0 c0298aac c0298aa8 
> c0280d0c cf8c6000
> [    1.790000] 7fa0: 00000000 cf802cf0 00000000 c002e100 00000000 cf88df38 
> cf802ce0 c002dfc0
> [    1.790000] 7fc0: 00000013 00000000 00000000 c00315fc 00000000 00000000 
> cf802ce0 00000000
> [    1.790000] 7fe0: cf8c7fe0 cf8c7fe0 cf88df38 c0031578 c000e7a4 c000e7a4 
> aaaaaaaa aaaaaaaa
> [    1.790000] Function entered at [<c01794fc>] from [<0000000b>]
> [    1.790000] Code: e92d4ff0 e59f9378 e5905004 e5991000 (e5952004) 
> [    1.790000] ---[ end trace 0cf742e69e15cd43 ]---
> [    1.790000] Kernel panic - not syncing: Fatal exception in interrupt
> 


-- 
Nicolas Ferre
