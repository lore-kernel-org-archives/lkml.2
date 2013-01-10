Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3AJMVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:21:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41520 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754135Ab3AJMS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:18:59 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/9] mfd: arizona: Disable control interface reporting for WM5102 and WM5110
Date: Thu, 10 Jan 2013 12:18:47 +0000
Message-Id: <1357820332-14586-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110121828.GN20956@opensource.wolfsonmicro.com>
 <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than disabling the error reporting only for earlier revisions
unconditionally disable it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index 74713bf..2bec5f0 100644
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

