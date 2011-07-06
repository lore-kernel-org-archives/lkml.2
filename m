Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156Ab1GFEHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 00:07:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:36998 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab1GFEHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 00:07:21 -0400
Date: Wed, 6 Jul 2011 04:07:08 GMT
From: tip-bot for Peter Chubb <peter.chubb@nicta.com.au>
Message-ID: <tip-b49c78d4827be8d7e67e5b94adac6b30a4a9ad14@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, peter.chubb@nicta.com.au
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, peter.chubb@nicta.com.au
In-Reply-To: <w439iki5vl.wl%peter@chubb.wattle.id.au>
References: <w439iki5vl.wl%peter@chubb.wattle.id.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, reboot: Acer Aspire One A110 reboot quirk
Git-Commit-ID: b49c78d4827be8d7e67e5b94adac6b30a4a9ad14
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 06 Jul 2011 04:07:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b49c78d4827be8d7e67e5b94adac6b30a4a9ad14
Gitweb:     http://git.kernel.org/tip/b49c78d4827be8d7e67e5b94adac6b30a4a9ad14
Author:     Peter Chubb <peter.chubb@nicta.com.au>
AuthorDate: Wed, 6 Jul 2011 10:56:30 +1000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 5 Jul 2011 19:43:23 -0700

x86, reboot: Acer Aspire One A110 reboot quirk

Since git commit
  660e34cebf0a11d54f2d5dd8838607452355f321 x86: reorder reboot method
  preferences,
my Acer Aspire One hangs on reboot.  It appears that its ACPI method
for rebooting is broken.  The attached patch adds a quirk so that the
machine will reboot via the BIOS.

[ hpa: verified that the ACPI control on this machine is just plain broken. ]

Signed-off-by: Peter Chubb <peter.chubb@nicta.com.au>
Link: http://lkml.kernel.org/r/w439iki5vl.wl%25peter@chubb.wattle.id.au
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 0c016f7..4f0d46f 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -294,6 +294,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "VersaLogic Menlow board"),
 		},
 	},
+	{ /* Handle reboot issue on Acer Aspire one */
+		.callback = set_bios_reboot,
+		.ident = "Acer Aspire One A110",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AOA110"),
+		},
+	},
 	{ }
 };
 
