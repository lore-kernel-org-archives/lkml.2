Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab1AXKQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 05:16:09 -0500
Received: from mail.bugwerft.de ([212.112.241.193]:49490 "EHLO
	mail.bugwerft.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1AXKQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 05:16:08 -0500
From: Sven Neumann <s.neumann@raumfeld.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>, Daniel Mack <daniel@caiaq.de>,
        Sven Neumann <s.neumann@raumfeld.com>
Subject: [PATCH] ARM: pxa: fix suspend on PXA3XX
Date: Mon, 24 Jan 2011 11:15:52 +0100
Message-Id: <1295864152-773-1-git-send-email-s.neumann@raumfeld.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110124095138.GC16202@n2100.arm.linux.org.uk>
References: <20110124095138.GC16202@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resurrect the save and restore functions in pxa3xx_cpu_pm_fns
so that pxa_pm_enter() won't crash. This fixes a regression
introduced by commit aae8224d.

Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
---
 arch/arm/mach-pxa/pxa3xx.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/pxa3xx.c b/arch/arm/mach-pxa/pxa3xx.c
index fed372e..9320a12 100644
--- a/arch/arm/mach-pxa/pxa3xx.c
+++ b/arch/arm/mach-pxa/pxa3xx.c
@@ -205,7 +205,17 @@ static int pxa3xx_cpu_pm_valid(suspend_state_t state)
 	return state == PM_SUSPEND_MEM || state == PM_SUSPEND_STANDBY;
 }
 
+static void pxa3xx_cpu_pm_save(unsigned long *sleep_save)
+{
+}
+
+static void pxa3xx_cpu_pm_restore(unsigned long *sleep_save)
+{
+}
+
 static struct pxa_cpu_pm_fns pxa3xx_cpu_pm_fns = {
+        .save           = pxa3xx_cpu_pm_save,
+        .restore        = pxa3xx_cpu_pm_restore,
 	.valid		= pxa3xx_cpu_pm_valid,
 	.enter		= pxa3xx_cpu_pm_enter,
 };
-- 
1.7.1

