Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab1DDF2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 01:28:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49084 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752143Ab1DDF2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 01:28:00 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Len Brown <len.brown@intel.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] cpuidle: Fix build on ARM and SH
Date: Mon,  4 Apr 2011 06:27:59 +0100
Message-Id: <1301894879-21001-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5f8cf82 (cpuidle: stop using pm_idle) converted arches to use
cpuidle_idle_call() but contained typos on ARM and SH transposing the
function name into cpuidle_call_idle().

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 arch/arm/kernel/process.c |    2 +-
 arch/sh/kernel/idle.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index dc9d685..f47660e 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -197,7 +197,7 @@ void cpu_idle(void)
 				cpu_relax();
 			} else {
 				stop_critical_timings();
-				if (cpuidle_call_idle())
+				if (cpuidle_idle_call())
 					pm_idle();
 				start_critical_timings();
 				/*
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 9c7099e..1db1968 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -101,7 +101,7 @@ void cpu_idle(void)
 			local_irq_disable();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
-			if (cpuidle_call_idle())
+			if (cpuidle_idle_call())
 				pm_idle();
 			/*
 			 * Sanity check to ensure that pm_idle() returns
-- 
1.7.4.1

