Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab2G3OcC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:32:02 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:42763 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754403Ab2G3Ob7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:31:59 -0400
From: Chris Smith <chris.smith@st.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: <tglx@linutronix.de>, <will.deacon@arm.com>,
        <srinidhi.kasagar@stericsson.com>, Chris Smith <chris.smith@st.com>
Subject: [PATCH 1/2] genirq: Provide an accessor for IRQ_PER_CPU flag.
Date: Mon, 30 Jul 2012 15:32:11 +0100
Message-ID: <1343658732-31080-1-git-send-email-chris.smith@st.com>
X-Mailer: git-send-email 1.7.6.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds an accessor function, irq_is_per_cpu(), for the flag IRQ_PER_CPU.

This is useful if you have an IRQ that is per-cpu in some hardware
implementations, and not in others (example: ARM PMU Interrupts), and
you want to handle both cases.

Signed-off-by: Chris Smith <chris.smith@st.com>
---
 include/linux/irqdesc.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index f1e2527..771cb35 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -154,6 +154,14 @@ static inline int irq_balancing_disabled(unsigned int irq)
 	return desc->status_use_accessors & IRQ_NO_BALANCING_MASK;
 }
 
+static inline int irq_is_per_cpu(unsigned int irq)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+	return desc->status_use_accessors & IRQ_PER_CPU;
+}
+
 static inline void
 irq_set_lockdep_class(unsigned int irq, struct lock_class_key *class)
 {
-- 
1.7.6.5

