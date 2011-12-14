Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab1LNJW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 04:22:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48824 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754837Ab1LNJWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 04:22:54 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3.2] mfd: Update wm8994 active device checks for WM1811
Date: Wed, 14 Dec 2011 17:22:47 +0800
Message-Id: <1323854567-25774-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This didn't go in as part of the original MFD patch for WM1811 due to
cross tree issues.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

This is essentially a bugfix for 3.2 - suspend is likely to not work
well without it, it wasn't merged as part of the original patch set due
to cross tree issues.

 drivers/mfd/wm8994-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 93f8599..83a2a8c 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -229,6 +229,7 @@ static int wm8994_suspend(struct device *dev)
 
 	switch (wm8994->type) {
 	case WM8958:
+	case WM1811:
 		ret = wm8994_reg_read(wm8994, WM8958_MIC_DETECT_1);
 		if (ret < 0) {
 			dev_err(dev, "Failed to read power status: %d\n", ret);
-- 
1.7.7.3

