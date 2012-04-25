Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab2DYN55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:57:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44606 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2DYN5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:57:55 -0400
Date: Wed, 25 Apr 2012 06:57:30 -0700
From: tip-bot for Greg Pearson <greg.pearson@hp.com>
Message-ID: <tip-ea0dcf903e7d76aa5d483d876215fedcfdfe140f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        greg.pearson@hp.com, suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        greg.pearson@hp.com, suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1335313436-32020-1-git-send-email-greg.pearson@hp.com>
References: <1335313436-32020-1-git-send-email-greg.pearson@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/apic:
  Use x2apic physical mode based on FADT setting
Git-Commit-ID: ea0dcf903e7d76aa5d483d876215fedcfdfe140f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Apr 2012 06:57:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea0dcf903e7d76aa5d483d876215fedcfdfe140f
Gitweb:     http://git.kernel.org/tip/ea0dcf903e7d76aa5d483d876215fedcfdfe140f
Author:     Greg Pearson <greg.pearson@hp.com>
AuthorDate: Tue, 24 Apr 2012 18:23:56 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Apr 2012 12:47:08 +0200

x86/apic: Use x2apic physical mode based on FADT setting

Provide systems that do not support x2apic cluster mode
a mechanism to select x2apic physical mode using the
FADT FORCE_APIC_PHYSICAL_DESTINATION_MODE bit.

Changes from v1: (based on Suresh's comments)
 - removed #ifdef CONFIG_ACPI
 - removed #include <linux/acpi.h>

Signed-off-by: Greg Pearson <greg.pearson@hp.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1335313436-32020-1-git-send-email-greg.pearson@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/x2apic_phys.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 8a778db..991e315 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -24,6 +24,12 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (x2apic_phys)
 		return x2apic_enabled();
+	else if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
+		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL) &&
+		x2apic_enabled()) {
+		printk(KERN_DEBUG "System requires x2apic physical mode\n");
+		return 1;
+	}
 	else
 		return 0;
 }
