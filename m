Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab2GKNuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:50:25 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:7961 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757715Ab2GKNuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:50:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAG6E/U9bdWOb/2dsb2JhbABFt16BB4IgAQEFeRAgMTwbBxKIEb1XkS4DlTqQBoJh
X-IronPort-AV: E=Sophos;i="4.77,568,1336341600"; 
   d="scan'208";a="541808125"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 1/9] staging: sm7xxfb: fix struct names related to vesa modes
Date: Wed, 11 Jul 2012 15:49:33 +0200
Message-Id: <1342014581-2979-2-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
References: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch renames structs related to vesa modes in order to get more
readable code on sm712vga_setup.

Tested with SM712.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index e3511ec..28aa903 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -56,14 +56,14 @@ struct smtcfb_info {
 	u_int hz;
 };
 
-struct vesa_mode_table	{
-	char mode_index[6];
-	u16 lfb_width;
-	u16 lfb_height;
-	u16 lfb_depth;
+struct vesa_mode {
+	char index[6];
+	u16  lfb_width;
+	u16  lfb_height;
+	u16  lfb_depth;
 };
 
-static struct vesa_mode_table vesa_mode[] = {
+static struct vesa_mode vesa_mode_table[] = {
 	{"0x301", 640,  480,  8},
 	{"0x303", 800,  600,  8},
 	{"0x305", 1024, 768,  8},
@@ -776,13 +776,15 @@ static int __init sm712vga_setup(char *options)
 	pr_debug("sm712vga_setup = %s\n", options);
 
 	for (index = 0;
-	     index < ARRAY_SIZE(vesa_mode);
+	     index < ARRAY_SIZE(vesa_mode_table);
 	     index++) {
-		if (strstr(options, vesa_mode[index].mode_index)) {
-			smtc_screen_info.lfb_width = vesa_mode[index].lfb_width;
+		if (strstr(options, vesa_mode_table[index].index)) {
+			smtc_screen_info.lfb_width =
+				vesa_mode_table[index].lfb_width;
 			smtc_screen_info.lfb_height =
-					vesa_mode[index].lfb_height;
-			smtc_screen_info.lfb_depth = vesa_mode[index].lfb_depth;
+				vesa_mode_table[index].lfb_height;
+			smtc_screen_info.lfb_depth =
+				vesa_mode_table[index].lfb_depth;
 			return 0;
 		}
 	}
-- 
1.7.10

