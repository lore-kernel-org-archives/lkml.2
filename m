Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206Ab0JYRdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:33:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60632 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab0JYRdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:33:12 -0400
Date: Mon, 25 Oct 2010 19:32:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
Message-ID: <20101025173250.GA3670@elte.hu>
References: <20101023200216.GA19324@elte.hu>
 <1287881618.16971.657.camel@gandalf.stny.rr.com>
 <20101024112540.GA21267@elte.hu>
 <20101025085927.GA11025@elte.hu>
 <20101025093045.GA21997@elte.hu>
 <20101025114501.GA2000@elte.hu>
 <20101025121059.GA3063@elte.hu>
 <1288009103.15336.58.camel@twins>
 <1288021672.15336.63.camel@twins>
 <20101025172521.GC1636@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025172521.GC1636@elte.hu>
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


another data point is that applying the patch below from Peter seems to stabilize 
things, i've got 130 successful randconfig iterations so far and no crash.

I.e. it's directly jump labels related.

Thanks,

	Ingo

NOT-Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/jump_label.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index b67cb18..4732acd 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -1,10 +1,12 @@
 #ifndef _LINUX_JUMP_LABEL_H
 #define _LINUX_JUMP_LABEL_H
 
+#if 0
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_HAVE_ARCH_JUMP_LABEL)
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
 #endif
+#endif
 
 enum jump_label_type {
 	JUMP_LABEL_ENABLE,
