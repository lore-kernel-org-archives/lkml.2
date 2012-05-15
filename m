Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965297Ab2EOCoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:44:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:49749 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965241Ab2EOCRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 118/179] x86: Make Dell Latitude E5420 use reboot=pci
Date: Mon, 14 May 2012 22:13:34 -0400
Message-ID: <1337048075-6132-119-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel J Blueman <daniel.blueman@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b7798d28ec15d20fd34b70fa57eb13f0cf6d1ecd upstream.

Rebooting on the Dell E5420 often hangs with the keyboard or ACPI
methods, but is reliable via the PCI method.

[ hpa: this was deferred because we believed for a long time that the
  recent reshuffling of the boot priorities in commit
  660e34cebf0a11d54f2d5dd8838607452355f321 fixed this platform.
  Unfortunately that turned out to be incorrect. ]

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Link: http://lkml.kernel.org/r/1305248699-2347-1-git-send-email-daniel.blueman@gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index ff8cc40..7a5cb07 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -469,6 +469,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
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
 	{ }
 };
 
-- 
1.7.9.6

