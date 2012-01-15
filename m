Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab2AOSWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 13:22:33 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:40611 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750850Ab2AOSWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 13:22:31 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/+/2RDk4v++4DUGvGFt+SryiZqRzUe8h5+lkwrlW
	B3U7POvCgqJCzo
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 1/4] staging/xgifb: Remove unsupported mode LCD_320x480
Date: Sun, 15 Jan 2012 19:22:10 +0100
Message-Id: <1326651733-9242-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1326651733-9242-1-git-send-email-peterhuewe@gmx.de>
References: <1326651733-9242-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the probed mode LCD_320x480 which isn't supported
anyway since this mode falls through to the default (=invalid) mode in the
XGIfb_validate_mode function (see line 529 ff. for details).

By removing this assignment, we can use the LCD_TYPEs from the sis
driver without modifications.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/XGI_main_26.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 2502c49..c27dbf8 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2118,10 +2118,13 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 			reg &= 0x0f;
 			hw_info->ulCRT2LCDType = XGI310paneltype[reg];
 
-		} else {
+		}
+		#if 0
+		  else {
 			/* TW: FSTN/DSTN */
 			hw_info->ulCRT2LCDType = LCD_320x480;
-		}
+		}	/* maybe we re-add this later on */
+		#endif
 	}
 
 	if ((hw_info->ujVBChipID == VB_CHIP_302B) ||
-- 
1.7.3.4

