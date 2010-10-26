Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab0JZIhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 04:37:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:44634 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab0JZIhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 04:37:10 -0400
Date: Tue, 26 Oct 2010 08:36:52 GMT
From: tip-bot for Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        lethal@linux-sh.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, lethal@linux-sh.org
In-Reply-To: <20101026071912.GD4733@linux-sh.org>
References: <20101026071912.GD4733@linux-sh.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Add single IRQ reservation helper
Message-ID: <tip-639bd12f778d55a2632fde5af7d0719abc1871b9@git.kernel.org>
Git-Commit-ID: 639bd12f778d55a2632fde5af7d0719abc1871b9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 08:36:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  639bd12f778d55a2632fde5af7d0719abc1871b9
Gitweb:     http://git.kernel.org/tip/639bd12f778d55a2632fde5af7d0719abc1871b9
Author:     Paul Mundt <lethal@linux-sh.org>
AuthorDate: Tue, 26 Oct 2010 16:19:13 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 26 Oct 2010 10:33:27 +0200

genirq: Add single IRQ reservation helper

For cases that wish to reserve a single IRQ at a given place simply
provide a wrapper in to the ranged reservation routine.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
LKML-Reference: <20101026071912.GD4733@linux-sh.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/irq.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index e963911..abde252 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -412,6 +412,11 @@ static inline void irq_free_desc(unsigned int irq)
 	irq_free_descs(irq, 1);
 }
 
+static inline int irq_reserve_irq(unsigned int irq)
+{
+	return irq_reserve_irqs(irq, 1);
+}
+
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
 #endif /* !CONFIG_S390 */
