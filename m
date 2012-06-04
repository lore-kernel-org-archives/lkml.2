Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab2FDF1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:27:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:22767 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756415Ab2FDF1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:27:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="174355151"
Date: Mon, 4 Jun 2012 13:23:34 +0800
From: Feng Tang <feng.tang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <rui.zhang@intel.com>, <fazerxlo@o2.pl>, <x86@kernel.org>
Subject: [PATCH 2/3] ACPI: Remove one board specific WARN when ignoring
 timer overriding
Message-ID: <20120604132334.56d619ea@feng-i7>
In-Reply-To: <4FC8F36C.8080409@kernel.org>
References: <1338259418-6167-1-git-send-email-feng.tang@intel.com>
	<4FC8F36C.8080409@kernel.org>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 54e631547eb5150417370fc04a89d7eac6d627e6 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Mon, 4 Jun 2012 11:02:24 +0800
Subject: [PATCH 2/3] ACPI: Remove one board specific WARN when ignoring timer
 overriding

Current WARN msg is only for the ati_ixp4x0 board, while this function
is used by mulitple platforms. So this one board specific warning
is not appropriate any more.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/kernel/acpi/boot.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

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
1.7.9
