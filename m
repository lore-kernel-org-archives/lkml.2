Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab1AKMoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:44:10 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45082 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab1AKMoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:07 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>
Subject: [PATCH 00/16] don't treat NULL from clk_get() as an error
Date: Tue, 11 Jan 2011 12:43:37 +0000
Message-Id: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As described in a discussion with Russell King[1], clk_get() should
return a pointer to the struct clk or an ERR_PTR() encoded pointer on
error.  The pointer is effectively a cookie for the clk and NULL is a
valid cookie.  Fixup existing drivers to use IS_ERR() and not checking
against NULL or using IS_ERR_OR_NULL().

1. http://www.spinics.net/linux/lists/arm-kernel/msg110009.html

Jamie Iles (16):
  crypto: omap-aes: don't treat NULL clk as an error
  crypto: omap-sham: don't treat NULL clk as an error
  input: tnetv107x-keypad: don't treat NULL clk as an error
  input: tnetv107x-touchscreen: don't treat NULL clk as an error
  s3c2410fb: don't treat NULL clk as an error
  nuc900fb: don't treat NULL clk as an error
  staging: tidspbridge: don't treat NULL clk as an error
  ARM: samsung: serial: don't treat NULL clk as an error
  ARM: pxa: don't treat NULL clk as an error
  drivers/net: stmmac: don't treat NULL clk as an error
  drivers/net: sh_irda: don't treat NULL clk as an error
  mtd: mpc5121_nfc: don't treat NULL clk as an error
  MMC: jz4740: don't treat NULL clk as an error
  can: mpc5xxx_can: don't treat NULL clk as an error
  spi: dw_spi: don't treat NULL clk as an error
  w1: mxc_w1: don't treat NULL clk as an error

 drivers/crypto/omap-aes.c                 |    5 +++--
 drivers/crypto/omap-sham.c                |    4 ++--
 drivers/input/keyboard/tnetv107x-keypad.c |    5 +++--
 drivers/input/touchscreen/tnetv107x-ts.c  |    5 +++--
 drivers/mmc/host/jz4740_mmc.c             |    5 +++--
 drivers/mtd/nand/mpc5121_nfc.c            |    5 +++--
 drivers/net/can/mscan/mpc5xxx_can.c       |    5 +++--
 drivers/net/irda/sh_sir.c                 |    5 +++--
 drivers/net/stmmac/stmmac_timer.c         |    3 ++-
 drivers/pcmcia/pxa2xx_base.c              |    5 +++--
 drivers/serial/samsung.c                  |    3 ++-
 drivers/spi/dw_spi_mmio.c                 |    5 +++--
 drivers/staging/tidspbridge/core/wdt.c    |    9 +++++----
 drivers/video/nuc900fb.c                  |    5 +++--
 drivers/video/s3c2410fb.c                 |    5 +++--
 drivers/w1/masters/mxc_w1.c               |    5 +++--
 16 files changed, 47 insertions(+), 32 deletions(-)

-- 
1.7.3.4

