Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2FSPt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:49:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab2FSPtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:49:24 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 01/23] tracing/filter: Add missing initialization
Date: Tue, 19 Jun 2012 17:47:52 +0200
Message-Id: <1340120894-9465-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing initialization for ret variable. Its initialization
is based on the re_cnt variable, which is being set deep down
in the ftrace_function_filter_re function.

I'm not sure compilers would be smart enough to see this in near
future, so killing the warning this way.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 431dba8..c154797 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -2002,7 +2002,7 @@ static int ftrace_function_set_regexp(struct ftrace_ops *ops, int filter,
 static int __ftrace_function_set_filter(int filter, char *buf, int len,
 					struct function_filter_data *data)
 {
-	int i, re_cnt, ret;
+	int i, re_cnt, ret = -EINVAL;
 	int *reset;
 	char **re;
 
-- 
1.7.7.6

