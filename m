Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964808Ab2GFKlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:41:31 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:58350 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932928Ab2GFKlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:41:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAHC/9k9bdWOb/2dsb2JhbABFhWSxVIEHghkBBSMECwFGECUCJgICVwcSiA+nOZMDgSCPLYESA5U3iSaGXYJh
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="940130675"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 03/19 v2] Staging: xgifb: Remove LCDA detection in xgifb_probe().
Date: Fri,  6 Jul 2012 12:40:38 +0200
Message-Id: <0b5331426e8c4fc37b62c58e052526c8c4a28495.1341569486.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1341569486.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
 <cover.1341569486.git.magomez@igalia.com>
In-Reply-To: <cover.1341569486.git.magomez@igalia.com>
References: <cover.1341569486.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The piece of code that checks for LCDA in xgifb_probe() just checks for some
register values but doesn't really do anything in response to them (the actions
that should be executed are commented).
As nothing is really being done, the code can be safely removed.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |   30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index b226458..0307eca 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1952,36 +1952,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		}
 	}
 
-	if ((hw_info->ujVBChipID == VB_CHIP_302B) ||
-			(hw_info->ujVBChipID == VB_CHIP_301LV) ||
-			(hw_info->ujVBChipID == VB_CHIP_302LV)) {
-		int tmp;
-		tmp = xgifb_reg_get(XGICR, 0x34);
-		if (tmp <= 0x13) {
-			/* Currently on LCDA?
-			 *(Some BIOSes leave CR38) */
-			tmp = xgifb_reg_get(XGICR, 0x38);
-			if ((tmp & 0x03) == 0x03) {
-				/* XGI_Pr.XGI_UseLCDA = 1; */
-			} else {
-				/* Currently on LCDA?
-				 *(Some newer BIOSes set D0 in CR35) */
-				tmp = xgifb_reg_get(XGICR, 0x35);
-				if (tmp & 0x01) {
-					/* XGI_Pr.XGI_UseLCDA = 1; */
-				} else {
-					tmp = xgifb_reg_get(XGICR,
-							    0x30);
-					if (tmp & 0x20) {
-						tmp = xgifb_reg_get(
-							XGIPART1, 0x13);
-					}
-				}
-			}
-		}
-
-	}
-
 	xgifb_info->mode_idx = -1;
 
 	if (mode)
-- 
1.7.9.5

