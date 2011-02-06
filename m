Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1BFMaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:30:23 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:55108 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1BFMaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:30:18 -0500
X-Originating-IP: 217.70.178.42
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 16/18] eeepc-wmi: real touchpad led device id is 0x001000012
Date: Sun,  6 Feb 2011 13:28:41 +0100
Message-Id: <1296995324-5462-17-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
References: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/eeepc-wmi.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index bc71333..ffc5889 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -77,7 +77,7 @@ MODULE_ALIAS("wmi:"EEEPC_WMI_MGMT_GUID);
 #define EEEPC_WMI_DEVID_BRIGHTNESS	0x00050012
 #define EEEPC_WMI_DEVID_CAMERA		0x00060013
 #define EEEPC_WMI_DEVID_CARDREADER	0x00080013
-#define EEEPC_WMI_DEVID_TPDLED		0x00100011
+#define EEEPC_WMI_DEVID_TOUCHPAD_LED	0x00100012
 
 #define EEEPC_WMI_DSTS_STATUS_BIT	0x00000001
 #define EEEPC_WMI_DSTS_PRESENCE_BIT	0x00010000
@@ -303,7 +303,7 @@ static void tpd_led_update(struct work_struct *work)
 	eeepc = container_of(work, struct eeepc_wmi, tpd_led_work);
 
 	ctrl_param = eeepc->tpd_led_wk;
-	eeepc_wmi_set_devstate(EEEPC_WMI_DEVID_TPDLED, ctrl_param, NULL);
+	eeepc_wmi_set_devstate(EEEPC_WMI_DEVID_TOUCHPAD_LED, ctrl_param, NULL);
 }
 
 static void tpd_led_set(struct led_classdev *led_cdev,
@@ -317,9 +317,9 @@ static void tpd_led_set(struct led_classdev *led_cdev,
 	queue_work(eeepc->led_workqueue, &eeepc->tpd_led_work);
 }
 
-static int read_tpd_state(struct eeepc_wmi *eeepc)
+static int read_tpd_led_state(struct eeepc_wmi *eeepc)
 {
-	return eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_TPDLED);
+	return eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_TOUCHPAD_LED);
 }
 
 static enum led_brightness tpd_led_get(struct led_classdev *led_cdev)
@@ -328,14 +328,14 @@ static enum led_brightness tpd_led_get(struct led_classdev *led_cdev)
 
 	eeepc = container_of(led_cdev, struct eeepc_wmi, tpd_led);
 
-	return read_tpd_state(eeepc);
+	return read_tpd_led_state(eeepc);
 }
 
 static int eeepc_wmi_led_init(struct eeepc_wmi *eeepc)
 {
 	int rv;
 
-	if (read_tpd_state(eeepc) < 0)
+	if (read_tpd_led_state(eeepc) < 0)
 		return 0;
 
 	eeepc->led_workqueue = create_singlethread_workqueue("led_workqueue");
-- 
1.7.4.rc3

