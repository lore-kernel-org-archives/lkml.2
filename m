Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab2GWBmb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:42:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54063 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752837Ab2GWBm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:29 -0400
Message-Id: <20120723010705.811727643@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [ 094/108] ACPI, x86: fix Dell M6600 ACPI reboot regression via DMI
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit 76eb9a30db4bc8fd172f9155247264b5f2686d7b upstream.

Dell Precision M6600 is known to require PCI reboot, so add it to
the reboot blacklist in pci_reboot_dmi_table[].

https://bugzilla.kernel.org/show_bug.cgi?id=42749

cc: x86@kernel.org
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
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
 


