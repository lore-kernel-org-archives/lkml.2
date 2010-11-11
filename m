Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab0KKRfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:35:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59354 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab0KKRfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:35:21 -0500
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH/FIX] perf-events: Put the per cpu state for intel_pmu too
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
Date: Thu, 11 Nov 2010 18:35:17 +0100
In-Reply-To: <1289492117-18066-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Thu, 11 Nov 2010 17:15:15 +0100")
Message-ID: <8762w3pxuy.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Small bug fix for the earlier offcore_response patch:
need to put the events for intel_pmu too, not only core_pmu.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a06dae3..9a71ffd 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1031,6 +1031,7 @@ static __initconst const struct x86_pmu intel_pmu = {
 	 */
 	.max_period		= (1ULL << 31) - 1,
 	.get_event_constraints	= intel_get_event_constraints,
+	.put_event_constraints	= intel_put_event_constraints,
 
 	.cpu_starting		= intel_pmu_cpu_starting,
 	.cpu_dying		= intel_pmu_cpu_dying,

-- 
ak@linux.intel.com -- Speaking for myself only.
