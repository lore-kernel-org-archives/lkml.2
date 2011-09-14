Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab1INQcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 12:32:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53143 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab1INQcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 12:32:01 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        jamie@jamieiles.com, b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 4/5] ARM: gic: allow irq_start to be 0
Date: Wed, 14 Sep 2011 11:31:39 -0500
Message-Id: <1316017900-19918-5-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

There's really no need to set irq_start per platform for the primary gic.
The SGIs and PPIs are not handled as normal irqs, so how irqs 0-31 are
setup doesn't really matter. So allow irq_start to be set to 0 to match
the linux irq numbering.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/common/gic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 666b278..d1ccc72 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -359,7 +359,7 @@ void __init gic_init(unsigned int gic_nr, unsigned int irq_start,
 	gic = &gic_data[gic_nr];
 	gic->dist_base = dist_base;
 	gic->cpu_base = cpu_base;
-	gic->irq_offset = (irq_start - 1) & ~31;
+	gic->irq_offset = irq_start ? (irq_start - 1) & ~31 : 0;
 
 	if (gic_nr == 0)
 		gic_cpu_base_addr = cpu_base;
-- 
1.7.5.4

