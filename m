Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab0FWHe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 03:34:59 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:34856 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab0FWHe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 03:34:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lCqnlUI2fJ0IvTXnI1IU4QbrlQdguw4jqYHvFmhSkwQahOrW38c5u85LEJ47ADmNYG
         5anZ+64Ohz/s/pNtVwyfrabSxZbAkEcLYftv7LcA874XzRyPc94W1MlawBbwHZYv4E1U
         e8vkEegkMix/zHo0YAQakazeAzFpCoXGURsO8=
MIME-Version: 1.0
In-Reply-To: <80iq5bqd07.fsf_-_@merkur.tec.linutronix.de>
References: <804oh0b7gx.fsf@merkur.tec.linutronix.de>
	<20100618205401.GA12115@pengutronix.de>
	<80sk4ivkga.fsf@merkur.tec.linutronix.de>
	<AANLkTimA7Rbm_nHpVYpEPqaPCjrOse9s8YyiInWlhfEK@mail.gmail.com>
	<80tyoyhxey.fsf_-_@merkur.tec.linutronix.de>
	<AANLkTikRj_dMkKLyFhW78yld9jIYAIFncfPaPAF8WqUY@mail.gmail.com>
	<80iq5bqd07.fsf_-_@merkur.tec.linutronix.de>
Date: Wed, 23 Jun 2010 09:34:55 +0200
Message-ID: <AANLkTimJKNEwOoKldq4a4_ufxNY6IY7r6tAfAM055hlW@mail.gmail.com>
Subject: Re: [PATCHv3 4/5] mtd: mxc_nand fixups
From: Ivo Clarysse <ivo.clarysse@gmail.com>
To: John Ogness <john.ogness@linutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Sascha Hauer <kernel@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 5:54 PM, John Ogness <john.ogness@linutronix.de> wrote:
> The v2 version of this patch has 2 problems. I believe that this new
> version addresses the problems and still respects the strange behavior
> of the i.MX21.

Unfortunately, this breaks i.MX21 support.

With this patch, the driver gets stuck at the first send_addr() invocation:


barebox 2010.06.0-00202-gc2db375-dirty (Jun 21 2010 - 11:06:13)

Board: Freescale i.MX21 ADS
cfi_probe: cfi_flash base: 0xc8000000 size: 0x02000000
NAND device: Manufacturer ID: 0xec, Chip ID: 0x36 (Samsung NAND 64MiB
1,8V 8-bit)
Scanning device for bad blocks
Bad eraseblock 2133 at 0x02154000
CS8900A Rev. F (PID: 0x0a00) found at 0xcc000000
got MAC address from EEPROM: 00:04:9F:00:25:5C
Malloc space: 0xc0c00000 -> 0xc1000000 (size  4 MB)
Stack space : 0xc0bf8000 -> 0xc0c00000 (size 32 kB)
Open /dev/env0 No such file or directory
no valid environment found on /dev/env0. Using default environment
running /env/bin/init...
barebox:/ nand_parts="256k(barebox)ro,128k(bareboxenv),2176k(kernel),-(root)"
barebox:/ addpart /dev/nand0 $nand_parts
barebox:/ nand -a /dev/nand0.kernel
barebox:/ bootargs="console=ttymxc0,115200"
barebox:/ bootz /dev/nand0.kernel.bb
loaded zImage from /dev/nand0.kernel.bb with size 1696652
Uncompressing Linux... done, booting the kernel.
Linux version 2.6.35-rc3 (ycl@maestro-ycl-quad) (gcc version 4.4.1
(Sourcery G++ Lite 2010q1-202) ) #6 PREEMPT Wed Jun 23 09:11:46 CEST
2010
CPU: ARM926EJ-S [41069264] revision 4 (ARMv5TEJ), cr=00053177
CPU: VIVT data cache, VIVT instruction cache
Machine: Freescale i.MX21ADS
Memory policy: ECC disabled, Data cache writeback
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
Kernel command line: console=ttymxc0,115200
PID hash table entries: 256 (order: -2, 1024 bytes)
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 64MB = 64MB total
Memory: 61776k/61776k available, 3760k reserved, 0K highmem
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
    vmalloc : 0xc4800000 - 0xf4000000   ( 760 MB)
    lowmem  : 0xc0000000 - 0xc4000000   (  64 MB)
    modules : 0xbf000000 - 0xc0000000   (  16 MB)
      .init : 0xc0008000 - 0xc0021000   ( 100 kB)
      .text : 0xc0021000 - 0xc02dc000   (2796 kB)
      .data : 0xc02ee000 - 0xc0309160   ( 109 kB)
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:272
MXC GPIO hardware
MXC IRQ initialized
Console: colour dummy device 80x30
Calibrating delay loop... 131.89 BogoMIPS (lpj=659456)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
Switching to clocksource mxc_timer1
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 2048 (order: 2, 16384 bytes)
TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
TCP: Hash tables configured (established 2048 bind 2048)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
JFFS2 version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
msgmni has been set to 120
io scheduler noop registered (default)
imx-fb imx-fb.0: i.MX Framebuffer driver
Console: switching to colour frame buffer device 30x40
Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
Serial: IMX driver
imx-uart.0: ttymxc0 at MMIO 0x1000a000 (irq = 20) is a IMX
console [ttymxc0] enabled
imx-uart.2: ttymxc2 at MMIO 0x1000c000 (irq = 18) is a IMX
imx-uart.3: ttymxc3 at MMIO 0x1000d000 (irq = 17) is a IMX
physmap platform flash device: 02000000 at c8000000
physmap-flash.0: Found 2 x16 devices at 0x0 in 32-bit bank
Amd/Fujitsu Extended Query Table at 0x0040
physmap-flash.0: CFI contains unrecognised boot bank location (1).
Assuming bottom.
number of CFI chips: 1
Searching for RedBoot partition table in physmap-flash.0 at offset 0x1fe0000
No RedBoot partition table detected in physmap-flash.0
mtd: Giving out device 0 to physmap-flash.0
mxc_nand_command (cmd = 0xff, col = 0xffffffff, page = 0xffffffff)
send_cmd(host, 0xff, 0)
mxc_nand_command (cmd = 0x90, col = 0x0, page = 0xffffffff)
send_cmd(host, 0x90, 1)
send_addr(host, 0x0 1)


Setting NFC_CONFIG1:NFC_INT_MSK in the interrupt handler causes
NFC_CONFIG2:NFC_INT to always read out 0 (on i.MX21), causing

           wait_event(host->irq_waitq,
                        readw(host->regs + NFC_CONFIG2) & NFC_INT);

to wait forever.
