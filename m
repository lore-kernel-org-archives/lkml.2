Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab1BQPFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:05:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:60699 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab1BQPF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:05:26 -0500
Date: Thu, 17 Feb 2011 15:04:56 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        fbuihuu@gmail.com, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        masami.hiramatsu.pt@hitachi.com, a.p.zijlstra@chello.nl,
        fbuihuu@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110210090816.1809.43426.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110210090816.1809.43426.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Show filename which contains target function
Message-ID: <tip-8737ebdea02315eaffaebb3b73d55f2f726a4fe0@git.kernel.org>
Git-Commit-ID: 8737ebdea02315eaffaebb3b73d55f2f726a4fe0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Feb 2011 15:04:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8737ebdea02315eaffaebb3b73d55f2f726a4fe0
Gitweb:     http://git.kernel.org/tip/8737ebdea02315eaffaebb3b73d55f2f726a4fe0
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 10 Feb 2011 18:08:16 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Feb 2011 17:04:09 -0200

perf probe: Show filename which contains target function

Show filename which contains a target function with the function name on
"--lines" mode, because perf-probe just shows the first function even if
there are many same-name functions.

Originally adopted by Franck Bui-Huu's patch which shows file name
instead of function name. I've just modified it to show both of function
name and file name, because of completeness of output.

 E.g.)
 $ perf probe -L t_show
 <t_show@/home/mhiramat/ksrc/linux-2.6-tip/kernel/trace/ftrace.c:0>
      0  static int t_show(struct seq_file *m, void *v)
      1  {
      2         struct ftrace_iterator *iter = m->private;
 ...

 $ perf probe -L t_show@trace/trace.c
 <t_show@/home/mhiramat/ksrc/linux-2.6-tip/kernel/trace/trace.c:0>
      0  static int t_show(struct seq_file *m, void *v)
      1  {
                struct tracer *t = v;
 ...

Original-patch-by: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110210090816.1809.43426.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index cbd7650..0e3ea13 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -409,7 +409,7 @@ int show_line_range(struct line_range *lr, const char *module)
 	setup_pager();
 
 	if (lr->function)
-		fprintf(stdout, "<%s:%d>\n", lr->function,
+		fprintf(stdout, "<%s@%s:%d>\n", lr->function, lr->path,
 			lr->start - lr->offset);
 	else
 		fprintf(stdout, "<%s:%d>\n", lr->path, lr->start);
