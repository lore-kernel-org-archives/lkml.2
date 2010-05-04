Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab0EDRxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:53:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54407 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757089Ab0EDRxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:53:09 -0400
Date: Tue, 4 May 2010 19:52:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fix
Message-ID: <20100504175235.GA31707@elte.hu>
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
Tejun Heo (1):
      perf: Fix resource leak in failure path of perf_event_open()


 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2f3fbf8..3d1552d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4897,7 +4897,7 @@ err_fput_free_put_context:
 
 err_free_put_context:
 	if (err < 0)
-		kfree(event);
+		free_event(event);
 
 err_put_context:
 	if (err < 0)
