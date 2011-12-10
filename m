Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab1LJHPY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 02:15:24 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35261 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab1LJHPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 02:15:21 -0500
Message-ID: <1323501296.2539.2.camel@phoenix>
Subject: [PATCH] leds: mc13783: fix off-by-one for checking num_leds
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Philippe Retornaz <philippe.retornaz@epfl.ch>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 10 Dec 2011 15:14:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LED id is begin from 0.
Thus the maximum number of leds should be MC13783_LED_MAX + 1.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-mc13783.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
index c61e8c4..8bc4915 100644
--- a/drivers/leds/leds-mc13783.c
+++ b/drivers/leds/leds-mc13783.c
@@ -275,7 +275,7 @@ static int __devinit mc13783_led_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	if (pdata->num_leds < 1 || pdata->num_leds > MC13783_LED_MAX) {
+	if (pdata->num_leds < 1 || pdata->num_leds > (MC13783_LED_MAX + 1)) {
 		dev_err(&pdev->dev, "Invalid led count %d\n", pdata->num_leds);
 		return -EINVAL;
 	}
-- 
1.7.5.4



