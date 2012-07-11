Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab2GKNvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:51:47 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:7961 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757675Ab2GKNuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:50:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAG6E/U9bdWOb/2dsb2JhbABFt16BB4IgAQEFJ1IQIDE8GwcSiBG9V5EuA5U6iSaGYIJh
X-IronPort-AV: E=Sophos;i="4.77,568,1336341600"; 
   d="scan'208";a="541808135"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 6/9] staging: sm7xxfb: rename sm712_set_timing to sm7xx_set_timing
Date: Wed, 11 Jul 2012 15:49:38 +0200
Message-Id: <1342014581-2979-7-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
References: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

sm712_set_timing handles timing for 0x710, 0x712 and 0x720 chips. This
patch renames the name of the function of sm712_set_timing to
sm7xx_set_timing.

Tested with SM712.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index ac49c98..119f6d1 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -135,7 +135,7 @@ static int __init sm7xx_vga_setup(char *options)
 }
 __setup("vga=", sm7xx_vga_setup);
 
-static void sm712_set_timing(struct smtcfb_info *sfb)
+static void sm7xx_set_timing(struct smtcfb_info *sfb)
 {
 	int i = 0, j = 0;
 	u32 m_nScreenStride;
@@ -243,6 +243,17 @@ static void sm712_set_timing(struct smtcfb_info *sfb)
 
 }
 
+static void smtc_set_timing(struct smtcfb_info *sfb)
+{
+	switch (sfb->chip_id) {
+	case 0x710:
+	case 0x712:
+	case 0x720:
+		sm7xx_set_timing(sfb);
+		break;
+	}
+}
+
 static void sm712_setpalette(int regno, unsigned red, unsigned green,
 			     unsigned blue, struct fb_info *info)
 {
@@ -255,17 +266,6 @@ static void sm712_setpalette(int regno, unsigned red, unsigned green,
 	smtc_mmiowb(blue >> 10, dac_val);
 }
 
-static void smtc_set_timing(struct smtcfb_info *sfb)
-{
-	switch (sfb->chip_id) {
-	case 0x710:
-	case 0x712:
-	case 0x720:
-		sm712_set_timing(sfb);
-		break;
-	}
-}
-
 /* chan_to_field
  *
  * convert a colour value into a field position
-- 
1.7.10

