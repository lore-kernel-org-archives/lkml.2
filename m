Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0KXSCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:02:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40846 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753305Ab0KXSCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:02:01 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, stable@kernel.org
Subject: [PATCH 2.6.37 1/7] mfd: Supply IRQ base for WM832x devices
Date: Wed, 24 Nov 2010 18:01:39 +0000
Message-Id: <1290621705-6926-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101124180055.GO24970@rakim.wolfsonmicro.main>
References: <20101124180055.GO24970@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this the IRQ base will not be correctly configured for the
subdevices.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@kernel.org
---
 drivers/mfd/wm831x-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 7d2563f..e1a2f4b 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1620,7 +1620,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	case WM8325:
 		ret = mfd_add_devices(wm831x->dev, -1,
 				      wm8320_devs, ARRAY_SIZE(wm8320_devs),
-				      NULL, 0);
+				      NULL, wm831x->irq_base);
 		break;
 
 	default:
-- 
1.7.1

