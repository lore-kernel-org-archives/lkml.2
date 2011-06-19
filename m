Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab1FSIpG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 04:45:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43011 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab1FSIpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 04:45:04 -0400
Date: Sun, 19 Jun 2011 10:44:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110619084448.GA21821@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-urgent-for-linus

 Thanks,

	Ingo

------------------>
Mathias Krause (1):
      tools/perf: Fix static build of perf tool

Steven Rostedt (1):
      tracing: Fix regression in printk_formats file


 kernel/trace/trace_printk.c |    5 +----
 tools/perf/Makefile         |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index dff763b..1f06468 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -240,13 +240,10 @@ static const char **find_next(void *v, loff_t *pos)
 	const char **fmt = v;
 	int start_index;
 
-	if (!fmt)
-		fmt = __start___trace_bprintk_fmt + *pos;
-
 	start_index = __stop___trace_bprintk_fmt - __start___trace_bprintk_fmt;
 
 	if (*pos < start_index)
-		return fmt;
+		return __start___trace_bprintk_fmt + *pos;
 
 	return find_next_mod_format(start_index, v, fmt, pos);
 }
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 032ba63..940257b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -633,7 +633,7 @@ prefix_SQ = $(subst ','\'',$(prefix))
 
 SHELL_PATH_SQ = $(subst ','\'',$(SHELL_PATH))
 
-LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive $(EXTLIBS)
+LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
 
 ALL_CFLAGS += $(BASIC_CFLAGS)
 ALL_CFLAGS += $(ARCH_CFLAGS)
