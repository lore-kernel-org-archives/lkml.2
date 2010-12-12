Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab0LLULu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 15:11:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47695 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab0LLULs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 15:11:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI / PM: Do not save/restore NVS on Sony Vaio VGN-NW130D
Date: Sun, 12 Dec 2010 21:10:42 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Adriano <adriano.vilela@yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012122110.42717.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The saving of the NVS memory area during suspend and restoring it
during resume causes problems to appear on Sony Vaio VGN-NW130D, so
blacklist that machine to avoid those problems.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=23002

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-and-tested-by: Adriano <adriano.vilela@yahoo.com>
---

Hi Len,

Another Vaio needing acpi_sleep=nonvs, please apply.

Thanks,
Rafael

---
 drivers/acpi/sleep.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/drivers/acpi/sleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep.c
+++ linux-2.6/drivers/acpi/sleep.c
@@ -427,6 +427,14 @@ static struct dmi_system_id __initdata a
 		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEB1Z1E"),
 		},
 	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VGN-NW130D",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-NW130D"),
+		},
+	},
 	{},
 };
 #endif /* CONFIG_SUSPEND */
