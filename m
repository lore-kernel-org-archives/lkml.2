Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab1C3NZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:25:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35975 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab1C3NZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:25:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=eqG3lVlJqOdCWs/Xo/IhyUTJ0MzQ+7FQB300l8jBNjvfEkzblWY/2TlB1VDZ0BxysK
         7tor9PHqfnJ0Is41I25GJkl1nHxzf3Cdv9VvLVgf3S/Ib6pDFEnSC+ffZUFIiFE7vSMr
         arI38sfiQwZYQXak1Me/0y9jUxUDzdgWKTOGM=
Date: Wed, 30 Mar 2011 15:25:04 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, Thomas Gleixner <tglx@linutronix.de>,
        Lennert Buytenhek <buytenh@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] powerpc: rename get_irq_desc_data and get_irq_desc_chip
Message-ID: <20110330132504.GA31832@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two functions disappeared in commit

    0c6f8a8b917ad361319c8ace3e9f28e69bfdb4c1
    "genirq: Remove compat code"

but they still exist in qe_ic.h.
This patch renames the function to their new names.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
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
-- 
1.7.0.4

