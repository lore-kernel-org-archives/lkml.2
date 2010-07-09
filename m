Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab0GII1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 04:27:52 -0400
Received: from ozlabs.org ([203.10.76.45]:46914 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab0GII1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 04:27:50 -0400
Date: Fri, 9 Jul 2010 17:31:27 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 08/11] perf: Per PMU disable
Message-ID: <20100709073127.GQ7771@brick.ozlabs.ibm.com>
References: <20100624142804.431553874@chello.nl>
 <20100624143406.936055007@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624143406.936055007@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 04:28:12PM +0200, Peter Zijlstra wrote:

> Changes perf_disable() into perf_pmu_disable().

Needs this rolled in to compile on powerpc.

Paul.

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 8890456..9046aea 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -517,7 +517,7 @@ static void write_mmcr0(struct cpu_hw_events *cpuhw, unsigned long mmcr0)
  * Disable all events to prevent PMU interrupts and to allow
  * events to be added or removed.
  */
-static void powerpc_pmu_pmu_disable(struct pmu *pmu)
+static void power_pmu_pmu_disable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw;
 	unsigned long flags;
@@ -565,7 +565,7 @@ static void powerpc_pmu_pmu_disable(struct pmu *pmu)
  * If we were previously disabled and events were added, then
  * put the new config on the PMU.
  */
-static void powerpc_pmu_pmu_enable(struct pmu *pmu)
+static void power_pmu_pmu_enable(struct pmu *pmu)
 {
 	struct perf_event *event;
 	struct cpu_hw_events *cpuhw;
@@ -1130,7 +1130,7 @@ static int power_pmu_event_init(struct perf_event *event)
 struct pmu power_pmu = {
 	.pmu_enable	= power_pmu_pmu_enable,
 	.pmu_disable	= power_pmu_pmu_disable,
-	.event_init	= pmwer_pmu_event_init,
+	.event_init	= power_pmu_event_init,
 	.enable		= power_pmu_enable,
 	.disable	= power_pmu_disable,
 	.read		= power_pmu_read,
