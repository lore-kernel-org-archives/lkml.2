Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab2LCOw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:52:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43682 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755299Ab2LCOgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:09 -0500
Message-Id: <20121203143158.238542881@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:33:02 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [ 76/89] Dove: Fix irq_to_pmu()
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King - ARM Linux <linux@arm.linux.org.uk>

commit d356cf5a74afa32b40decca3c9dd88bc3cd63eb5 upstream.

PMU interrupts start at IRQ_DOVE_PMU_START, not IRQ_DOVE_PMU_START + 1.
Fix the condition.  (It may have been less likely to occur had the code
been written "if (irq >= IRQ_DOVE_PMU_START" which imho is the easier
to understand notation, and matches the normal way of thinking about
these things.)

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-dove/include/mach/pm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-dove/include/mach/pm.h b/arch/arm/mach-dove/include/mach/pm.h
index 7bcd0df..b47f750 100644
--- a/arch/arm/mach-dove/include/mach/pm.h
+++ b/arch/arm/mach-dove/include/mach/pm.h
@@ -63,7 +63,7 @@ static inline int pmu_to_irq(int pin)
 
 static inline int irq_to_pmu(int irq)
 {
-	if (IRQ_DOVE_PMU_START < irq && irq < NR_IRQS)
+	if (IRQ_DOVE_PMU_START <= irq && irq < NR_IRQS)
 		return irq - IRQ_DOVE_PMU_START;
 
 	return -EINVAL;


