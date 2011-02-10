Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab1BJJP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:15:29 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58040 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab1BJJP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:15:26 -0500
X-AuditID: b753bd60-a46baba000004916-e2-4d53acacde02
X-AuditID: b753bd60-a46baba000004916-e2-4d53acacde02
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -perf/perf/core 2/2] perf probe: Show filename which contains
	target function
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Thu, 10 Feb 2011 18:08:16 +0900
Message-ID: <20110210090816.1809.43426.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110210090754.1809.36678.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110210090754.1809.36678.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show filename which contains a target function with the
function name on "--lines" mode, because perf-probe just
shows the first function even if there are many same-name
functions.

Originally adopted by Franck Bui-Huu's patch which shows
file name instead of function name. I've just modified it
to show both of function name and file name, because of
completeness of output.

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

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Original-patch-by: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
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

