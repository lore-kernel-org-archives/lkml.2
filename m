Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1GUS5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:57:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59415 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab1GUS5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:57:40 -0400
Date: Thu, 21 Jul 2011 11:57:17 -0700
Message-Id: <201107211857.p6LIvHUM016199@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 reboot quirks for 3.0-final
Cc: <stable@kernel.org>, Daniel J Blueman <daniel.blueman@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A very last minute pull request containing only two reboot quirks.

The following changes since commit cf6ace16a3cd8b728fb0afa68368fd40bbeae19f:

  Merge branch 'core-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-07-20 15:56:25 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-urgent-for-linus

Daniel J Blueman (1):
      x86: Make Dell Latitude E5420 use reboot=pci

H. Peter Anvin (1):
      x86: Make Dell Latitude E6420 use reboot=pci

 arch/x86/kernel/reboot.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 14eed21..9242436 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -427,6 +427,22 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6320"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Latitude E5420. */
+		.callback = set_pci_reboot,
+		.ident = "Dell Latitude E5420",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E5420"),
+		},
+	},
+	{	/* Handle problems with rebooting on the Latitude E6420. */
+		.callback = set_pci_reboot,
+		.ident = "Dell Latitude E6420",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6420"),
+		},
+	},
 	{ }
 };
 
