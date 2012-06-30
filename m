Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab2F3FOl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 01:14:41 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64540 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2F3FOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 01:14:39 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 4/8] ACPI: Remove one board specific WARN when ignoring timer overriding
Date: Sat, 30 Jun 2012 01:07:31 -0400
Message-Id: <7f68b4c2e158019c2ec494b5cfbd9c83b4e5b253.1341032550.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.11.1.104.ge7b44f1
In-Reply-To: <1341032855-27139-1-git-send-email-lenb@kernel.org>
References: <1341032855-27139-1-git-send-email-lenb@kernel.org>
In-Reply-To: <9f132652d94c96476b0b0a8caf0c10e96ab10fa8.1341032550.git.len.brown@intel.com>
References: <9f132652d94c96476b0b0a8caf0c10e96ab10fa8.1341032550.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Current WARN msg is only for the ati_ixp4x0 board, while this function
is used by mulitple platforms. So this one board specific warning
is not appropriate any more.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/acpi/boot.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index e7c698e..3a6afba 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1340,12 +1340,7 @@ static int __init dmi_disable_acpi(const struct dmi_system_id *d)
  */
 static int __init dmi_ignore_irq0_timer_override(const struct dmi_system_id *d)
 {
-	/*
-	 * The ati_ixp4x0_rev() early PCI quirk should have set
-	 * the acpi_skip_timer_override flag already:
-	 */
 	if (!acpi_skip_timer_override) {
-		WARN(1, KERN_ERR "ati_ixp4x0 quirk not complete.\n");
 		pr_notice("%s detected: Ignoring BIOS IRQ0 override\n",
 			d->ident);
 		acpi_skip_timer_override = 1;
-- 
1.7.11.1.104.ge7b44f1

