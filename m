Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab2JJH3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 03:29:20 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:44741 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2JJH3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 03:29:13 -0400
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Subject: [RESEND PATCH v1 1/3] cpuidle: (POWER) Fix target residency
 initialisation in pseries cpuidle
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org
Date: Wed, 10 Oct 2012 12:59:08 +0530
Message-ID: <20121010072906.29317.32144.stgit@deepthi.in.ibm.com>
In-Reply-To: <20121010072859.29317.71472.stgit@deepthi.in.ibm.com>
References: <20121010072859.29317.71472.stgit@deepthi.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12101007-3864-0000-0000-000004FF7CCE
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
 

