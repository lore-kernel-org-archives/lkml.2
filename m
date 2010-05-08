Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab0EHQLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 12:11:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:57789 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab0EHQLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 12:11:16 -0400
Date: Sat, 8 May 2010 16:10:17 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, peterz@infradead.org, fweisbec@gmail.com,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, gorcunov@openvz.org, peterz@infradead.org,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100508112717.130386882@openvz.org>
References: <20100508112717.130386882@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, perf: P4 PMU -- Get rid of redundant check for array index
Message-ID: <tip-3f51b7119d052827dbb0e40c966acdf2bdc6f47f@git.kernel.org>
Git-Commit-ID: 3f51b7119d052827dbb0e40c966acdf2bdc6f47f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 08 May 2010 16:10:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f51b7119d052827dbb0e40c966acdf2bdc6f47f
Gitweb:     http://git.kernel.org/tip/3f51b7119d052827dbb0e40c966acdf2bdc6f47f
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sat, 8 May 2010 15:25:53 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 May 2010 14:17:53 +0200

x86, perf: P4 PMU -- Get rid of redundant check for array index

The caller already has done such a check.
And it was wrong anyway, it had to be '>=' rather than '>'

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>
LKML-Reference: <20100508112717.130386882@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index ca40180..b8c2d37 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -406,11 +406,6 @@ static u64 p4_pmu_event_map(int hw_event)
 	unsigned int esel;
 	u64 config;
 
-	if (hw_event > ARRAY_SIZE(p4_general_events)) {
-		printk_once(KERN_ERR "P4 PMU: Bad index: %i\n", hw_event);
-		return 0;
-	}
-
 	config = p4_general_events[hw_event];
 	bind = p4_config_get_bind(config);
 	esel = P4_OPCODE_ESEL(bind->opcode);
