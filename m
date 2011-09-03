Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab1ICOjq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 10:39:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58546 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab1ICOjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 10:39:45 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <ccross@android.com>, <rjw@sisk.pl>, <khilman@ti.com>
Subject: [PATCH v2 5/5] ARM: gic: Allow gic arch extensions to provide irqchip flags
Date: Sat, 3 Sep 2011 20:09:15 +0530
Message-ID: <1315060755-4613-6-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>
References: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Tegra can benefit from the IRQCHIP_MASK_ON_SUSPEND flag, allow it
to be passed to the gic irq chip.

Signed-off-by: Colin Cross <ccross@android.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/common/gic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 66c7c48..734db99 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -544,6 +544,7 @@ void __init gic_init(unsigned int gic_nr, unsigned int irq_start,
 	if (gic_nr == 0)
 		gic_cpu_base_addr = cpu_base;
 
+	gic_chip.flags |= gic_arch_extn.flags;
 	gic_dist_init(gic, irq_start);
 	gic_cpu_init(gic);
 	gic_pm_init(gic);
-- 
1.7.4.1

