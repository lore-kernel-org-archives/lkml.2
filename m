Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab1GMEtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 00:49:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:60586 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab1GMEtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 00:49:18 -0400
Date: Wed, 13 Jul 2011 04:48:54 GMT
From: tip-bot for Maxime Ripard <maxime.ripard@free-electrons.com>
Message-ID: <tip-3628c3f5c818cfc6e588d1ccb31f19aa12345c02@git.kernel.org>
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, maxime.ripard@free-electrons.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mjg@redhat.com, tglx@linutronix.de, maxime.ripard@free-electrons.com
In-Reply-To: <1309269451-4966-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1309269451-4966-1-git-send-email-maxime.ripard@free-electrons.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86. reboot: Make Dell Latitude E6320 use reboot=pci
Git-Commit-ID: 3628c3f5c818cfc6e588d1ccb31f19aa12345c02
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jul 2011 04:48:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3628c3f5c818cfc6e588d1ccb31f19aa12345c02
Gitweb:     http://git.kernel.org/tip/3628c3f5c818cfc6e588d1ccb31f19aa12345c02
Author:     Maxime Ripard <maxime.ripard@free-electrons.com>
AuthorDate: Tue, 28 Jun 2011 15:57:31 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 12 Jul 2011 21:42:48 -0700

x86. reboot: Make Dell Latitude E6320 use reboot=pci

The Dell Latitude E6320 doesn't reboot unless reboot=pci is set.
Force it thanks to DMI.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Link: http://lkml.kernel.org/r/1309269451-4966-1-git-send-email-maxime.ripard@free-electrons.com
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 4f0d46f..14eed21 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -419,6 +419,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Latitude E6320. */
+		.callback = set_pci_reboot,
+		.ident = "Dell Latitude E6320",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6320"),
+		},
+	},
 	{ }
 };
 
