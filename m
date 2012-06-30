Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab2F3FQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 01:16:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59580 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2F3FQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 01:16:20 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 5/8] ACPI: Add a quirk for "AMILO PRO V2030" to ignore the timer overriding
Date: Sat, 30 Jun 2012 01:07:32 -0400
Message-Id: <f6b54f083cc66cf9b11d2120d8df3c2ad4e0836d.1341032550.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.11.1.104.ge7b44f1
In-Reply-To: <1341032855-27139-1-git-send-email-lenb@kernel.org>
References: <1341032855-27139-1-git-send-email-lenb@kernel.org>
In-Reply-To: <9f132652d94c96476b0b0a8caf0c10e96ab10fa8.1341032550.git.len.brown@intel.com>
References: <9f132652d94c96476b0b0a8caf0c10e96ab10fa8.1341032550.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

This is the 2nd part of fix for kernel bugzilla 40002:
    "IRQ 0 assigned to VGA"
https://bugzilla.kernel.org/show_bug.cgi?id=40002

The root cause is the buggy FW, whose ACPI tables assign the GSI 16
to 2 irqs 0 and 16(VGA), and the VGA is the right owner of GSI 16.
So add a quirk to ignore the irq0 overriding GSI 16 for the
FUJITSU SIEMENS AMILO PRO V2030 platform will solve this issue.

Reported-and-tested-by: Szymon Kowalczyk <fazerxlo@o2.pl>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/acpi/boot.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 3a6afba..b2297e5 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1470,6 +1470,14 @@ static struct dmi_system_id __initdata acpi_dmi_table_late[] = {
 		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 6715b"),
 		     },
 	 },
+	{
+	 .callback = dmi_ignore_irq0_timer_override,
+	 .ident = "FUJITSU SIEMENS",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "AMILO PRO V2030"),
+		     },
+	 },
 	{}
 };
 
-- 
1.7.11.1.104.ge7b44f1

