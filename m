Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab2LMOJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:09:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44669 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755Ab2LMOJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:09:41 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 144/241] Dove: Fix irq_to_pmu()
Date: Thu, 13 Dec 2012 11:58:29 -0200
Message-Id: <1355407206-17100-145-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/mach-dove/include/mach/pm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-dove/include/mach/pm.h b/arch/arm/mach-dove/include/mach/pm.h
index 3ad9f94..11799c3 100644
--- a/arch/arm/mach-dove/include/mach/pm.h
+++ b/arch/arm/mach-dove/include/mach/pm.h
@@ -45,7 +45,7 @@ static inline int pmu_to_irq(int pin)
 
 static inline int irq_to_pmu(int irq)
 {
-	if (IRQ_DOVE_PMU_START < irq && irq < NR_IRQS)
+	if (IRQ_DOVE_PMU_START <= irq && irq < NR_IRQS)
 		return irq - IRQ_DOVE_PMU_START;
 
 	return -EINVAL;
-- 
1.7.9.5

