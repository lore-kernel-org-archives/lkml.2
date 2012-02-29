Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab2B2KjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:39:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51501 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810Ab2B2KjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:39:23 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Improve performance of later WM1811 revisions
Date: Wed, 29 Feb 2012 10:39:18 +0000
Message-Id: <1330511958-5796-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apply tunings from earlier silicon revisions to revisions up to D and also
tweak an additional setting for improved DC servo performance.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

As this applies on top of things queued in regmap (the patches stuff)
and seems fairly obvious from a framework point of view I've just gone
ahead and applied it.

 drivers/mfd/wm8994-core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 4b36f02..4b8b78c 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -361,6 +361,7 @@ static const __devinitdata struct reg_default wm8958_reva_patch[] = {
 
 static const __devinitdata struct reg_default wm1811_reva_patch[] = {
 	{ 0x102, 0x3 },
+	{ 0x56, 0x7 },
 	{ 0x5d, 0x7e },
 	{ 0x5e, 0x0 },
 	{ 0x102, 0x0 },
@@ -524,6 +525,8 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		switch (wm8994->revision) {
 		case 0:
 		case 1:
+		case 2:
+		case 3:
 			regmap_patch = wm1811_reva_patch;
 			patch_regs = ARRAY_SIZE(wm1811_reva_patch);
 			break;
-- 
1.7.9.1

