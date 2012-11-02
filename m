Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760571Ab2KBWB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 18:01:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35490 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759636Ab2KBWBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 18:01:55 -0400
Date: Fri, 2 Nov 2012 15:01:37 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-6acf5a8c931da9d26c8dd77d784daaf07fa2bff0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <5093E09002000078000A60E6@nat28.tlf.novell.com>
References: <5093E09002000078000A60E6@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/timers] x86: hpet: Fix masking of MSI interrupts
Git-Commit-ID: 6acf5a8c931da9d26c8dd77d784daaf07fa2bff0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 02 Nov 2012 15:01:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6acf5a8c931da9d26c8dd77d784daaf07fa2bff0
Gitweb:     http://git.kernel.org/tip/6acf5a8c931da9d26c8dd77d784daaf07fa2bff0
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 2 Nov 2012 14:02:40 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 2 Nov 2012 22:53:27 +0100

x86: hpet: Fix masking of MSI interrupts

HPET_TN_FSB is not a proper mask bit; it merely toggles between MSI and
legacy interrupt delivery. The proper mask bit is HPET_TN_ENABLE, so
use both bits when (un)masking the interrupt.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/5093E09002000078000A60E6@nat28.tlf.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/hpet.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 1460a5d..e28670f 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -434,7 +434,7 @@ void hpet_msi_unmask(struct irq_data *data)
 
 	/* unmask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
-	cfg |= HPET_TN_FSB;
+	cfg |= HPET_TN_ENABLE | HPET_TN_FSB;
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
@@ -445,7 +445,7 @@ void hpet_msi_mask(struct irq_data *data)
 
 	/* mask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
-	cfg &= ~HPET_TN_FSB;
+	cfg &= ~(HPET_TN_ENABLE | HPET_TN_FSB);
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
