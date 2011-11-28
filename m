Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab1K1X0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:26:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59703 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755253Ab1K1X0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:26:51 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Constify WM8994 regulator_init_data
Date: Mon, 28 Nov 2011 23:26:47 +0000
Message-Id: <1322522807-4562-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver has no need to modify the regulator_init_data so declare it
const to allow machine code to do so.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/wm8994/pdata.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mfd/wm8994/pdata.h b/include/linux/mfd/wm8994/pdata.h
index 54e2fef..b00897a 100644
--- a/include/linux/mfd/wm8994/pdata.h
+++ b/include/linux/mfd/wm8994/pdata.h
@@ -23,7 +23,7 @@ struct wm8994_ldo_pdata {
 	int enable;
 
 	const char *supply;
-	struct regulator_init_data *init_data;
+	const struct regulator_init_data *init_data;
 };
 
 #define WM8994_CONFIGURE_GPIO 0x10000
-- 
1.7.7.3

