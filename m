Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab1KEAoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 20:44:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab1KEAoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 20:44:18 -0400
From: Thomas Renninger <trenn@suse.de>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-acpi@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>, stable@kernel.org
Subject: [PATCH] X86: Solve Dell Latitudes do not reboot on x86_64 more generally
Date: Sat,  5 Nov 2011 01:44:03 +0100
Message-Id: <1320453843-938-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <4EB39139.3090709@suse.de>
References: <4EB39139.3090709@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are quite some reports that those do not reboot:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/833705
->E6520, E6220
http://www.linux-club.de/viewtopic.php?f=29&t=114459&start=20
->E5520
and some more already are blacklisted

This patch improves the blacklist for all E6xxx and E5xxx Latitudes.

Strange is that on above Ubuntu bug it was mentioned that 32 bit
reboots just fine, which should use the same mechanism than 64 bit
by default (ACPI).

While this should solve the problem on short term for quite some users,
hopefully a more generic way is found sooner or later...


Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: stable@kernel.org
---
 arch/x86/kernel/reboot.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 42f8cd7..7fcb20a 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -419,28 +419,20 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
 		},
 	},
-	{	/* Handle problems with rebooting on the Latitude E6320. */
-		.callback = set_pci_reboot,
-		.ident = "Dell Latitude E6320",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6320"),
-		},
-	},
-	{	/* Handle problems with rebooting on the Latitude E5420. */
+	{
 		.callback = set_pci_reboot,
-		.ident = "Dell Latitude E5420",
+		.ident = "Dell Latitude E5xxx",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E5420"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E5"),
 		},
 	},
-	{	/* Handle problems with rebooting on the Latitude E6420. */
+	{
 		.callback = set_pci_reboot,
-		.ident = "Dell Latitude E6420",
+		.ident = "Dell Latitude E6xxx",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6420"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6"),
 		},
 	},
 	{
-- 
1.7.6.1

