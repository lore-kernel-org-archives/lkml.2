Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1GUStC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:49:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:60152 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876Ab1GUStA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:49:00 -0400
Date: Thu, 21 Jul 2011 18:48:54 GMT
From: tip-bot for Daniel J Blueman <daniel.blueman@gmail.com>
Message-ID: <tip-b7798d28ec15d20fd34b70fa57eb13f0cf6d1ecd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        stable@kernel.org, daniel.blueman@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        daniel.blueman@gmail.com, stable@kernel.org, tglx@linutronix.de
In-Reply-To: <1305248699-2347-1-git-send-email-daniel.blueman@gmail.com>
References: <1305248699-2347-1-git-send-email-daniel.blueman@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Make Dell Latitude E5420 use reboot=pci
Git-Commit-ID: b7798d28ec15d20fd34b70fa57eb13f0cf6d1ecd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 18:48:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7798d28ec15d20fd34b70fa57eb13f0cf6d1ecd
Gitweb:     http://git.kernel.org/tip/b7798d28ec15d20fd34b70fa57eb13f0cf6d1ecd
Author:     Daniel J Blueman <daniel.blueman@gmail.com>
AuthorDate: Fri, 13 May 2011 09:04:59 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 21 Jul 2011 11:45:49 -0700

x86: Make Dell Latitude E5420 use reboot=pci

Rebooting on the Dell E5420 often hangs with the keyboard or ACPI
methods, but is reliable via the PCI method.

[ hpa: this was deferred because we believed for a long time that the
  recent reshuffling of the boot priorities in commit
  660e34cebf0a11d54f2d5dd8838607452355f321 fixed this platform.
  Unfortunately that turned out to be incorrect. ]

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Link: http://lkml.kernel.org/r/1305248699-2347-1-git-send-email-daniel.blueman@gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@kernel.org>

---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 14eed21..3dfd38f 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -427,6 +427,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
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
 	{ }
 };
 
