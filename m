Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965610Ab2EOCYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:24:35 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53559 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965568Ab2EOCS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:26 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 179/179] x86/PCI: do not tie MSI MS-7253 use_crs quirk to BIOS version
Date: Mon, 14 May 2012 22:14:35 -0400
Message-ID: <1337048075-6132-180-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Nieder <jrnieder@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a97f4f5e524bcd09a85ef0b8821a14d35e69335f upstream.

Carlos was getting

	WARNING: at drivers/pci/pci.c:118 pci_ioremap_bar+0x24/0x52()

when probing his sound card, and sound did not work.  After adding
pci=use_crs to the kernel command line, no more trouble.

Ok, we can add a quirk.  dmidecode output reveals that this is an MSI
MS-7253, for which we already have a quirk, but the short-sighted
author tied the quirk to a single BIOS version, making it not kick in
on Carlos's machine with BIOS V1.2.  If a later BIOS update makes it
no longer necessary to look at the _CRS info it will still be
harmless, so let's stop trying to guess which versions have and don't
have accurate _CRS tables.

Addresses https://bugtrack.alsa-project.org/alsa-bug/view.php?id=5533
Also see <https://bugzilla.kernel.org/show_bug.cgi?id=42619>.

Reported-by: Carlos Luna <caralu74@gmail.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/pci/acpi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 9b55642..15245cf 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -51,7 +51,6 @@ static const struct dmi_system_id pci_use_crs_table[] __initconst = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
 			DMI_MATCH(DMI_BOARD_NAME, "MS-7253"),
 			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
-			DMI_MATCH(DMI_BIOS_VERSION, "V1.6"),
 		},
 	},
 	{}
-- 
1.7.9.6

