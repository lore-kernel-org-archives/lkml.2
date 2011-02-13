Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab1BMLul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 06:50:41 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:58477 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab1BMLud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 06:50:33 -0500
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/5] Convert release_resource to release_region/release_mem_region
Date: Sun, 13 Feb 2011 13:12:07 +0100
Message-Id: <1297599132-7226-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request_region should be used with release_region, not release_resource.

The changes are somewhat complicated, so I have only done a few cases to
start with.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,E;
@@
(
*x = request_region(...)
|
*x = request_mem_region(...)
)
... when != release_region(x)
    when != x = E
* release_resource(x);
// </smpl>

The complete set of files in which this semantic match finds problesm is as
follows:

arch/unicore32/kernel/rtc.c
arch/x86/pci/direct.c
drivers/char/hw_random/omap-rng.c
drivers/char/pcmcia/ipwireless/main.c
drivers/i2c/busses/i2c-au1550.c
drivers/i2c/busses/i2c-nuc900.c
drivers/i2c/busses/i2c-s3c2410.c
drivers/i2c/busses/i2c-sh7760.c
drivers/i2c/busses/i2c-simtec.c
drivers/media/video/s5p-fimc/fimc-core.c
drivers/mfd/sm501.c
drivers/misc/atmel_tclib.c
drivers/mmc/host/au1xmmc.c
drivers/mmc/host/davinci_mmc.c
drivers/mmc/host/mvsdio.c
drivers/mmc/host/pxamci.c
drivers/mmc/host/sdhci-s3c.c
drivers/mtd/maps/ceiva.c
drivers/net/a2065.c
drivers/net/ariadne.c
drivers/net/arm/ixp4xx_eth.c
drivers/net/ax88796.c
drivers/parport/parport_ax88796.c
drivers/parport/parport_pc.c
drivers/rtc/rtc-s3c.c
drivers/spi/au1550_spi.c
drivers/spi/spi_s3c24xx.c
drivers/tty/serial/sh-sci.c
drivers/tty/serial/vr41xx_siu.c
drivers/usb/gadget/s3c-hsotg.c
drivers/video/s3c-fb.c
drivers/video/s3c2410fb.c
drivers/video/sh7760fb.c
drivers/video/sm501fb.c
drivers/watchdog/davinci_wdt.c
drivers/watchdog/max63xx_wdt.c
drivers/watchdog/pnx4008_wdt.c
drivers/watchdog/s3c2410_wdt.c

