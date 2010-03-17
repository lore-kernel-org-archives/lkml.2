Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0CQJtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:49:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:40596 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab0CQJtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:49:06 -0400
Date: Wed, 17 Mar 2010 09:48:36 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       robert.richter@amd.com, ming.m.lin@intel.com, tglx@linutronix.de,
       gorcunov@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       robert.richter@amd.com, ming.m.lin@intel.com, tglx@linutronix.de,
       gorcunov@gmail.com, mingo@elte.hu
In-Reply-To: <20100316160733.GR1585@erda.amd.com>
References: <20100316160733.GR1585@erda.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Report error code that returned from x86_pmu.hw_config()
Message-ID: <tip-984763cb90d4b5444baa0c3e43feff7926bf1834@git.kernel.org>
Git-Commit-ID: 984763cb90d4b5444baa0c3e43feff7926bf1834
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 09:48:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  984763cb90d4b5444baa0c3e43feff7926bf1834
Gitweb:     http://git.kernel.org/tip/984763cb90d4b5444baa0c3e43feff7926bf1834
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 16 Mar 2010 17:07:33 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Mar 2010 10:43:50 +0100

perf, x86: Report error code that returned from x86_pmu.hw_config()

If x86_pmu.hw_config() fails a fixed error code (-EOPNOTSUPP) is
returned even if a different error was reported. This patch fixes
this.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Lin Ming <ming.m.lin@intel.com>
Cc: acme@redhat.com
Cc: eranian@google.com
Cc: gorcunov@openvz.org
Cc: peterz@infradead.org
Cc: fweisbec@gmail.com
LKML-Reference: <20100316160733.GR1585@erda.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 0d3466c..5dacf63 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -472,8 +472,9 @@ static int __hw_perf_event_init(struct perf_event *event)
 	hwc->last_tag = ~0ULL;
 
 	/* Processor specifics */
-	if (x86_pmu.hw_config(attr, hwc))
-		return -EOPNOTSUPP;
+	err = x86_pmu.hw_config(attr, hwc);
+	if (err)
+		return err;
 
 	if (!hwc->sample_period) {
 		hwc->sample_period = x86_pmu.max_period;
