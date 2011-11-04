Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab1KDCYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:24:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab1KDCYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:24:47 -0400
From: Thomas Renninger <trenn@suse.de>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Thomas Renninger <trenn@suse.de>,
        Ismail Donmez <idoenmez@suse.de>, stable@kernel.org
Subject: [PATCH 1/2] x86: Fix reboot issue for Dell Optiplex 990 V2
Date: Fri,  4 Nov 2011 03:24:30 +0100
Message-Id: <1320373471-3942-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was the only (reboot=p) option that worked for this desktop.
Default does not reboot as well.

V2: Remove copy and paste left over from another machine

CC: Ismail Donmez <idoenmez@suse.de>
CC: stable@kernel.org
Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 arch/x86/kernel/reboot.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index e334be1..a6875b1 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -443,6 +443,15 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
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
 
-- 
1.7.6.1

