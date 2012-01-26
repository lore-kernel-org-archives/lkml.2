Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2AZVjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:39:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40347 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab2AZVjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:39:49 -0500
Date: Thu, 26 Jan 2012 13:39:33 -0800
From: tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com>
Message-ID: <tip-kzvj4xp9tmicuoqoh2w05iay@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dirk.brandewie@gmail.com, tglx@linutronix.de,
        jacob.jun.pan@linux.intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dirk.brandewie@gmail.com, tglx@linutronix.de,
        jacob.jun.pan@linux.intel.com, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/ioapic:
  Use legacy_pic to set correct gsi-irq mapping
Git-Commit-ID: b3eea29c189a0e3e2ac921e85fabfa4989ee58d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 13:39:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3eea29c189a0e3e2ac921e85fabfa4989ee58d7
Gitweb:     http://git.kernel.org/tip/b3eea29c189a0e3e2ac921e85fabfa4989ee58d7
Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
AuthorDate: Thu, 26 Jan 2012 17:32:04 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 21:23:50 +0100

x86/ioapic: Use legacy_pic to set correct gsi-irq mapping

Using compile time NR_LEGACY_IRQS causes the wrong gsi-irq
mapping on non-PC platforms, such as Moorestown. This patch uses
legacy_pic abstraction to set the correct number of legacy
interrupts at runtime. For Moorestown, nr_legacy_irqs = 0. We
have 1:1 mapping for gsi-irq even within the legacy irq range.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Link: http://lkml.kernel.org/n/tip-kzvj4xp9tmicuoqoh2w05iay@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index fb07275..9e75366 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1010,7 +1010,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 	} else {
 		u32 gsi = gsi_cfg->gsi_base + pin;
 
-		if (gsi >= NR_IRQS_LEGACY)
+		if (gsi >= legacy_pic->nr_legacy_irqs)
 			irq = gsi;
 		else
 			irq = gsi_top + gsi;
@@ -3610,7 +3610,7 @@ static void __init probe_nr_irqs_gsi(void)
 {
 	int nr;
 
-	nr = gsi_top + NR_IRQS_LEGACY;
+	nr = gsi_top + legacy_pic->nr_legacy_irqs;
 	if (nr > nr_irqs_gsi)
 		nr_irqs_gsi = nr;
 
