Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab0KLQs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:48:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48930 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753396Ab0KLQs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:48:57 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Oritz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: Simplify WM832x subdevice instantiation
Date: Fri, 12 Nov 2010 16:48:53 +0000
Message-Id: <1289580534-18604-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the current WM832x devices have the same set of subdevices so can
just use multiple case statements with a single body.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 7d2563f..030da2c 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1606,17 +1606,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		break;
 
 	case WM8320:
-		ret = mfd_add_devices(wm831x->dev, -1,
-				      wm8320_devs, ARRAY_SIZE(wm8320_devs),
-				      NULL, 0);
-		break;
-
 	case WM8321:
-		ret = mfd_add_devices(wm831x->dev, -1,
-				      wm8320_devs, ARRAY_SIZE(wm8320_devs),
-				      NULL, 0);
-		break;
-
 	case WM8325:
 		ret = mfd_add_devices(wm831x->dev, -1,
 				      wm8320_devs, ARRAY_SIZE(wm8320_devs),
-- 
1.7.1

