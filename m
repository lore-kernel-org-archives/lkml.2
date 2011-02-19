Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab1BSMYf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 07:24:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:42554 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827Ab1BSMYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 07:24:31 -0500
Date: Sat, 19 Feb 2011 12:24:15 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20110202212551.918484270@linutronix.de>
References: <20110202212551.918484270@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Do not fiddle with IRQ_MASKED in handle_edge_irq()
Message-ID: <tip-d78f8dd36b90626106ce19cb2e6828b0dc39447e@git.kernel.org>
Git-Commit-ID: d78f8dd36b90626106ce19cb2e6828b0dc39447e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Feb 2011 12:24:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d78f8dd36b90626106ce19cb2e6828b0dc39447e
Gitweb:     http://git.kernel.org/tip/d78f8dd36b90626106ce19cb2e6828b0dc39447e
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 2 Feb 2011 21:41:17 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 19 Feb 2011 12:58:11 +0100

genirq: Do not fiddle with IRQ_MASKED in handle_edge_irq()

IRQ_MASKED is set in mask_ack_irq() anyway. Remove it from
handle_edge_irq() to allow simpler ab^HHreuse of that function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110202212551.918484270@linutronix.de>
---
 kernel/irq/chip.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 43c62ca..2c30b78 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -611,7 +611,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
 		    !desc->action)) {
 		if (!irq_check_poll(desc)) {
-			desc->status |= (IRQ_PENDING | IRQ_MASKED);
+			desc->status |= IRQ_PENDING;
 			mask_ack_irq(desc);
 			goto out_unlock;
 		}
