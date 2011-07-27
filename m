Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab1G0M45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 08:56:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab1G0M4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:56:55 -0400
Date: Wed, 27 Jul 2011 13:56:51 +0100
From: Mel Gorman <mgorman@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com
Cc: bruno@ioda-net.ch, mjg@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Add reboot quirk for Dell Precision M4600
Message-ID: <20110727125651.GH3010@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI reboot does not work for Dell Precision M4600. Detect this
machine via DMI and force the use of the PCI reboot method.
    
Reported-and-tested-by: Bruno Friedmann <bruno@ioda-net.ch>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/x86/kernel/reboot.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 9242436..7ca2ec4 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -443,6 +443,15 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6420"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell Precision M4600's */
+		.callback = set_pci_reboot,
+		.ident = "Dell Precision M4600",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M4600"),
+		},
+	},
+
 	{ }
 };
 
