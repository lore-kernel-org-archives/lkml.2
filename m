Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab1BZJXX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 04:23:23 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:36339 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1BZJXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 04:23:20 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.34
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        platform-driver-x86@vger.kernel.org (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 12/14] asus-wmi: add some common device ids and method ids
Date: Sat, 26 Feb 2011 10:20:41 +0100
Message-Id: <1298712045-17671-13-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
References: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I also found some leds ids (0x00020011-0x00020016 and 0x00040015),
but since they are not really present on the notebook,
I can't guess their name .

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-wmi.c |   44 ++++++++++++++++++++++++++++++++------
 1 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 9095c28..05db6b2 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -66,25 +66,46 @@ MODULE_LICENSE("GPL");
 #define NOTIFY_BRNDOWN_MAX		0x2e
 
 /* WMI Methods */
-#define ASUS_WMI_METHODID_SPEC	        0x43455053
-#define ASUS_WMI_METHODID_SFUN		0x4E554653
-#define ASUS_WMI_METHODID_DSTS		0x53544344
-#define ASUS_WMI_METHODID_DSTS2		0x53545344
-#define ASUS_WMI_METHODID_DEVS		0x53564544
-#define ASUS_WMI_METHODID_CFVS		0x53564643
-#define ASUS_WMI_METHODID_INIT		0x54494E49
+#define ASUS_WMI_METHODID_SPEC	        0x43455053 /* BIOS SPECification */
+#define ASUS_WMI_METHODID_SFBD		0x44424653 /* Set First Boot Device */
+#define ASUS_WMI_METHODID_GLCD		0x44434C47 /* Get LCD status */
+#define ASUS_WMI_METHODID_GPID		0x44495047 /* Get Panel ID?? (Resol) */
+#define ASUS_WMI_METHODID_QMOD		0x444F4D51 /* Quiet MODe */
+#define ASUS_WMI_METHODID_SPLV		0x4C425053 /* Set Panel Light Value */
+#define ASUS_WMI_METHODID_SFUN		0x4E554653 /* FUNCtionalities */
+#define ASUS_WMI_METHODID_SDSP		0x50534453 /* Set DiSPlay output */
+#define ASUS_WMI_METHODID_GDSP		0x50534447 /* Get DiSPlay output */
+#define ASUS_WMI_METHODID_DEVP		0x50564544 /* DEVice Policy */
+#define ASUS_WMI_METHODID_OSVR		0x5256534F /* OS VeRsion */
+#define ASUS_WMI_METHODID_DSTS		0x53544344 /* Device STatuS */
+#define ASUS_WMI_METHODID_DSTS2		0x53545344 /* Device STatuS #2*/
+#define ASUS_WMI_METHODID_BSTS		0x53545342 /* Bios STatuS ? */
+#define ASUS_WMI_METHODID_DEVS		0x53564544 /* DEVice Set */
+#define ASUS_WMI_METHODID_CFVS		0x53564643 /* CPU Frequency Volt Set */
+#define ASUS_WMI_METHODID_KBFT		0x5446424B /* KeyBoard FilTer */
+#define ASUS_WMI_METHODID_INIT		0x54494E49 /* INITialize */
+#define ASUS_WMI_METHODID_HKEY		0x59454B48 /* Hot KEY ?? */
 
 #define ASUS_WMI_UNSUPPORTED_METHOD	0xFFFFFFFE
 
 /* Wireless */
+#define ASUS_WMI_DEVID_HW_SWITCH	0x00010001
+#define ASUS_WMI_DEVID_WIRELESS_LED	0x00010002
 #define ASUS_WMI_DEVID_WLAN		0x00010011
 #define ASUS_WMI_DEVID_BLUETOOTH	0x00010013
+#define ASUS_WMI_DEVID_GPS		0x00010015
 #define ASUS_WMI_DEVID_WIMAX		0x00010017
 #define ASUS_WMI_DEVID_WWAN3G		0x00010019
+#define ASUS_WMI_DEVID_UWB		0x00010021
+
+/* Leds */
+/* 0x000200XX and 0x000400XX */
 
 /* Backlight and Brightness */
 #define ASUS_WMI_DEVID_BACKLIGHT	0x00050011
 #define ASUS_WMI_DEVID_BRIGHTNESS	0x00050012
+#define ASUS_WMI_DEVID_KBD_BACKLIGHT	0x00050021
+#define ASUS_WMI_DEVID_LIGHT_SENSOR	0x00050022 /* ?? */
 
 /* Misc */
 #define ASUS_WMI_DEVID_CAMERA		0x00060013
@@ -96,10 +117,19 @@ MODULE_LICENSE("GPL");
 #define ASUS_WMI_DEVID_TOUCHPAD		0x00100011
 #define ASUS_WMI_DEVID_TOUCHPAD_LED	0x00100012
 
+/* Fan, Thermal */
+#define ASUS_WMI_DEVID_THERMAL_CTRL	0x00110011
+#define ASUS_WMI_DEVID_FAN_CTRL		0x00110012
+
+/* Power */
+#define ASUS_WMI_DEVID_PROCESSOR_STATE	0x00120012
+
 /* DSTS masks */
 #define ASUS_WMI_DSTS_STATUS_BIT	0x00000001
 #define ASUS_WMI_DSTS_UNKNOWN_BIT	0x00000002
 #define ASUS_WMI_DSTS_PRESENCE_BIT	0x00010000
+#define ASUS_WMI_DSTS_USER_BIT		0x00020000
+#define ASUS_WMI_DSTS_BIOS_BIT		0x00040000
 #define ASUS_WMI_DSTS_BRIGHTNESS_MASK	0x000000FF
 #define ASUS_WMI_DSTS_MAX_BRIGTH_MASK	0x0000FF00
 
-- 
1.7.4

