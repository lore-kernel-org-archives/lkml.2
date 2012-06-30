Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab2F3FPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 01:15:05 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64540 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2F3FPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 01:15:02 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 2/8] ACPI, x86: fix Dell M6600 ACPI reboot regression via DMI
Date: Sat, 30 Jun 2012 01:07:29 -0400
Message-Id: <76eb9a30db4bc8fd172f9155247264b5f2686d7b.1341032550.git.len.brown@intel.com>
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

From: Zhang Rui <rui.zhang@intel.com>

Dell Precision M6600 is known to require PCI reboot, so add it to
the reboot blacklist in pci_reboot_dmi_table[].

https://bugzilla.kernel.org/show_bug.cgi?id=42749

cc: x86@kernel.org
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/reboot.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 79c45af..412db57 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -451,6 +451,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 990"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Precision M6600. */
+		.callback = set_pci_reboot,
+		.ident = "Dell OptiPlex 990",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M6600"),
+		},
+	},
 	{ }
 };
 
-- 
1.7.11.1.104.ge7b44f1

