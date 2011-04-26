Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886Ab1DZBzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 21:55:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57422 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab1DZBzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 21:55:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: (resend) [PATCH 2/4] blackfin: don't touch cpu_possible_map and cpu_present_map directly
Cc: kosaki.motohiro@jp.fujitsu.com, uclinux-dist-devel@blackfin.uclinux.org,
        Mike Frysinger <vapier.adi@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110426105518.F35D.A69D9226@jp.fujitsu.com>
References: <20110426105045.F359.A69D9226@jp.fujitsu.com> <20110426105518.F35D.A69D9226@jp.fujitsu.com>
Message-Id: <20110426105724.F367.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 26 Apr 2011 10:55:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We plan to remove cpu_possible_map and cpu_present_map later and we
have proper init_cpu_possible() and init_cpu_present() APIs.

Therefore this patch rewrites platform_init_cpus and platform_prepare_cpus
by their APIs.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
---
 arch/blackfin/mach-bf561/smp.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

I sent this parch to wrong address (device-driver-devel@blackfin.uclinux.org).
thus now I'm resending it.

diff --git a/arch/blackfin/mach-bf561/smp.c b/arch/blackfin/mach-bf561/smp.c
index 630e2c2..2fca469 100644
--- a/arch/blackfin/mach-bf561/smp.c
+++ b/arch/blackfin/mach-bf561/smp.c
@@ -24,17 +24,23 @@ static DEFINE_SPINLOCK(boot_lock);
 
 void __init platform_init_cpus(void)
 {
-	cpu_set(0, cpu_possible_map); /* CoreA */
-	cpu_set(1, cpu_possible_map); /* CoreB */
+	struct cpumask mask;
+
+	cpumask_set_cpu(0, &mask); /* CoreA */
+	cpumask_set_cpu(1, &mask); /* CoreB */
+	init_cpu_possible(&mask);
 }
 
 void __init platform_prepare_cpus(unsigned int max_cpus)
 {
+	struct cpumask mask;
+
 	bfin_relocate_coreb_l1_mem();
 
 	/* Both cores ought to be present on a bf561! */
-	cpu_set(0, cpu_present_map); /* CoreA */
-	cpu_set(1, cpu_present_map); /* CoreB */
+	cpumask_set_cpu(0, &mask); /* CoreA */
+	cpumask_set_cpu(1, &mask); /* CoreB */
+	init_cpu_present(&mask);
 }
 
 int __init setup_profiling_timer(unsigned int multiplier) /* not supported */
-- 
1.7.3.1





