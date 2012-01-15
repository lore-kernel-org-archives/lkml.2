Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab2AOTfF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 14:35:05 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:36664 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751778Ab2AOTfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 14:35:03 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18IeVta3tMI1Xvw3sU3uWJHsEECCAFBpu9K5Quw4X
	/rauqMIIUzyztU
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 1/4 v2] staging/xgifb: Remove unsupported mode LCD_320x480
Date: Sun, 15 Jan 2012 20:34:52 +0100
Message-Id: <1326656092-21961-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1326651733-9242-2-git-send-email-peterhuewe@gmx.de>
References: <1326651733-9242-2-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the probed mode LCD_320x480 which isn't supported
anyway since this mode falls through to the default (=invalid) mode in
the
XGIfb_validate_mode function (see line 529 ff. for details. the
commented out code for this mode is also removed).

By removing this assignment, we can use the LCD_TYPEs from the sis
driver without modifications.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
Thanks Dan.

 drivers/staging/xgifb/XGI_main_26.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 2502c49..e618aa6 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -526,12 +526,6 @@ static int XGIfb_validate_mode(struct xgifb_video_info *xgifb_info, int myindex)
 			xres = 1600;
 			yres = 1200;
 			break;
-		/* case LCD_320x480: */ /* TW: FSTN */
-			/*
-			xres =  320;
-			yres =  480;
-			break;
-			*/
 		default:
 			xres = 0;
 			yres = 0;
@@ -2117,10 +2111,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 			reg = xgifb_reg_get(XGICR, IND_XGI_LCD_PANEL);
 			reg &= 0x0f;
 			hw_info->ulCRT2LCDType = XGI310paneltype[reg];
-
-		} else {
-			/* TW: FSTN/DSTN */
-			hw_info->ulCRT2LCDType = LCD_320x480;
 		}
 	}
 
-- 
1.7.3.4

