Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab0E2G0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 02:26:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60017 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0E2G0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 02:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=myF0lDLj691Fco/Yd5KM2c/j+6XR4AISvYPmL6c+pEuF4GAkC0mFZoPajUREKHxfLI
         KvAkb9fQHQqq9yEWcFMm4sbJph4rxFAiuXi85HVnuioVlyrvFgFUO27QmbBmgQBLEj/g
         01if04frOzNanQWSux5fW6962UK7WExatuB/Y=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: x86@kernel.org
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]X86:reboot.c Add some dmi entries to pci_reboot_dmi_table.
Date: Fri, 28 May 2010 23:26:11 -0700
Message-Id: <1275114371-5329-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dmi entries to pci_reboot_dmi_table to fix some
reboot issues on some apple products.
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/499497
https://help.ubuntu.com/community/MacBook6-1/Karmic
http://ubuntu-utah.ubuntuforums.org/showthread.php?t=1476226
I dont have the machines on me(please test people),
but if this is the same as what I experienced with my
iMac9,1 then this should resolve the issue of having to
use a bootparam.
 
 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/x86/kernel/reboot.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 8e1aac8..1ab41d3 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -453,6 +453,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5"),
 		},
 	},
+	{	/* Handle problems with rebooting on Apple MacBookPro6,1 */
+		.callback = set_pci_reboot,
+		.ident = "Apple MacBookPro6,1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro6,1"),
+		},
+	},
 	{	/* Handle problems with rebooting on Apple Macmini3,1 */
 		.callback = set_pci_reboot,
 		.ident = "Apple Macmini3,1",
@@ -469,6 +477,22 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
 		},
 	},
+	{	/* Handle problems with rebooting on the iMac10,1. */
+		.callback = set_pci_reboot,
+		.ident = "Apple iMac10,1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac10,1"),
+		},
+	},
+	{	/* Handle problems with rebooting on the iMac11,1. */
+		.callback = set_pci_reboot,
+		.ident = "Apple iMac11,1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac11,1"),
+		},
+	},
 	{ }
 };
 
-- 
1.6.5.2.180.gc5b3e

