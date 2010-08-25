Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab0HYRok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 13:44:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56000 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab0HYRoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 13:44:38 -0400
Date: Wed, 25 Aug 2010 19:44:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100825174411.GA7185@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Anton Blanchard (1):
      tracing/trace_stack: Fix stack trace on ppc64

Lin Ming (1):
      perf, x86, Pentium4: Clear the P4_CCCR_FORCE_OVF flag


 arch/x86/kernel/cpu/perf_event_p4.c |    2 ++
 kernel/trace/trace_stack.c          |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index febb12c..7e578e9 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -497,6 +497,8 @@ static int p4_hw_config(struct perf_event *event)
 		event->hw.config |= event->attr.config &
 			(p4_config_pack_escr(P4_ESCR_MASK_HT) |
 			 p4_config_pack_cccr(P4_CCCR_MASK_HT | P4_CCCR_RESERVED));
+
+		event->hw.config &= ~P4_CCCR_FORCE_OVF;
 	}
 
 	rc = x86_setup_perfctr(event);
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 056468e..a6b7e0e 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -249,7 +249,7 @@ static int trace_lookup_stack(struct seq_file *m, long i)
 {
 	unsigned long addr = stack_dump_trace[i];
 
-	return seq_printf(m, "%pF\n", (void *)addr);
+	return seq_printf(m, "%pS\n", (void *)addr);
 }
 
 static void print_disabled(struct seq_file *m)
