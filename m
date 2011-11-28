Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab1K1WpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:45:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60974 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754950Ab1K1WpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:45:02 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/8] mfd: Don't hard code the reset value for WM8994 devices
Date: Mon, 28 Nov 2011 22:44:31 +0000
Message-Id: <1322520274-13789-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322520274-13789-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20111128224017.GA13163@opensource.wolfsonmicro.com>
 <1322520274-13789-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index c8956f2..0167694 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -276,7 +276,8 @@ static int wm8994_suspend(struct device *dev)
 	/* Explicitly put the device into reset in case regulators
 	 * don't get disabled in order to ensure consistent restart.
 	 */
-	wm8994_reg_write(wm8994, WM8994_SOFTWARE_RESET, 0x8994);
+	wm8994_reg_write(wm8994, WM8994_SOFTWARE_RESET,
+			 wm8994_reg_read(wm8994, WM8994_SOFTWARE_RESET));
 
 	wm8994->suspended = true;
 
-- 
1.7.7.3

