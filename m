Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab2JKX27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 19:28:59 -0400
Received: from mail-lb0-f202.google.com ([209.85.217.202]:62286 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2JKX2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 19:28:03 -0400
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v6 6/6] tracing: Fix maybe-uninitialized warning in ftrace_function_set_regexp
Date: Thu, 11 Oct 2012 16:27:56 -0700
Message-Id: <1349998076-15495-7-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1349998076-15495-1-git-send-email-dhsharp@google.com>
References: <1349998076-15495-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiler warning:

kernel/trace/trace_events_filter.c: In function 'ftrace_function_set_filter_cb':
kernel/trace/trace_events_filter.c:2074:8: error: 'ret' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Signed-off-by: David Sharp <dhsharp@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 431dba8..ef36953 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -2002,9 +2002,10 @@ static int ftrace_function_set_regexp(struct ftrace_ops *ops, int filter,
 static int __ftrace_function_set_filter(int filter, char *buf, int len,
 					struct function_filter_data *data)
 {
-	int i, re_cnt, ret;
+	int i, re_cnt;
 	int *reset;
 	char **re;
+	int ret = 0;
 
 	reset = filter ? &data->first_filter : &data->first_notrace;
 
-- 
1.7.7.3

