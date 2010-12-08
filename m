Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab0LHPiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:38:11 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:50829 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab0LHPiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:38:09 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] x86: Dell Precision WorkStation 690 reboot quirk
X-Mercurial-Node: 4d8b4b3a1d3c6034b86889fac38dd53e6579bb42
Message-Id: <4d8b4b3a1d3c6034b868.1291822674@egomez.in.mobiclip.com>
User-Agent: Mercurial-patchbomb/1.7.1+23-8766585f5259
Date: Wed, 08 Dec 2010 16:37:54 +0100
From: Edouard Gomez <ed.gomez@free.fr>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Thomas Backlund <tmb@mandriva.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        linux-kernel@vger.kernel.org
Cc: ed.gomez@free.fr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Edouard Gomez <ed.gomez@free.fr>
# Date 1291821505 -3600
# Node ID 4d8b4b3a1d3c6034b86889fac38dd53e6579bb42
# Parent  53e51000d59963c8ca408db4db619d2c82374c5e
x86: Dell Precision WorkStation 690 reboot quirk

This Dell workstation gets stuck on reboot unless booted with
the paremeter reboot=bios.

This patch has been submitted 3 times already to X86 ARCHITECTURE
maintainers w/o any feedback so far. Trying my chance on the LKML.

Patch is against 2.6.36.1

Signed-off-by: Edouard Gomez <ed.gomez@free.fr>

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -236,6 +236,15 @@
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation T7400"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell 690's */
+		.callback = set_bios_reboot,
+		.ident = "Dell Precision 690",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation 690"),
+			DMI_MATCH(DMI_BOARD_NAME, "0MY171"),
+		},
+	},
 	{	/* Handle problems with rebooting on HP laptops */
 		.callback = set_bios_reboot,
 		.ident = "HP Compaq Laptop",
