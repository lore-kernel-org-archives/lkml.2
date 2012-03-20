Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574Ab2CTIy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:54:27 -0400
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:39113 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759546Ab2CTIyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:54:17 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] eeepc-wmi: refine quirks handling
Date: Tue, 20 Mar 2012 09:53:12 +0100
Message-Id: <1332233594-13099-13-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
References: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrgeejucetggdotefuucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenuc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/eeepc-wmi.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 389ff88..0bb0aaf 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -49,7 +49,6 @@ MODULE_LICENSE("GPL");
 
 MODULE_ALIAS("wmi:"EEEPC_WMI_EVENT_GUID);
 
-static struct quirk_entry *quirks;
 static bool hotplug_wireless;
 
 module_param(hotplug_wireless, bool, 0444);
@@ -108,6 +107,8 @@ static struct quirk_entry quirk_asus_et2012_type3 = {
 	.store_backlight_power = true,
 };
 
+static struct quirk_entry *quirks;
+
 static int dmi_matched(const struct dmi_system_id *dmi)
 {
 	char *model;
@@ -209,12 +210,14 @@ static int eeepc_wmi_probe(struct platform_device *pdev)
 
 static void eeepc_wmi_quirks(struct asus_wmi_driver *driver)
 {
-	driver->panel_power = FB_BLANK_UNBLANK;
-	driver->quirks = &quirk_asus_unknown;
-	driver->quirks->hotplug_wireless = hotplug_wireless;
-	driver->quirks->wapf = -1;
+	quirks = &quirk_asus_unknown;
+	quirks->hotplug_wireless = hotplug_wireless;
+
 	dmi_check_system(asus_quirks);
+
 	driver->quirks = quirks;
+	driver->quirks->wapf = -1;
+	driver->panel_power = FB_BLANK_UNBLANK;
 }
 
 static struct asus_wmi_driver asus_wmi_driver = {
-- 
1.7.3.4

