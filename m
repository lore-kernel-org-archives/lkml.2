Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab2AZSMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:12:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44173 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab2AZSMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:12:22 -0500
Date: Thu, 26 Jan 2012 19:11:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120126181156.GA6369@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 46cd6a7f680d14f6f80ede9f04aeb70fa83bd266 perf: Call perf_cgroup_event_time() directly

 Thanks,

	Ingo

------------------>
Namhyung Kim (2):
      perf: Don't call release_callchain_buffers() if allocation fails
      perf: Call perf_cgroup_event_time() directly


 kernel/events/callchain.c |    2 --
 kernel/events/core.c      |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 057e24b..6581a04 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -115,8 +115,6 @@ int get_callchain_buffers(void)
 	}
 
 	err = alloc_callchain_buffers();
-	if (err)
-		release_callchain_buffers();
 exit:
 	mutex_unlock(&callchain_mutex);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a8f4ac0..32b48c8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -815,7 +815,7 @@ static void update_event_times(struct perf_event *event)
 	 * here.
 	 */
 	if (is_cgroup_event(event))
-		run_end = perf_event_time(event);
+		run_end = perf_cgroup_event_time(event);
 	else if (ctx->is_active)
 		run_end = ctx->time;
 	else
