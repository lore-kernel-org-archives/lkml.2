Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab0FTH2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 03:28:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:53309 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab0FTH21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 03:28:27 -0400
Date: Sun, 20 Jun 2010 07:27:50 GMT
From: tip-bot for Thomas Backlund <tmb@mandriva.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tmb@mandriva.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tmb@mandriva.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4C1CC6E9.6000701@mandriva.org>
References: <4C1CC6E9.6000701@mandriva.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix rebooting on Dell Precision WorkStation T7400
Message-ID: <tip-890ffedc7c3e95595926379e28ad2e16e7d7c613@git.kernel.org>
Git-Commit-ID: 890ffedc7c3e95595926379e28ad2e16e7d7c613
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 20 Jun 2010 07:27:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  890ffedc7c3e95595926379e28ad2e16e7d7c613
Gitweb:     http://git.kernel.org/tip/890ffedc7c3e95595926379e28ad2e16e7d7c613
Author:     Thomas Backlund <tmb@mandriva.org>
AuthorDate: Sat, 19 Jun 2010 16:32:25 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Jun 2010 09:24:13 +0200

x86: Fix rebooting on Dell Precision WorkStation T7400

Dell Precision WorkStation T7400 freezes on reboot unless
reboot=b is used.

Reference: https://qa.mandriva.com/show_bug.cgi?id=58017

Signed-off-by: Thomas Backlund <tmb@mandriva.org>
LKML-Reference: <4C1CC6E9.6000701@mandriva.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 8e1aac8..e3af342 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -228,6 +228,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation T5400"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell T7400's */
+		.callback = set_bios_reboot,
+		.ident = "Dell Precision T7400",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation T7400"),
+		},
+	},
 	{	/* Handle problems with rebooting on HP laptops */
 		.callback = set_bios_reboot,
 		.ident = "HP Compaq Laptop",
