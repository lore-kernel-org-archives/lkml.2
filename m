Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2HTJW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:22:27 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40847 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab2HTJWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:22:25 -0400
Date: Mon, 20 Aug 2012 11:24:21 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, andi@firstfloor.org,
        zheng.z.yan@intel.com
Subject: [PATCH] perf/x86: enable Intel Cedarview Atom suppport
Message-ID: <20120820092421.GA11284@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch enables perf_events support for Intel Cedarview
Atom (model 54) processors. Support includes PEBS and LBR.
Tested on my Atom N2600 netbook.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 7f2739e..0d3d63a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2008,6 +2008,7 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 28: /* Atom */
+	case 54: /* Cedariew */
 		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 520b426..da02e9c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -686,7 +686,8 @@ void intel_pmu_lbr_init_atom(void)
 	 * to have an operational LBR which can freeze
 	 * on PMU interrupt
 	 */
-	if (boot_cpu_data.x86_mask < 10) {
+	if (boot_cpu_data.x86_model == 28
+	    && boot_cpu_data.x86_mask < 10) {
 		pr_cont("LBR disabled due to erratum");
 		return;
 	}
