Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab1KOXRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:17:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41172 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957Ab1KOXRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:17:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86 / reboot: Blacklist Dell OptiPlex 990 known to require PCI reboot
Date: Wed, 16 Nov 2011 00:19:51 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111160019.51303.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Dell OptiPlex 990 is known to require PCI reboot, so add it to the reboot
blacklist in pci_reboot_dmi_table[].

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux/arch/x86/kernel/reboot.c
===================================================================
--- linux.orig/arch/x86/kernel/reboot.c
+++ linux/arch/x86/kernel/reboot.c
@@ -443,6 +443,14 @@ static struct dmi_system_id __initdata p
 			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6420"),
 		},
 	},
+	{	/* Handle problems with rebooting on the OptiPlex 990. */
+		.callback = set_pci_reboot,
+		.ident = "Dell OptiPlex 990",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 990"),
+		},
+	},
 	{ }
 };
 
