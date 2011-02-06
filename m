Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab1BFMag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:30:36 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:57905 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab1BFMab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:30:31 -0500
X-Originating-IP: 217.70.178.45
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 18/18] eeepc-wmi: reorder device ids
Date: Sun,  6 Feb 2011 13:28:43 +0100
Message-Id: <1296995324-5462-19-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
References: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each device seems to be in a "group" (devid >> 16 & 0xFF).

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/eeepc-wmi.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 26ed706..b0b5a8f 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -65,21 +65,32 @@ MODULE_ALIAS("wmi:"EEEPC_WMI_MGMT_GUID);
 #define NOTIFY_BRNDOWN_MIN		0x20
 #define NOTIFY_BRNDOWN_MAX		0x2e
 
+/* WMI Methods */
 #define EEEPC_WMI_METHODID_DSTS		0x53544344
 #define EEEPC_WMI_METHODID_DEVS		0x53564544
 #define EEEPC_WMI_METHODID_CFVS		0x53564643
 
+/* Wireless */
 #define EEEPC_WMI_DEVID_WLAN		0x00010011
 #define EEEPC_WMI_DEVID_BLUETOOTH	0x00010013
 #define EEEPC_WMI_DEVID_WIMAX		0x00010017
 #define EEEPC_WMI_DEVID_WWAN3G		0x00010019
+
+/* Backlight and Brightness */
 #define EEEPC_WMI_DEVID_BACKLIGHT	0x00050011
 #define EEEPC_WMI_DEVID_BRIGHTNESS	0x00050012
+
+/* Misc */
 #define EEEPC_WMI_DEVID_CAMERA		0x00060013
+
+/* Storage */
 #define EEEPC_WMI_DEVID_CARDREADER	0x00080013
+
+/* Input */
 #define EEEPC_WMI_DEVID_TOUCHPAD	0x00100011
 #define EEEPC_WMI_DEVID_TOUCHPAD_LED	0x00100012
 
+/* DSTS masks */
 #define EEEPC_WMI_DSTS_STATUS_BIT	0x00000001
 #define EEEPC_WMI_DSTS_PRESENCE_BIT	0x00010000
 #define EEEPC_WMI_DSTS_BRIGHTNESS_MASK	0x000000FF
-- 
1.7.4.rc3

