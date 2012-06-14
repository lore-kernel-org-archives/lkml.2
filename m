Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab2FNWIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 18:08:05 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:43969 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab2FNWID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 18:08:03 -0400
From: Philip Rakity <philipspatches@gmail.com>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: linux-mmc@vger.kernel.org, Philip Rakity <prakity@marvell.com>
Subject: [PATCH 2/2] regulator: core.c Only delay when setting voltage requires this
Date: Thu, 14 Jun 2012 15:07:56 -0700
Message-Id: <1339711676-3488-1-git-send-email-prakity@marvell.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

minor optimization: move delay code to where delay is set and
thus where it is used vs in the main line path.

Signed-off-by: Philip Rakity <prakity@marvell.com>
---
 drivers/regulator/core.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5b04916..4407ed2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2166,14 +2166,14 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 				  delay);
 			delay = 0;
 		}
-	}
 
-	/* Insert any necessary delays */
-	if (delay >= 1000) {
-		mdelay(delay / 1000);
-		udelay(delay % 1000);
-	} else if (delay) {
-		udelay(delay);
+		/* Insert any necessary delays */
+		if (delay >= 1000) {
+			mdelay(delay / 1000);
+			udelay(delay % 1000);
+		} else if (delay) {
+			udelay(delay);
+		}
 	}
 
 	if (ret == 0 && best_val >= 0)
-- 
1.7.0.4

