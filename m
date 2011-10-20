Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab1JTPiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:38:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472Ab1JTPis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:38:48 -0400
From: Thomas Renninger <trenn@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Fix reboot issue for Dell Optiplex 990
Date: Thu, 20 Oct 2011 17:39:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: Ingo Molnar <mingo@redhat.com>, chaas@suse.de, stable@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110201739.12439.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was the only reboot=x option that worked for this desktop.


Signed-off-by: Thomas Renninger <trenn@suse.de>
Tested-by: Christian Haas <chaas@suse.de>
CC: linux-acpi@vger.kernel.org
CC: stable@kernel.org

---
 arch/x86/kernel/reboot.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-3.1-rc9-master/arch/x86/kernel/reboot.c
===================================================================
--- linux-3.1-rc9-master.orig/arch/x86/kernel/reboot.c
+++ linux-3.1-rc9-master/arch/x86/kernel/reboot.c
@@ -443,6 +443,15 @@ static struct dmi_system_id __initdata p
 			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6420"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Latitude E6420. */
+		.callback = set_pci_reboot,
+		.ident = "Dell Optiplex 990",
+		.matches = {
+			/* Found in BIOS version A06 */
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 990"),
+		},
+	},
 	{ }
 };
 
