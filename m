Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab2F0MKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 08:10:24 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:60865 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756563Ab2F0MKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 08:10:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAIb36k9bdWOb/2dsb2JhbABFtiaBB4IYAQEFJ1IQIDE8GwcSiA+5Q5FBA5UyiSaGXYJh
X-IronPort-AV: E=Sophos;i="4.77,484,1336341600"; 
   d="scan'208";a="533592682"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 2/2] staging: sm7xxfb: erase hardcode cast between smtcfb_info and fb_info
Date: Wed, 27 Jun 2012 14:10:15 +0200
Message-Id: <1340799015-3138-3-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1340799015-3138-1-git-send-email-jmunhoz@igalia.com>
References: <1340799015-3138-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch erases hardcode cast between smtcfb_info and fb_info in order
to get a more robust and less rigid smtcfb_info structure. fb_info
doesn't need to be the first field in smtcfb_info after this patch.

Tested with SM712.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index c603e8c..e3511ec 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -40,8 +40,8 @@ struct screen_info smtc_screen_info;
 * Private structure
 */
 struct smtcfb_info {
-	struct fb_info fb;
 	struct pci_dev *pdev;
+	struct fb_info fb;
 	u16 chip_id;
 	u8  chip_rev_id;
 
@@ -328,9 +328,11 @@ static int smtc_blank(int blank_mode, struct fb_info *info)
 static int smtc_setcolreg(unsigned regno, unsigned red, unsigned green,
 			  unsigned blue, unsigned trans, struct fb_info *info)
 {
-	struct smtcfb_info *sfb = (struct smtcfb_info *)info;
+	struct smtcfb_info *sfb;
 	u32 val;
 
+	sfb = info->par;
+
 	if (regno > 255)
 		return 1;
 
@@ -623,9 +625,7 @@ static int smtc_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 
 static int smtc_set_par(struct fb_info *info)
 {
-	struct smtcfb_info *sfb = (struct smtcfb_info *)info;
-
-	smtcfb_setmode(sfb);
+	smtcfb_setmode(info->par);
 
 	return 0;
 }
-- 
1.7.10

