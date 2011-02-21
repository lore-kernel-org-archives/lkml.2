Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab1BUHna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 02:43:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:47042 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab1BUHn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 02:43:29 -0500
Date: Mon, 21 Feb 2011 07:43:05 GMT
From: tip-bot for Kushal Koolwal <kushalkoolwal@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        kushalkoolwal@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, kushalkoolwal@gmail.com, mingo@elte.hu
In-Reply-To: <1298152563-21594-1-git-send-email-kushalkoolwal@gmail.com>
References: <1298152563-21594-1-git-send-email-kushalkoolwal@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix reboot problem on VersaLogic Menlow boards
Message-ID: <tip-e19e074b1525d11a66c8e3386fec7db248ad3005@git.kernel.org>
Git-Commit-ID: e19e074b1525d11a66c8e3386fec7db248ad3005
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 21 Feb 2011 07:43:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e19e074b1525d11a66c8e3386fec7db248ad3005
Gitweb:     http://git.kernel.org/tip/e19e074b1525d11a66c8e3386fec7db248ad3005
Author:     Kushal Koolwal <kushalkoolwal@gmail.com>
AuthorDate: Sat, 19 Feb 2011 13:56:03 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 21 Feb 2011 08:41:26 +0100

x86: Fix reboot problem on VersaLogic Menlow boards

VersaLogic Menlow based boards hang on reboot unless reboot=bios
is used. Add quirk to reboot through the BIOS.

Tested on at least four boards.

Signed-off-by: Kushal Koolwal <kushalkoolwal@gmail.com>
LKML-Reference: <1298152563-21594-1-git-send-email-kushalkoolwal@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index fc7aae1..715037c 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -285,6 +285,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
 		},
 	},
+	{	/* Handle problems with rebooting on VersaLogic Menlow boards */
+		.callback = set_bios_reboot,
+		.ident = "VersaLogic Menlow based board",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "VersaLogic Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "VersaLogic Menlow board"),
+		},
+	},
 	{ }
 };
 
