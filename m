Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab2JDEmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 00:42:40 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:34703 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab2JDEmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 00:42:36 -0400
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Subject: [PATCH v1 1/3] cpuidle: (POWER) Fix target residency initialisation
 in pseries cpuidle
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Cc: benh@kernel.crashing.org
Date: Thu, 04 Oct 2012 10:12:10 +0530
Message-ID: <20121004044207.15921.36114.stgit@deepthi.in.ibm.com>
In-Reply-To: <20121004044154.15921.51256.stgit@deepthi.in.ibm.com>
References: <20121004044154.15921.51256.stgit@deepthi.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12100404-4790-0000-0000-000004E86219
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the redundant target residency initialisation in pseries_cpuidle_driver_init().
This is currently over-writing the residency time updated as part of the static
table, resulting in  all the idle states having the same target
residency of 100us which is incorrect. This may result in the menu governor making
wrong state decisions.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---

 arch/powerpc/platforms/pseries/processor_idle.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
index 455760b..02e425a 100644
--- a/arch/powerpc/platforms/pseries/processor_idle.c
+++ b/arch/powerpc/platforms/pseries/processor_idle.c
@@ -246,10 +246,6 @@ static int pseries_cpuidle_driver_init(void)
 		drv->states[drv->state_count] =	/* structure copy */
 			cpuidle_state_table[idle_state];
 
-		if (cpuidle_state_table == dedicated_states)
-			drv->states[drv->state_count].target_residency =
-				__get_cpu_var(smt_snooze_delay);
-
 		drv->state_count += 1;
 	}
 

