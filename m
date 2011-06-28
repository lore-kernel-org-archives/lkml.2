Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab1F1OA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 10:00:28 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:60924 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145Ab1F1N5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 09:57:41 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Make Dell Latitude E6320 use reboot=pci
Date: Tue, 28 Jun 2011 15:57:31 +0200
Message-Id: <1309269451-4966-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Dell Latitude E6320 doesn't reboot unless reboot=pci is set.
Force it thanks to DMI.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 0c016f7..d712043 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -411,6 +411,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Latitude E6320. */
+		.callback = set_pci_reboot,
+		.ident = "Dell Latitude E6320",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6320"),
+		},
+	},
 	{ }
 };
 
-- 
1.7.4.1

