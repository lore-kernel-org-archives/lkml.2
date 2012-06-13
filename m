Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab2FMWWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:22:01 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:43551 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753229Ab2FMWV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:21:58 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+LQ5ISMy+Lj3uv1nItp47pARaoFE8ZW5vnmmQZL6
	Qp42mwTGBtjz4H
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/14] staging/xgifb: Remove assignments without effect
Date: Thu, 14 Jun 2012 00:21:39 +0200
Message-Id: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes assignments to the fb_fix_screeninfo struct which are
overwritten by the memset in XGIfb_get_fix() a few lines later.
Since the name/id might be useful this was moved to XGIfb_get_fix().

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/XGI_main_26.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 85dbf32..ff88f1d 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1348,6 +1348,8 @@ static int XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
 	DEBUGPRN("inside get_fix");
 	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
 
+	strncpy(fix->id, "XGI", sizeof(fix->id) - 1);
+
 	fix->smem_start = xgifb_info->video_base;
 
 	fix->smem_len = xgifb_info->video_size;
@@ -2230,11 +2232,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 	}
 
-	strncpy(fb_info->fix.id, "XGI", sizeof(fb_info->fix.id) - 1);
-	fb_info->fix.type	= FB_TYPE_PACKED_PIXELS;
-	fb_info->fix.xpanstep	= 1;
-	fb_info->fix.ypanstep	= 1;
-
 	fb_info->flags = FBINFO_FLAG_DEFAULT;
 	fb_info->screen_base = xgifb_info->video_vbase;
 	fb_info->fbops = &XGIfb_ops;
-- 
1.7.3.4

