Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab2HUPRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:17:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59536 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab2HUPRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:17:20 -0400
Date: Tue, 21 Aug 2012 08:17:07 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-92d8d4a8b0f4c6eba70f6e62b48e38bd005a56e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1340120894-9465-2-git-send-email-jolsa@redhat.com>
References: <1340120894-9465-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/filter: Add missing initialization
Git-Commit-ID: 92d8d4a8b0f4c6eba70f6e62b48e38bd005a56e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:17:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  92d8d4a8b0f4c6eba70f6e62b48e38bd005a56e6
Gitweb:     http://git.kernel.org/tip/92d8d4a8b0f4c6eba70f6e62b48e38bd005a56e6
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 19 Jun 2012 17:47:52 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 7 Aug 2012 09:42:47 -0400

tracing/filter: Add missing initialization

Add missing initialization for ret variable. Its initialization
is based on the re_cnt variable, which is being set deep down
in the ftrace_function_filter_re function.

I'm not sure compilers would be smart enough to see this in near
future, so killing the warning this way.

Link: http://lkml.kernel.org/r/1340120894-9465-2-git-send-email-jolsa@redhat.com

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
 
