Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1BORGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:06:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44102 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab1BORGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:06:19 -0500
Date: Tue, 15 Feb 2011 18:06:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fix
Message-ID: <20110215170608.GA4354@elte.hu>
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

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Kees Cook (1):
      timer debug: Hide kernel addresses via %pK in /proc/timer_list


 kernel/time/timer_list.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 32a19f9..3258455 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -41,7 +41,7 @@ static void print_name_offset(struct seq_file *m, void *sym)
 	char symname[KSYM_NAME_LEN];
 
 	if (lookup_symbol_name((unsigned long)sym, symname) < 0)
-		SEQ_printf(m, "<%p>", sym);
+		SEQ_printf(m, "<%pK>", sym);
 	else
 		SEQ_printf(m, "%s", symname);
 }
@@ -112,7 +112,7 @@ next_one:
 static void
 print_base(struct seq_file *m, struct hrtimer_clock_base *base, u64 now)
 {
-	SEQ_printf(m, "  .base:       %p\n", base);
+	SEQ_printf(m, "  .base:       %pK\n", base);
 	SEQ_printf(m, "  .index:      %d\n",
 			base->index);
 	SEQ_printf(m, "  .resolution: %Lu nsecs\n",
