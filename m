Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1LIUdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:33:00 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51658 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab1LIUcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:32:48 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: [PATCH 4/4] spi/gpio: fix section mismatch warning
Date: Fri,  9 Dec 2011 21:32:35 +0100
Message-Id: <1323462755-14369-5-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1323462755-14369-1-git-send-email-w.sang@pengutronix.de>
References: <1323462755-14369-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Lauss <manuel.lauss@googlemail.com>

Fixes:
The function __devinit spi_gpio_probe() references
a function __init spi_gpio_alloc.isra.4().
If spi_gpio_alloc.isra.4 is only used by spi_gpio_probe then
annotate spi_gpio_alloc.isra.4 with a matching annotation.

[wsa: fix spi_gpio_request(), too]

Signed-off-by: Manuel Lauss <manuel.lauss@googlemail.com>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/spi/spi-gpio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index e093d3e..0094c64 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -256,7 +256,7 @@ static void spi_gpio_cleanup(struct spi_device *spi)
 	spi_bitbang_cleanup(spi);
 }
 
-static int __init spi_gpio_alloc(unsigned pin, const char *label, bool is_in)
+static int __devinit spi_gpio_alloc(unsigned pin, const char *label, bool is_in)
 {
 	int value;
 
@@ -270,7 +270,7 @@ static int __init spi_gpio_alloc(unsigned pin, const char *label, bool is_in)
 	return value;
 }
 
-static int __init
+static int __devinit
 spi_gpio_request(struct spi_gpio_platform_data *pdata, const char *label,
 	u16 *res_flags)
 {
-- 
1.7.2.5

