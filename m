Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab2GFKo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:44:57 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:46829 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964769Ab2GFKl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:41:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAHC/9k9bdWOb/2dsb2JhbABFhWSxVIEHghkBBSMECwFGECUCJgICVwcSiA+nOZMDgSCPLYESA5U3iSaGXYJh
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="940130687"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 08/19 v2] Staging: xgifb: Remove unneeded var and condition in XGIfb_search_vesamode().
Date: Fri,  6 Jul 2012 12:40:43 +0200
Message-Id: <a2eb623b861889c426b71ebaf2318fea28f2114c.1341569486.git.magomez@igalia.com>
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

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index c1aa037..e5657ff 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -305,7 +305,7 @@ invalid_mode:
 static void XGIfb_search_vesamode(struct xgifb_video_info *xgifb_info,
 				  unsigned int vesamode)
 {
-	int i = 0, j = 0;
+	int i = 0;
 
 	if (vesamode == 0)
 		goto invalid;
@@ -316,15 +316,13 @@ static void XGIfb_search_vesamode(struct xgifb_video_info *xgifb_info,
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

