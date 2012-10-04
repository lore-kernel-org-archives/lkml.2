Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2JDKeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:34:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49594 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab2JDKeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:34:19 -0400
Date: Thu, 4 Oct 2012 03:33:59 -0700
From: tip-bot for David Hooper <dave@beermex.com>
Message-ID: <tip-fcd8af585f587741c051f7124b8dee6c73c8629b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@kernel.org, dave@beermex.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, dave@beermex.com, tglx@linutronix.de
In-Reply-To: <20121002142635.17403.59959.stgit@localhost.localdomain>
References: <20121002142635.17403.59959.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/reboot: Remove quirk entry for SBC FITPC
Git-Commit-ID: fcd8af585f587741c051f7124b8dee6c73c8629b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 04 Oct 2012 03:34:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fcd8af585f587741c051f7124b8dee6c73c8629b
Gitweb:     http://git.kernel.org/tip/fcd8af585f587741c051f7124b8dee6c73c8629b
Author:     David Hooper <dave@beermex.com>
AuthorDate: Tue, 2 Oct 2012 15:26:53 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 4 Oct 2012 12:22:32 +0200

x86/reboot: Remove quirk entry for SBC FITPC

Remove the quirk for the SBC FITPC. It seems ot have been
required when the default was kbd reboot, but no longer required
now that the default is acpi reboot. Furthermore, BIOS reboot no
longer works for this board as of 2.6.39 or any of the 3.x
kernels.

Signed-off-by: David Hooper <dave@beermex.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/r/20121002142635.17403.59959.stgit@localhost.localdomain
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/reboot.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 52190a9..4e8ba39 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -358,14 +358,6 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-Z540N"),
 		},
 	},
-	{	/* Handle problems with rebooting on CompuLab SBC-FITPC2 */
-		.callback = set_bios_reboot,
-		.ident = "CompuLab SBC-FITPC2",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "CompuLab"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
-		},
-	},
 	{	/* Handle problems with rebooting on ASUS P4S800 */
 		.callback = set_bios_reboot,
 		.ident = "ASUS P4S800",
