Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1LAIM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:12:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37227 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab1LAIMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:12:53 -0500
From: Keng-Yu Lin <kengyu@canonical.com>
To: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Keng-Yu Lin <kengyu@canonical.com>
Subject: [PATCH] ACPI / PM: Do not save/restore NVS on Asus K54C/K54HR
Date: Thu,  1 Dec 2011 16:12:32 +0800
Message-Id: <1322727152-4084-1-git-send-email-kengyu@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The models do not resume correctly without acpi_sleep=nonvs.

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
---
 drivers/acpi/sleep.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 6d9a3ab..0a7ed69 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -476,6 +476,22 @@ static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW520F"),
 		},
 	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Asus K54C",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "K54C"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Asus K54HR",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "K54HR"),
+		},
+	},
 	{},
 };
 #endif /* CONFIG_SUSPEND */
-- 
1.7.5.4

