Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1K0SEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 13:04:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab1K0SEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 13:04:47 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/9] ftrace: Fix shutdown to disable calls properly
Date: Sun, 27 Nov 2011 19:04:28 +0100
Message-Id: <1322417074-5834-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each ftrace_startup call increases the call record's flag,
so we need allways to decrease it when shutting down the
ftrace_ops.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/ftrace.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c6d0293..0ca0c0d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1744,8 +1744,7 @@ static void ftrace_shutdown(struct ftrace_ops *ops, int command)
 	if (ops != &global_ops || !global_start_up)
 		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
 
-	if (!ftrace_start_up)
-		command |= FTRACE_DISABLE_CALLS;
+	command |= FTRACE_DISABLE_CALLS;
 
 	if (saved_ftrace_func != ftrace_trace_function) {
 		saved_ftrace_func = ftrace_trace_function;
-- 
1.7.1

