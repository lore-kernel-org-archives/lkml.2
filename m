Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab1C3NkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:40:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:46099 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab1C3NkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:40:16 -0400
Date: Wed, 30 Mar 2011 13:39:50 GMT
From: tip-bot for Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        richardcochran@gmail.com, richard.cochran@omicron.at,
        benh@kernel.crashing.org, tglx@linutronix.de, buytenh@secretlab.ca
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, richardcochran@gmail.com, tglx@linutronix.de,
        buytenh@secretlab.ca, richard.cochran@omicron.at
In-Reply-To: <20110330132504.GA31832@riccoc20.at.omicron.at>
References: <20110330132504.GA31832@riccoc20.at.omicron.at>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] powerpc: qe_ic: Rename get_irq_desc_data and get_irq_desc_chip
Message-ID: <tip-eead4d5c63ff9200a46d71345227f2b2f3eb86c0@git.kernel.org>
Git-Commit-ID: eead4d5c63ff9200a46d71345227f2b2f3eb86c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 30 Mar 2011 13:39:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eead4d5c63ff9200a46d71345227f2b2f3eb86c0
Gitweb:     http://git.kernel.org/tip/eead4d5c63ff9200a46d71345227f2b2f3eb86c0
Author:     Richard Cochran <richardcochran@gmail.com>
AuthorDate: Wed, 30 Mar 2011 15:25:04 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 30 Mar 2011 15:38:02 +0200

powerpc: qe_ic: Rename get_irq_desc_data and get_irq_desc_chip

These two functions disappeared in commit

    0c6f8a8b917ad361319c8ace3e9f28e69bfdb4c1
    "genirq: Remove compat code"

but they still exist in qe_ic.h.
This patch renames the function to their new names.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Lennert Buytenhek <buytenh@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
LKML-Reference: <20110330132504.GA31832@riccoc20.at.omicron.at>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/powerpc/include/asm/qe_ic.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/qe_ic.h b/arch/powerpc/include/asm/qe_ic.h
index 9e2cb20..f706164 100644
--- a/arch/powerpc/include/asm/qe_ic.h
+++ b/arch/powerpc/include/asm/qe_ic.h
@@ -81,7 +81,7 @@ int qe_ic_set_high_priority(unsigned int virq, unsigned int priority, int high);
 static inline void qe_ic_cascade_low_ipic(unsigned int irq,
 					  struct irq_desc *desc)
 {
-	struct qe_ic *qe_ic = get_irq_desc_data(desc);
+	struct qe_ic *qe_ic = irq_desc_get_handler_data(desc);
 	unsigned int cascade_irq = qe_ic_get_low_irq(qe_ic);
 
 	if (cascade_irq != NO_IRQ)
@@ -91,7 +91,7 @@ static inline void qe_ic_cascade_low_ipic(unsigned int irq,
 static inline void qe_ic_cascade_high_ipic(unsigned int irq,
 					   struct irq_desc *desc)
 {
-	struct qe_ic *qe_ic = get_irq_desc_data(desc);
+	struct qe_ic *qe_ic = irq_desc_get_handler_data(desc);
 	unsigned int cascade_irq = qe_ic_get_high_irq(qe_ic);
 
 	if (cascade_irq != NO_IRQ)
@@ -101,9 +101,9 @@ static inline void qe_ic_cascade_high_ipic(unsigned int irq,
 static inline void qe_ic_cascade_low_mpic(unsigned int irq,
 					  struct irq_desc *desc)
 {
-	struct qe_ic *qe_ic = get_irq_desc_data(desc);
+	struct qe_ic *qe_ic = irq_desc_get_handler_data(desc);
 	unsigned int cascade_irq = qe_ic_get_low_irq(qe_ic);
-	struct irq_chip *chip = get_irq_desc_chip(desc);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
 
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
@@ -114,9 +114,9 @@ static inline void qe_ic_cascade_low_mpic(unsigned int irq,
 static inline void qe_ic_cascade_high_mpic(unsigned int irq,
 					   struct irq_desc *desc)
 {
-	struct qe_ic *qe_ic = get_irq_desc_data(desc);
+	struct qe_ic *qe_ic = irq_desc_get_handler_data(desc);
 	unsigned int cascade_irq = qe_ic_get_high_irq(qe_ic);
-	struct irq_chip *chip = get_irq_desc_chip(desc);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
 
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
@@ -127,9 +127,9 @@ static inline void qe_ic_cascade_high_mpic(unsigned int irq,
 static inline void qe_ic_cascade_muxed_mpic(unsigned int irq,
 					    struct irq_desc *desc)
 {
-	struct qe_ic *qe_ic = get_irq_desc_data(desc);
+	struct qe_ic *qe_ic = irq_desc_get_handler_data(desc);
 	unsigned int cascade_irq;
-	struct irq_chip *chip = get_irq_desc_chip(desc);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
 
 	cascade_irq = qe_ic_get_high_irq(qe_ic);
 	if (cascade_irq == NO_IRQ)
