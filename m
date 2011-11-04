Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106Ab1KDXFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 19:05:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56168 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841Ab1KDXFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 19:05:12 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@liniux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Update wm8994 active device checks for WM1811
Date: Fri,  4 Nov 2011 23:05:04 +0000
Message-Id: <1320447904-21584-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This didn't go in as part of the original MFD patch for WM1811 due to
cross tree issues.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

This really should go into 3.2 to ensure suspend works in all situations
on WM1811 - all the dependencies are now in Linus' tree.

 drivers/mfd/wm8994-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 27064aa..776298b 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -239,6 +239,7 @@ static int wm8994_suspend(struct device *dev)
 
 	switch (wm8994->type) {
 	case WM8958:
+	case WM1811:
 		ret = wm8994_reg_read(wm8994, WM8958_MIC_DETECT_1);
 		if (ret < 0) {
 			dev_err(dev, "Failed to read power status: %d\n", ret);
-- 
1.7.7.1

