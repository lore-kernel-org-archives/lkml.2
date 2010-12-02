Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab0LBFzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 00:55:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:32773 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab0LBFzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 00:55:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,286,1288594800"; 
   d="scan'208";a="863431082"
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1291267223.2405.314.camel@minggr.sh.intel.com>
References: <1291267223.2405.314.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 13:57:46 +0800
Message-ID: <1291269466.2405.322.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 13:20 +0800, Lin Ming wrote:
> Changelogs of v3:
> 
> - Allocate uncore data with kmalloc_node, like AMD NB stuff. (Peter
> Zijlstra)
> 
> - per-task uncore event is not allowed. Simply set pmu::task_ctx_nr =
> perf_invalid_context. (Peter Zijlstra)

<snip>

> +
> +static struct pmu uncore_pmu = {
> +	.event_init	= uncore_pmu_event_init,
> +	.add		= uncore_pmu_add,
> +	.del		= uncore_pmu_del,
> +	.start		= uncore_pmu_start,
> +	.stop		= uncore_pmu_stop,
> +	.read		= uncore_pmu_read,
> +};

Sorry, I send out an old version, need below additional code to disallow
per-task uncore event.

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index d2c10d8..d2a22ba 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -252,6 +252,8 @@ static void uncore_pmu_read(struct perf_event *event)
 }
 
 static struct pmu uncore_pmu = {
+	.task_ctx_nr	= perf_invalid_context, /* per-task uncore event is not allowed */
+
 	.event_init	= uncore_pmu_event_init,
 	.add		= uncore_pmu_add,
 	.del		= uncore_pmu_del,


