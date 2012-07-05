Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183Ab2GEOt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:49:26 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:34422 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932602Ab2GEOqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:46:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EANqn9U9bdWOb/2dsb2JhbABFhV+xR4EHghkBBSMECwFGECUCJgICVwcSiA+mepJWgSCPRYESA5U3iSaGXYJh
X-IronPort-AV: E=Sophos;i="4.77,531,1336341600"; 
   d="scan'208";a="926562637"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 08/19] Staging: xgifb: Remove unneeded var and condition in XGIfb_search_vesamode().
Date: Thu,  5 Jul 2012 16:45:51 +0200
Message-Id: <2337265cc74edc7de4d7a6a761489d0301ed11ce.1341498466.git.magomez@igalia.com>
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

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index b360ad3..8ae9402 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -299,7 +299,7 @@ invalid_mode:
 static void XGIfb_search_vesamode(struct xgifb_video_info *xgifb_info,
 				  unsigned int vesamode)
 {
-	int i = 0, j = 0;
+	int i = 0;
 
 	if (vesamode == 0)
 		goto invalid;
@@ -310,15 +310,13 @@ static void XGIfb_search_vesamode(struct xgifb_video_info *xgifb_info,
 		if ((XGIbios_mode[i].vesa_mode_no_1 == vesamode) ||
 		    (XGIbios_mode[i].vesa_mode_no_2 == vesamode)) {
 			xgifb_info->mode_idx = i;
-			j = 1;
-			break;
+			return;
 		}
 		i++;
 	}
 
 invalid:
-	if (!j)
-		pr_info("Invalid VESA mode 0x%x'\n", vesamode);
+	pr_info("Invalid VESA mode 0x%x'\n", vesamode);
 }
 
 static int XGIfb_validate_mode(struct xgifb_video_info *xgifb_info, int myindex)
-- 
1.7.9.5

