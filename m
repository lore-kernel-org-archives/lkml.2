Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab2KHUYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:24:45 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43397 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab2KHUYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:24:43 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH] ARM: EXYNOS: use BUG_ON where possible
Date: Thu,  8 Nov 2012 15:23:07 -0500
Message-Id: <1352406191-14303-5-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com>
References: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just use BUG_ON() instead of constructions such as:

	if (...)
		BUG()

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@
- if (e) BUG();
+ BUG_ON(e);
// </smpl>

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/arm/mach-exynos/common.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 4e577f6..6a55a5a 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -465,10 +465,8 @@ static void __init combiner_cascade_irq(unsigned int combiner_nr, unsigned int i
 	else
 		max_nr = EXYNOS4_MAX_COMBINER_NR;
 
-	if (combiner_nr >= max_nr)
-		BUG();
-	if (irq_set_handler_data(irq, &combiner_data[combiner_nr]) != 0)
-		BUG();
+	BUG_ON(combiner_nr >= max_nr);
+	BUG_ON(irq_set_handler_data(irq, &combiner_data[combiner_nr]) != 0);
 	irq_set_chained_handler(irq, combiner_handle_cascade_irq);
 }
 
-- 
1.7.10.4

