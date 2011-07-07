Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab1GGS5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:57:32 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:61995 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab1GGS5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:57:30 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1310064899!9262118!144
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.178]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] backlight/ep93xx_bl: fix section mismatch
Date: Thu, 7 Jul 2011 11:56:57 -0700
User-Agent: KMail/1.9.9
CC: <linux-fbdev@vger.kernel.org>, <rpurdie@rpsys.net>, <lethal@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201107071156.58113.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Paul Mundt <lethal@linux-sh.org>

---

diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
index 9f1e389..91dce60 100644
--- a/drivers/video/backlight/ep93xx_bl.c
+++ b/drivers/video/backlight/ep93xx_bl.c
@@ -65,7 +65,7 @@ static const struct backlight_ops ep93xxbl_ops = {
 	.get_brightness	= ep93xxbl_get_brightness,
 };
 
-static int __init ep93xxbl_probe(struct platform_device *dev)
+static int __devinit ep93xxbl_probe(struct platform_device *dev)
 {
 	struct ep93xxbl *ep93xxbl;
 	struct backlight_device *bl;
@@ -103,7 +103,7 @@ static int __init ep93xxbl_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int ep93xxbl_remove(struct platform_device *dev)
+static int __devexit ep93xxbl_remove(struct platform_device *dev)
 {
 	struct backlight_device *bl = platform_get_drvdata(dev);
 
