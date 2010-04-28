Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab0D1XnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:43:11 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53827 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab0D1XnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:43:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: sleep: init_set_sci_en_on_resume for Dell Studio 155x
Date: Wed, 28 Apr 2010 16:43:03 -0700
Message-Id: <1272498183-6094-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Dell Studio models (1558, 1557, 1555) to the 'set_sci_en_on_resume'
list to fix hang on resume.

BugLink: http://bugs.launchpad.net/bugs/553498

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Acked-by: Alex Chiang <achiang@canonical.com>
Cc: stable@kernel.org
---
 drivers/acpi/sleep.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index f74834a..d907c8a 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -458,6 +458,30 @@ static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "CF51-2L"),
 		},
 	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Dell Studio 1558",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1558"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Dell Studio 1557",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1557"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Dell Studio 1555",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1555"),
+		},
+	},
 	{},
 };
 #endif /* CONFIG_SUSPEND */
-- 
1.7.0.4
