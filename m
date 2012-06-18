Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab2FRLNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:13:47 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:56246 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751451Ab2FRLMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:12:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4CADoM309bdWObgWdsb2JhbABFhVewBCIBARYmJ4IZAQUjBAsBRhAlAiYCAlcHEogPpXKSBYEgj0CBEgOVJJJf
X-IronPort-AV: E=Sophos;i="4.77,430,1336341600"; 
   d="scan'208";a="1004339241"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 5/8] Staging: xgifb: Remove XGIFAIL() macro and its calls.
Date: Mon, 18 Jun 2012 13:12:03 +0200
Message-Id: <7d6346bfccd6b00f7718b8d4ec9a8543871cf580.1340016625.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1340016625.git.magomez@igalia.com>
References: <cover.1340016625.git.magomez@igalia.com>
In-Reply-To: <cover.1340016625.git.magomez@igalia.com>
References: <cover.1340016625.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XGIFAIL() prints a message and returns a value, but it's used only in one
place. Better remove it and replace the call with the macro content.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main.h    |    2 --
 drivers/staging/xgifb/XGI_main_26.c |    6 ++++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index ce18f8c..be6bb7d 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -4,8 +4,6 @@
 #include "XGIfb.h"
 #include "vb_def.h"
 
-#define XGIFAIL(x) do { printk(x "\n"); return -EINVAL; } while (0)
-
 #ifndef PCI_DEVICE_ID_XGI_42
 #define PCI_DEVICE_ID_XGI_42      0x042
 #endif
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index a45a497..58cddb4 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1376,8 +1376,10 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 		vtotal = var->upper_margin + var->yres + var->lower_margin
 				+ var->vsync_len;
 
-	if (!(htotal) || !(vtotal))
-		XGIFAIL("XGIfb: no valid timing data");
+	if (!(htotal) || !(vtotal)) {
+		pr_debug("XGIfb: no valid timing data\n");
+		return -EINVAL;
+	}
 
 	if (var->pixclock && htotal && vtotal) {
 		drate = 1000000000 / var->pixclock;
-- 
1.7.9.5

