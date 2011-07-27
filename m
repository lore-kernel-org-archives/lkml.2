Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab1G0VtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:49:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:36333 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab1G0Vsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="35258287"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: davej@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [54/99] CPUFREQ: Remove cpufreq_stats sysfs entries on module unload.
Message-Id: <20110727214853.4A6692403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dave Jones <davej@redhat.com>

commit 13f067537f34456443f61c950cd6dc37d1d5f3ee upstream.

cpufreq_stats leaves behind its sysfs entries, which causes a panic
when something stumbled across them.
(Discovered by unloading cpufreq_stats while powertop was loaded).

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/cpufreq/cpufreq_stats.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/cpufreq/cpufreq_stats.c
===================================================================
--- linux-2.6.35.y.orig/drivers/cpufreq/cpufreq_stats.c
+++ linux-2.6.35.y/drivers/cpufreq/cpufreq_stats.c
@@ -388,6 +388,7 @@ static void __exit cpufreq_stats_exit(vo
 	unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
 	for_each_online_cpu(cpu) {
 		cpufreq_stats_free_table(cpu);
+		cpufreq_stats_free_sysfs(cpu);
 	}
 }
 
