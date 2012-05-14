Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab2ENT1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 15:27:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50133 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab2ENT1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 15:27:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Mario Limonciello <mario_limonciello@dell.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH] dell-laptop: rfkill blacklist Dell XPS 13z, 15z
Date: Mon, 14 May 2012 12:27:32 -0700
Message-Id: <1337023652-11661-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mario Limonciello <mario_limonciello@dell.com>

On Dell XPS 13z (L321X) and 15z (L502X), switching off Bluetooth also
disables wifi due to improper improper BIOS interaction with dell-laptop.
Add those models to the rfkill blacklist.

BugLink: https://bugs.launchpad.net/bugs/901410

Signed-off-by: Mario Limonciello <mario_limonciello@dell.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/platform/x86/dell-laptop.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index e6c08ee..8223b6c 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -120,6 +120,21 @@ static const struct dmi_system_id __initdata dell_device_table[] = {
 MODULE_DEVICE_TABLE(dmi, dell_device_table);
 
 static struct dmi_system_id __devinitdata dell_blacklist[] = {
+	/* dell_laptop breaks rfkill behavior (LP: #901410) */
+	{
+		.ident = "Dell XPS 13z",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell System XPS L321X"),
+		},
+	},
+	{
+		.ident = "Dell XPS 15z",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell System XPS L502X"),
+		},
+	},
 	/* Supported by compal-laptop */
 	{
 		.ident = "Dell Mini 9",
-- 
1.7.9.5

