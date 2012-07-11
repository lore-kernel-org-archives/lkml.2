Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab2GKNwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:52:41 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:40949 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752628Ab2GKNuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:50:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAG6E/U9bdWOb/2dsb2JhbABFt16BB4IgAQEFeRAgMTwbBxKIEb1XkS4DlTqJJoZggmE
X-IronPort-AV: E=Sophos;i="4.77,568,1336341600"; 
   d="scan'208";a="541808127"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 2/9] staging: sm7xxfb: rename index var on sm712vga_setup
Date: Wed, 11 Jul 2012 15:49:34 +0200
Message-Id: <1342014581-2979-3-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
References: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patchs renames index var on sm712vga_setup.

Tested with SM712.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 28aa903..88d4b79 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -764,7 +764,7 @@ static inline void sm7xx_init_hw(void)
  */
 static int __init sm712vga_setup(char *options)
 {
-	int index;
+	int i;
 
 	if (!options || !*options)
 		return -EINVAL;
@@ -775,16 +775,14 @@ static int __init sm712vga_setup(char *options)
 
 	pr_debug("sm712vga_setup = %s\n", options);
 
-	for (index = 0;
-	     index < ARRAY_SIZE(vesa_mode_table);
-	     index++) {
-		if (strstr(options, vesa_mode_table[index].index)) {
+	for (i = 0; i < ARRAY_SIZE(vesa_mode_table); i++) {
+		if (strstr(options, vesa_mode_table[i].index)) {
 			smtc_screen_info.lfb_width =
-				vesa_mode_table[index].lfb_width;
+				vesa_mode_table[i].lfb_width;
 			smtc_screen_info.lfb_height =
-				vesa_mode_table[index].lfb_height;
+				vesa_mode_table[i].lfb_height;
 			smtc_screen_info.lfb_depth =
-				vesa_mode_table[index].lfb_depth;
+				vesa_mode_table[i].lfb_depth;
 			return 0;
 		}
 	}
-- 
1.7.10

