Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab1HKMFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:05:54 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39408 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab1HKMFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:05:49 -0400
X-AuditID: b753bd60-a1eacba0000019f4-2b-4e43c5995c84
X-AuditID: b753bd60-a1eacba0000019f4-2b-4e43c5995c84
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v3 2/5] perf: change perf_event_header.misc to
 PERF_RECORD_MISC_USER for BTS
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Thu, 11 Aug 2011 21:06:20 +0900
Message-ID: <20110811120620.5900.50427.stgit@linux3>
In-Reply-To: <20110811120555.5900.23642.stgit@linux3>
References: <20110811120555.5900.23642.stgit@linux3>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change perf_event_headder.misc to PERF_RECORD_MISC_USER for
BTS records, because BTS traces both kernel and user spaces
nevertheless perf specifies to trace only kernel or user space.

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 arch/x86/kernel/cpu/perf_event_intel_ds.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 1b1ef3a..323f3f0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -340,6 +340,14 @@ static int intel_pmu_drain_bts_buffer(void)
 	 */
 	perf_prepare_sample(&header, &data, event, &regs);
 
+	/*
+	 * Since BTS can not trace kernel and user space separately, set
+	 * PERF_RECORD_MISC_USER in header.misc to resolve both kernel and
+	 * user DSOs and symbols.
+	 */
+	header.misc &= ~PERF_RECORD_MISC_CPUMODE_MASK;
+	header.misc |= PERF_RECORD_MISC_USER;
+
 	if (perf_output_begin(&handle, event, header.size * (top - at)))
 		return 1;
 

