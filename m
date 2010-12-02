Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab0LBQZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:25:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38366 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757175Ab0LBQZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:25:48 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, stable@kernel.org
Subject: [PATCH] mfd: Support additional parent IDs for wm831x
Date: Thu,  2 Dec 2010 16:25:43 +0000
Message-Id: <1291307143-8472-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some newer device revisions add a second parent ID. Support this in
the device validity checks done at startup.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@kernel.org
---
 drivers/mfd/wm831x-core.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 47b58cc..3fe9a58 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1455,7 +1455,11 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		dev_err(wm831x->dev, "Failed to read parent ID: %d\n", ret);
 		goto err;
 	}
-	if (ret != 0x6204) {
+	switch (ret) {
+	case 0x6204:
+	case 0x6246:
+		break;
+	default:
 		dev_err(wm831x->dev, "Device is not a WM831x: ID %x\n", ret);
 		ret = -EINVAL;
 		goto err;
-- 
1.7.1

