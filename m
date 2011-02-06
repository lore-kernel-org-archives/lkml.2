Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab1BFMaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:30:30 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:41725 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab1BFMa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:30:27 -0500
X-Originating-IP: 217.70.178.42
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chris Bagwell <chris@cnpbagwell.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH v2 17/18] eeepc-wmi: add touchpad sysfs file
Date: Sun,  6 Feb 2011 13:28:42 +0100
Message-Id: <1296995324-5462-18-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
References: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 Documentation/ABI/testing/sysfs-platform-eeepc-wmi |    7 +++++++
 drivers/platform/x86/eeepc-wmi.c                   |    5 +++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-platform-eeepc-wmi b/Documentation/ABI/testing/sysfs-platform-eeepc-wmi
index 9fc8d33..26acb68 100644
--- a/Documentation/ABI/testing/sysfs-platform-eeepc-wmi
+++ b/Documentation/ABI/testing/sysfs-platform-eeepc-wmi
@@ -22,3 +22,10 @@ KernelVersion:	2.6.39
 Contact:	"Corentin Chary" <corentincj@iksaif.net>
 Description:
 		Control the card reader. 1 means on, 0 means off.
+
+What:		/sys/devices/platform/eeepc-wmi/touchpad
+Date:		Jan 2010
+KernelVersion:	2.6.39
+Contact:	"Corentin Chary" <corentincj@iksaif.net>
+Description:
+		Control the card touchpad. 1 means on, 0 means off.
diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index ffc5889..26ed706 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -77,6 +77,7 @@ MODULE_ALIAS("wmi:"EEEPC_WMI_MGMT_GUID);
 #define EEEPC_WMI_DEVID_BRIGHTNESS	0x00050012
 #define EEEPC_WMI_DEVID_CAMERA		0x00060013
 #define EEEPC_WMI_DEVID_CARDREADER	0x00080013
+#define EEEPC_WMI_DEVID_TOUCHPAD	0x00100011
 #define EEEPC_WMI_DEVID_TOUCHPAD_LED	0x00100012
 
 #define EEEPC_WMI_DSTS_STATUS_BIT	0x00000001
@@ -1006,6 +1007,7 @@ static ssize_t show_sys_wmi(int devid, char *buf)
 		.store  = store_##_name,				\
 	}
 
+EEEPC_WMI_CREATE_DEVICE_ATTR(touchpad, 0644, EEEPC_WMI_DEVID_TOUCHPAD);
 EEEPC_WMI_CREATE_DEVICE_ATTR(camera, 0644, EEEPC_WMI_DEVID_CAMERA);
 EEEPC_WMI_CREATE_DEVICE_ATTR(cardr, 0644, EEEPC_WMI_DEVID_CARDREADER);
 
@@ -1036,6 +1038,7 @@ static struct attribute *platform_attributes[] = {
 	&dev_attr_cpufv.attr,
 	&dev_attr_camera.attr,
 	&dev_attr_cardr.attr,
+	&dev_attr_touchpad.attr,
 	NULL
 };
 
@@ -1050,6 +1053,8 @@ static mode_t eeepc_sysfs_is_visible(struct kobject *kobj,
 		devid = EEEPC_WMI_DEVID_CAMERA;
 	else if (attr == &dev_attr_cardr.attr)
 		devid = EEEPC_WMI_DEVID_CARDREADER;
+	else if (attr == &dev_attr_touchpad.attr)
+		devid = EEEPC_WMI_DEVID_TOUCHPAD;
 
 	if (devid != -1)
 		supported = eeepc_wmi_get_devstate_simple(devid) != -ENODEV;
-- 
1.7.4.rc3

