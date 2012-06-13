Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab2FMHcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:32:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35258 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab2FMHcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:32:18 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] samsung-laptop: X360 ACPI backlight device is broken
Date: Wed, 13 Jun 2012 09:32:03 +0200
Message-Id: <1339572727-24744-4-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339572727-24744-1-git-send-email-corentin.chary@gmail.com>
References: <1339572727-24744-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/samsung-laptop.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index 2cbccc1..98f0758 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -1506,6 +1506,16 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
 		},
 	 .driver_data = &samsung_broken_acpi_video,
 	},
+	{
+	 .callback = samsung_dmi_matched,
+	 .ident = "X360",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "X360"),
+		DMI_MATCH(DMI_BOARD_NAME, "X360"),
+		},
+	 .driver_data = &samsung_broken_acpi_video,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);
-- 
1.7.9.5

