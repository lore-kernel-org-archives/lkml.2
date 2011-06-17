Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab1FQLTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 07:19:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59676 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753297Ab1FQLTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 07:19:44 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Fix error handling if BUG() isn't enabled in WM8994
Date: Fri, 17 Jun 2011 12:19:41 +0100
Message-Id: <1308309581-8400-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if we would've BUG()ed we should still tidy up after ourselves if that
isn't enabled in the kernel config.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 088ee80..ff50cf7 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -422,7 +422,7 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		break;
 	default:
 		BUG();
-		return -EINVAL;
+		goto err;
 	}
 
 	wm8994->supplies = kzalloc(sizeof(struct regulator_bulk_data) *
@@ -448,7 +448,7 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		break;
 	default:
 		BUG();
-		return -EINVAL;
+		goto err;
 	}
 		
 	ret = regulator_bulk_get(wm8994->dev, wm8994->num_supplies,
-- 
1.7.5.4

