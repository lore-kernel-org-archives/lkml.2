Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553Ab2EJRTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:19:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55888 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491Ab2EJRR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:17:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/16] perf top: Set target.system_wide
Date: Thu, 10 May 2012 14:17:31 -0300
Message-Id: <1336670265-20401-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1336670265-20401-1-git-send-email-acme@infradead.org>
References: <1336670265-20401-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Check if neither of --pid, --tid or --uid was specified and if so, set
system_wide appropriately.

Namhyung's patch would make using any of the above target specifiers
emit a warning in perf_target__validate, since it would see
target.system_wide set and one of the others as well.

So set system_wide after validation.

Suggested-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6e4zrji1uw0rinfyoitl0wi4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2a0ec09..e40f86e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1258,6 +1258,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (top.target.uid_str != NULL && top.target.uid == UINT_MAX - 1)
 		goto out_delete_evlist;
 
+	if (top.target.tid == 0 && top.target.pid == 0 &&
+	    top.target.uid_str == NULL)
+		top.target.system_wide = true;
+
 	if (perf_evlist__create_maps(top.evlist, &top.target) < 0)
 		usage_with_options(top_usage, options);
 
-- 
1.7.9.2.358.g22243

