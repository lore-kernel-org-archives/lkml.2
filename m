Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab1IWTjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 15:39:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40091 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab1IWTjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 15:39:06 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] rtc: mc13xxx: move probe and remove callbacks to .init.text and .exit.text
Date: Fri, 23 Sep 2011 21:35:37 +0200
Message-Id: <1316806538-25441-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.6.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PTX-Original-Recipient: ukl@pengutronix.de
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is added using platform_driver_probe, so the callbacks can be
discarded more aggessively.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/rtc/rtc-mc13xxx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index a1a278b..9d0c3b4 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -309,7 +309,7 @@ static irqreturn_t mc13xxx_rtc_reset_handler(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-static int __devinit mc13xxx_rtc_probe(struct platform_device *pdev)
+static int __init mc13xxx_rtc_probe(struct platform_device *pdev)
 {
 	int ret;
 	struct mc13xxx_rtc *priv;
@@ -378,7 +378,7 @@ err_reset_irq_request:
 	return ret;
 }
 
-static int __devexit mc13xxx_rtc_remove(struct platform_device *pdev)
+static int __exit mc13xxx_rtc_remove(struct platform_device *pdev)
 {
 	struct mc13xxx_rtc *priv = platform_get_drvdata(pdev);
 
@@ -410,7 +410,7 @@ const struct platform_device_id mc13xxx_rtc_idtable[] = {
 
 static struct platform_driver mc13xxx_rtc_driver = {
 	.id_table = mc13xxx_rtc_idtable,
-	.remove = __devexit_p(mc13xxx_rtc_remove),
+	.remove = __exit_p(mc13xxx_rtc_remove),
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
-- 
1.7.6.3


