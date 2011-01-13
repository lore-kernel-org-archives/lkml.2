Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab1AMQCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:02:40 -0500
Received: from adelie.canonical.com ([91.189.90.139]:50985 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010Ab1AMQCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:02:30 -0500
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
Date: Thu, 13 Jan 2011 10:02:22 -0600
Message-Id: <1294934542-2411-2-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294934542-2411-1-git-send-email-manoj.iyer@canonical.com>
References: <1294934542-2411-1-git-send-email-manoj.iyer@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set acpi_skip_timer_override to force ignoring BIOS
IRQ0 pin2 override. This fixes resume from suspend on
AMD based ThinkPad Edge 11,13,14 and 15.

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
---
 arch/x86/kernel/acpi/boot.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index ec881c6..07b8ed5 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1418,6 +1418,42 @@ static struct dmi_system_id __initdata acpi_dmi_table[] = {
 		     DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 360"),
 		     },
 	 },
+	/* ThinkPad Edge 11 (AMD) */
+	{
+	 .callback = dmi_ignore_irq0_timer_override,
+	 .ident = "ThinkPad Edge",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "254523U"),
+		    },
+	},
+	/* ThinkPad Edge 13 (AMD) */
+	{
+	 .callback = dmi_ignore_irq0_timer_override,
+	 .ident = "ThinkPad Edge",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "022120U"),
+		    },
+	},
+	/* ThinkPad Edge 14 (AMD) */
+	{
+	 .callback = dmi_ignore_irq0_timer_override,
+	 .ident = "ThinkPad Edge",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "019923U"),
+		    },
+	},
+	/* ThinkPad Edge 15 (AMD) */
+	{
+	 .callback = dmi_ignore_irq0_timer_override,
+	 .ident = "ThinkPad Edge",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "030222U"),
+		    },
+	},
 	{}
 };
 
-- 
1.7.1

