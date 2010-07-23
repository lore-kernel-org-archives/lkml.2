Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699Ab0GWP3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:29:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:59403 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760631Ab0GWP3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:29:38 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18zzF8Ov+QzSGIuVoV5Df6K+1xvOzH895Nm9fUo3G
	kkysV7ukyVINxK
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [PATCH 04/11] viafb: add lcd scaling support for some IGPs
Date: Fri, 23 Jul 2010 15:39:19 +0000
Message-Id: <1279899566-4359-5-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: add lcd scaling support for some IGPs

These IGPs should also support lcd scaling but likely this switch was
missed when adding support for them. Fix it, allowing lcd scaling on
CN750, VX800 and VX855. At least this improves the situation for
VX855. (there seems to be another scaling unrelated bug somewhere)

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/lcd.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 55cb4ec..568d15b 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -458,6 +458,9 @@ static void load_lcd_scaling(int set_hres, int set_vres, int panel_hres,
 		case UNICHROME_K8M890:
 		case UNICHROME_P4M890:
 		case UNICHROME_P4M900:
+		case UNICHROME_CN750:
+		case UNICHROME_VX800:
+		case UNICHROME_VX855:
 			reg_value =
 			    K800_LCD_HOR_SCF_FORMULA(set_hres, panel_hres);
 			/* Horizontal scaling enabled */
@@ -498,6 +501,9 @@ static void load_lcd_scaling(int set_hres, int set_vres, int panel_hres,
 		case UNICHROME_K8M890:
 		case UNICHROME_P4M890:
 		case UNICHROME_P4M900:
+		case UNICHROME_CN750:
+		case UNICHROME_VX800:
+		case UNICHROME_VX855:
 			reg_value =
 			    K800_LCD_VER_SCF_FORMULA(set_vres, panel_vres);
 			/* Vertical scaling enabled */
-- 
1.6.3.2

