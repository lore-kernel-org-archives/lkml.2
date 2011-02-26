Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab1BZQXM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 11:23:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:40237 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab1BZQXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 11:23:10 -0500
Date: Sat, 26 Feb 2011 16:22:54 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20110223234956.578893460@linutronix.de>
References: <20110223234956.578893460@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Add IRQF_NO_THREAD
Message-ID: <tip-0c4602ff88d6d6ef0ee6d228ee9acaa6448ff6f5@git.kernel.org>
Git-Commit-ID: 0c4602ff88d6d6ef0ee6d228ee9acaa6448ff6f5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 26 Feb 2011 16:22:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c4602ff88d6d6ef0ee6d228ee9acaa6448ff6f5
Gitweb:     http://git.kernel.org/tip/0c4602ff88d6d6ef0ee6d228ee9acaa6448ff6f5
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 23 Feb 2011 23:52:18 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 25 Feb 2011 20:24:22 +0100

genirq: Add IRQF_NO_THREAD

Some low level interrupts cannot be threaded even when we force thread
all interrupt handlers. Add a flag to annotate such interrupts. Add
all timer interrupts to this category by default.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110223234956.578893460@linutronix.de>
---
 include/linux/interrupt.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index e116fef..0fc3eb9 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -58,6 +58,7 @@
  *                irq line disabled until the threaded handler has been run.
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
  * IRQF_FORCE_RESUME - Force enable it on resume even if IRQF_NO_SUSPEND is set
+ * IRQF_NO_THREAD - Interrupt cannot be threaded
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -70,8 +71,9 @@
 #define IRQF_ONESHOT		0x00002000
 #define IRQF_NO_SUSPEND		0x00004000
 #define IRQF_FORCE_RESUME	0x00008000
+#define IRQF_NO_THREAD		0x00010000
 
-#define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
+#define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND | IRQF_NO_THREAD)
 
 /*
  * These values can be returned by request_any_context_irq() and
