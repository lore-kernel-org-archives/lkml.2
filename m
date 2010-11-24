Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0KXSCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:02:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40847 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754324Ab0KXSCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:02:01 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/7] mfd: Simplify WM832x subdevice instantiation
Date: Wed, 24 Nov 2010 18:01:40 +0000
Message-Id: <1290621705-6926-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101124180055.GO24970@rakim.wolfsonmicro.main>
References: <20101124180055.GO24970@rakim.wolfsonmicro.main>
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
index e1a2f4b..278f3a7 100644
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

