Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab1LENZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:25:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57492 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab1LENZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:25:47 -0500
Date: Mon, 5 Dec 2011 05:25:32 -0800
From: "tip-bot for Rafael J. Wysocki" <rjw@sisk.pl>
Message-ID: <tip-6be30bb7d7504ec687a65c9bbdae8d1d2f8eaa19@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, rjw@sisk.pl, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rjw@sisk.pl, mingo@elte.hu
In-Reply-To: <201111160019.51303.rjw@sisk.pl>
References: <201111160019.51303.rjw@sisk.pl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/reboot: Blacklist Dell OptiPlex 990 known to require PCI reboot
Git-Commit-ID: 6be30bb7d7504ec687a65c9bbdae8d1d2f8eaa19
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:25:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6be30bb7d7504ec687a65c9bbdae8d1d2f8eaa19
Gitweb:     http://git.kernel.org/tip/6be30bb7d7504ec687a65c9bbdae8d1d2f8eaa19
Author:     Rafael J. Wysocki <rjw@sisk.pl>
AuthorDate: Wed, 16 Nov 2011 00:19:51 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 12:20:43 +0100

x86/reboot: Blacklist Dell OptiPlex 990 known to require PCI reboot

Dell OptiPlex 990 is known to require PCI reboot, so add it to
the reboot blacklist in pci_reboot_dmi_table[].

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Link: http://lkml.kernel.org/r/201111160019.51303.rjw@sisk.pl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index e334be1..4463d2f 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -443,6 +443,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6420"),
 		},
 	},
+	{	/* Handle problems with rebooting on the OptiPlex 990. */
+		.callback = set_pci_reboot,
+		.ident = "Dell OptiPlex 990",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 990"),
+		},
+	},
 	{ }
 };
 
