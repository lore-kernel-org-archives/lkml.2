Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab0G3PmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 11:42:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59265 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab0G3PmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 11:42:23 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>, Nicolas Pitre <nico@marvell.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Julia Lawall <julia@diku.dk>, Tejun Heo <tj@kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MTD: pxa2xx: move pxa2xx_flash_probe to .devinit.text
Date: Fri, 30 Jul 2010 17:42:09 +0200
Message-Id: <1280504530-31737-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following warning by modpost:

	WARNING: vmlinux.o(.data+0x15018): Section mismatch in reference from the variable pxa2xx_flash_driver to the function .init.text:pxa2xx_flash_probe()
	The variable pxa2xx_flash_driver references
	the function __init pxa2xx_flash_probe()
	If the reference is valid then annotate the
	variable with __init* or __refdata (see linux/init.h) or name the variable:
	*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

I choosed to do this instead of using platform_driver_probe as the remove
function uses __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mtd/maps/pxa2xx-flash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/pxa2xx-flash.c b/drivers/mtd/maps/pxa2xx-flash.c
index dd90880..d8ae634 100644
--- a/drivers/mtd/maps/pxa2xx-flash.c
+++ b/drivers/mtd/maps/pxa2xx-flash.c
@@ -51,7 +51,7 @@ struct pxa2xx_flash_info {
 static const char *probes[] = { "RedBoot", "cmdlinepart", NULL };
 
 
-static int __init pxa2xx_flash_probe(struct platform_device *pdev)
+static int __devinit pxa2xx_flash_probe(struct platform_device *pdev)
 {
 	struct flash_platform_data *flash = pdev->dev.platform_data;
 	struct pxa2xx_flash_info *info;
-- 
1.7.1

