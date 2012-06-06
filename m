Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab2FFP7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:59:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40329 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab2FFP7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:59:50 -0400
Date: Wed, 6 Jun 2012 08:59:33 -0700
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-b6db437ba8322f5cee0bd355ad2ef9f73c413754@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1338884803.28282.153.camel@twins>
References: <1338884803.28282.153.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Enable/Add IvyBridge hardware support
Git-Commit-ID: b6db437ba8322f5cee0bd355ad2ef9f73c413754
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:59:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b6db437ba8322f5cee0bd355ad2ef9f73c413754
Gitweb:     http://git.kernel.org/tip/b6db437ba8322f5cee0bd355ad2ef9f73c413754
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 5 Jun 2012 10:26:43 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 16:59:49 +0200

perf/x86: Enable/Add IvyBridge hardware support

Implement rudimentary IVB perf support. The SDM states its identical
to SNB with exception of the exact event tables, but a quick look
suggests they're similar enough.

Also mark SNB-EP as broken for now.

Requested-and-tested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338884803.28282.153.camel@twins
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 2312c1f..187c294 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1909,8 +1909,9 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 42: /* SandyBridge */
-		x86_add_quirk(intel_sandybridge_quirk);
 	case 45: /* SandyBridge, "Romely-EP" */
+		x86_add_quirk(intel_sandybridge_quirk);
+	case 58: /* IvyBridge */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
