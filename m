Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab2KSF3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:29:40 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43853 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab2KSF3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:37 -0500
X-Originating-IP: 217.70.178.145
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 17/58] arch/x86/kernel/cpu/perf_event_intel_uncore.c: Mark internal functions static
Date: Sun, 18 Nov 2012 21:27:56 -0800
Message-Id: <1353302917-13995-18-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of arch/x86/kernel/cpu/perf_event_intel_uncore.c
references the functions nhmex_mbox_alter_er, nhmex_rbox_alter_er,
uncore_alloc_box, or uncore_pmu_event_init; mark these funtions static.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 3cf3d97..ff3ba51 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1239,7 +1239,7 @@ static void nhmex_mbox_put_shared_reg(struct intel_uncore_box *box, int idx)
 	atomic_sub(1 << (idx * 8), &er->ref);
 }
 
-u64 nhmex_mbox_alter_er(struct perf_event *event, int new_idx, bool modify)
+static u64 nhmex_mbox_alter_er(struct perf_event *event, int new_idx, bool modify)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
@@ -1554,7 +1554,7 @@ static struct intel_uncore_type nhmex_uncore_mbox = {
 	.format_group		= &nhmex_uncore_mbox_format_group,
 };
 
-void nhmex_rbox_alter_er(struct intel_uncore_box *box, struct perf_event *event)
+static void nhmex_rbox_alter_er(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
@@ -1934,7 +1934,7 @@ static void uncore_pmu_init_hrtimer(struct intel_uncore_box *box)
 	box->hrtimer.function = uncore_pmu_hrtimer;
 }
 
-struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type, int cpu)
+static struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type, int cpu)
 {
 	struct intel_uncore_box *box;
 	int i, size;
@@ -2285,7 +2285,7 @@ out:
 	return ret;
 }
 
-int uncore_pmu_event_init(struct perf_event *event)
+static int uncore_pmu_event_init(struct perf_event *event)
 {
 	struct intel_uncore_pmu *pmu;
 	struct intel_uncore_box *box;
-- 
1.7.10.4

