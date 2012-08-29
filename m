Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab2H2TFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 15:05:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60790 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab2H2TF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 15:05:28 -0400
From: anish kumar <anish198519851985@gmail.com>
To: cw00.choi@samsung.com, myungjoo.ham@samsung.com
Cc: linux-kernel@vger.kernel.org, anish kumar <anish198519851985@gmail.com>
Subject: [PATCH 1/2] [1/2]extcon: standard cable names definition and declaration changed
Date: Thu, 30 Aug 2012 00:35:09 +0530
Message-Id: <1346267110-29479-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

With this change now individual drivers can use standard cable
names as below:
static const char *arizona_cable[] = {
    extcon_cable_name[EXTCON_USB],
    extcon_cable_name[EXTCON_USB_HOST],
    "CUSTOM_CABLE"
    NULL,
}

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 drivers/extcon/extcon-class.c |    4 +---
 include/linux/extcon.h        |    2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 481cfa0..e09a6c3 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -41,7 +41,7 @@
  * every single port-type of the following cable names. Please choose cable
  * names that are actually used in your extcon device.
  */
-const char *extcon_cable_name[] = {
+const char extcon_cable_name[][CABLE_NAME_MAX + 1] = {
 	[EXTCON_USB]		= "USB",
 	[EXTCON_USB_HOST]	= "USB-Host",
 	[EXTCON_TA]		= "TA",
@@ -62,8 +62,6 @@ const char *extcon_cable_name[] = {
 	[EXTCON_VIDEO_IN]	= "Video-in",
 	[EXTCON_VIDEO_OUT]	= "Video-out",
 	[EXTCON_MECHANICAL]	= "Mechanical",
-
-	NULL,
 };
 
 static struct class *extcon_class;
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index cdd4014..96b5450 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -68,7 +68,7 @@ enum extcon_cable_name {
 	EXTCON_VIDEO_OUT,
 	EXTCON_MECHANICAL,
 };
-extern const char *extcon_cable_name[];
+extern const char extcon_cable_name[][CABLE_NAME_MAX + 1];
 
 struct extcon_cable;
 
-- 
1.7.1

