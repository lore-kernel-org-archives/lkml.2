Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab2A3NWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:22:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46516 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2A3NWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:22:47 -0500
Date: Mon, 30 Jan 2012 05:22:27 -0800
From: tip-bot for Michael D Labriola <michael.d.labriola@gmail.com>
Message-ID: <tip-e6d36a653becc7bbc643c399a77882e02bf552cb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, torvalds@linux-foundation.org, mlabriol@gdeb.com,
        kushalkoolwal@gmail.com, michael.d.labriola@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mlabriol@gdeb.com, kushalkoolwal@gmail.com,
        michael.d.labriola@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <87vcnub9hu.fsf@gmail.com>
References: <87vcnub9hu.fsf@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/reboot: Remove VersaLogic Menlow reboot quirk
Git-Commit-ID: e6d36a653becc7bbc643c399a77882e02bf552cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Jan 2012 05:22:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6d36a653becc7bbc643c399a77882e02bf552cb
Gitweb:     http://git.kernel.org/tip/e6d36a653becc7bbc643c399a77882e02bf552cb
Author:     Michael D Labriola <michael.d.labriola@gmail.com>
AuthorDate: Sun, 29 Jan 2012 14:21:17 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 30 Jan 2012 10:52:33 +0100

x86/reboot: Remove VersaLogic Menlow reboot quirk

This commit removes the reboot quirk originally added by commit
e19e074 ("x86: Fix reboot problem on VersaLogic Menlow boards").

Testing with a VersaLogic Ocelot (VL-EPMs-21a rev 1.00 w/ BIOS
6.5.102) revealed the following regarding the reboot hang
problem:

- v2.6.37 reboot=bios was needed.

- v2.6.38-rc1: behavior changed, reboot=acpi is needed,
  reboot=kbd and reboot=bios results in system hang.

- v2.6.38: VersaLogic patch (e19e074 "x86: Fix reboot problem on
  VersaLogic Menlow boards") was applied prior to v2.6.38-rc7.  This
  patch sets a quirk for VersaLogic Menlow boards that forces the use
  of reboot=bios, which doesn't work anymore.

- v3.2: It seems that commit 660e34c ("x86: Reorder reboot method
  preferences") changed the default reboot method to acpi prior to
  v3.0-rc1, which means the default behavior is appropriate for the
  Ocelot.  No VersaLogic quirk is required.

The Ocelot board used for testing can successfully reboot w/out
having to pass any reboot= arguments for all 3 current versions
of the BIOS.

Signed-off-by: Michael D Labriola <michael.d.labriola@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Michael D Labriola <mlabriol@gdeb.com>
Cc: Kushal Koolwal <kushalkoolwal@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/87vcnub9hu.fsf@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/reboot.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index b257f0e..d840e69 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -309,14 +309,6 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
 		},
 	},
-	{	/* Handle problems with rebooting on VersaLogic Menlow boards */
-		.callback = set_bios_reboot,
-		.ident = "VersaLogic Menlow based board",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "VersaLogic Corporation"),
-			DMI_MATCH(DMI_BOARD_NAME, "VersaLogic Menlow board"),
-		},
-	},
 	{ /* Handle reboot issue on Acer Aspire one */
 		.callback = set_kbd_reboot,
 		.ident = "Acer Aspire One A110",
