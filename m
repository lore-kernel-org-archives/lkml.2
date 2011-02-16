Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1BPW4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:56:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44583 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab1BPWzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:55:00 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Franck Bui-Huu <fbuihuu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/6] perf probe: Show filename which contains target function
Date: Wed, 16 Feb 2011 20:54:47 -0200
Message-Id: <1297896887-9983-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297896887-9983-1-git-send-email-acme@infradead.org>
References: <1297896887-9983-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

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
-- 
1.6.2.5

