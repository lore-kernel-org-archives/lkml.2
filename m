Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731Ab1FWRiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:38:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:35360 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933708Ab1FWRiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:10 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 200/247] fix per-cpu flag problem in the cpu affinity checkers
Date: Thu, 23 Jun 2011 13:34:28 -0400
Message-Id: <1308850515-15242-141-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9804c9eaeacfe78651052c5ddff31099f60ef78c upstream.

The CHECK_IRQ_PER_CPU is wrong, it should be checking
irq_to_desc(irq)->status not just irq.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/parisc/kernel/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index efbcee5..e13fc3f 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -117,7 +117,7 @@ int cpu_check_affinity(unsigned int irq, const struct cpumask *dest)
 	int cpu_dest;
 
 	/* timer and ipi have to always be received on all CPUs */
-	if (CHECK_IRQ_PER_CPU(irq)) {
+	if (CHECK_IRQ_PER_CPU(irq_to_desc(irq)->status)) {
 		/* Bad linux design decision.  The mask has already
 		 * been set; we must reset it */
 		cpumask_setall(irq_desc[irq].affinity);
-- 
1.7.4.4

