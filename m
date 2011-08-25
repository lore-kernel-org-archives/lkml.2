Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab1HYKx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 06:53:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46160 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab1HYKx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 06:53:26 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] leds: Remove obsolete cleanup for clientdata
Date: Thu, 25 Aug 2011 12:48:25 +0200
Message-Id: <1314269314-16324-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few new i2c-drivers came into the kernel which clear the clientdata-pointer
on exit or error. This is obsolete meanwhile, the core will do it.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/leds/leds-lm3530.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 3dd7090..d2d25e6 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -421,7 +421,6 @@ err_class_register:
 err_reg_init:
 	regulator_put(drvdata->regulator);
 err_regulator_get:
-	i2c_set_clientdata(client, NULL);
 	kfree(drvdata);
 err_out:
 	return err;
-- 
1.7.5.4

