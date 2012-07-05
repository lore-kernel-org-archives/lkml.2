Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab2GEPUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:20:46 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:36348 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756647Ab2GEPUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:20:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAJGv9U9bdWOb/2dsb2JhbABFhV+xSIEHghkBBSMECwFGECUCJgICVwcSiA+mdZJSgSCPRYESA5U3iSaGXYJh
X-IronPort-AV: E=Sophos;i="4.77,531,1336341600"; 
   d="scan'208";a="939596347"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 06/19] Staging: xgifb: Remove useless switch in XGIfb_detect_VB().
Date: Thu,  5 Jul 2012 16:45:49 +0200
Message-Id: <20730eb8d1a58b49eac93b89457e3805ea78660b.1341498466.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1341498465.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
In-Reply-To: <cover.1341498465.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The switch performs no action so it can be removed.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 818e248..367e581 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1546,16 +1546,6 @@ static void XGIfb_detect_VB(struct xgifb_video_info *xgifb_info)
 
 	xgifb_info->TV_plug = xgifb_info->TV_type = 0;
 
-	switch (xgifb_info->hasVB) {
-	case HASVB_LVDS_CHRONTEL:
-	case HASVB_CHRONTEL:
-		break;
-	case HASVB_301:
-	case HASVB_302:
-		/* XGI_Sense30x(); */ /* Yi-Lin TV Sense? */
-		break;
-	}
-
 	cr32 = xgifb_reg_get(XGICR, IND_XGI_SCRATCH_REG_CR32);
 
 	if ((cr32 & SIS_CRT1) && !XGIfb_crt1off)
-- 
1.7.9.5

