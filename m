Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424107Ab2LGBGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:06:32 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46480 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423432Ab2LGA71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:59:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [ 02/27] Dove: Fix irq_to_pmu()
Date: Thu,  6 Dec 2012 16:58:46 -0800
Message-Id: <20121207005825.951477994@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005825.232489605@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-dove/include/mach/pm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-dove/include/mach/pm.h
+++ b/arch/arm/mach-dove/include/mach/pm.h
@@ -45,7 +45,7 @@ static inline int pmu_to_irq(int pin)
 
 static inline int irq_to_pmu(int irq)
 {
-	if (IRQ_DOVE_PMU_START < irq && irq < NR_IRQS)
+	if (IRQ_DOVE_PMU_START <= irq && irq < NR_IRQS)
 		return irq - IRQ_DOVE_PMU_START;
 
 	return -EINVAL;


