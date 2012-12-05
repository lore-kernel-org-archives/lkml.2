Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab2LECqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 21:46:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41093 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978Ab2LECqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 21:46:14 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Disable control interface reporting for WM5102 and WM5110
Date: Wed,  5 Dec 2012 11:46:04 +0900
Message-Id: <1354675565-24794-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than disabling the error reporting only for earlier revisions
unconditionally disable it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

This is a bug fix for later chip revisons.

 drivers/mfd/arizona-irq.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index b1b0091..113805d 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -176,14 +176,7 @@ int arizona_irq_init(struct arizona *arizona)
 		aod = &wm5102_aod;
 		irq = &wm5102_irq;
 
-		switch (arizona->rev) {
-		case 0:
-		case 1:
-			ctrlif_error = false;
-			break;
-		default:
-			break;
-		}
+		ctrlif_error = false;
 		break;
 #endif
 #ifdef CONFIG_MFD_WM5110
@@ -191,14 +184,7 @@ int arizona_irq_init(struct arizona *arizona)
 		aod = &wm5110_aod;
 		irq = &wm5110_irq;
 
-		switch (arizona->rev) {
-		case 0:
-		case 1:
-			ctrlif_error = false;
-			break;
-		default:
-			break;
-		}
+		ctrlif_error = false;
 		break;
 #endif
 	default:
-- 
1.7.10.4

