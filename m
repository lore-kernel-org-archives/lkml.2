Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030246Ab2GFKpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:45:43 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:46829 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933164Ab2GFKlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:41:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAHC/9k9bdWOb/2dsb2JhbABFhWSxVIEHghkBBSMECwFGECUCJgICVwcSiA+nOZMDgSCPLYESA5U3iSaGXYJh
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="940130683"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 06/19 v2] Staging: xgifb: Remove useless switch in XGIfb_detect_VB().
Date: Fri,  6 Jul 2012 12:40:41 +0200
Message-Id: <26d91a04bb4349b1680c0c1c19e5d1e368cf2e9a.1341569486.git.magomez@igalia.com>
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

The switch performs no action so it can be removed.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index d5c87ea..788d141 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1556,16 +1556,6 @@ static void XGIfb_detect_VB(struct xgifb_video_info *xgifb_info)
 
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

