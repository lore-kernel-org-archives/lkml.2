Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab2BSLPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 06:15:21 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:30048 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab2BSLPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 06:15:20 -0500
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: avagin@openvz.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] trace: don't print an extra separator of flags
Date: Sun, 19 Feb 2012 14:16:07 +0300
Message-Id: <1329650167-480655-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Vagin <avagin@openvz.org>

It occurs if __print_flags is used more than once

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 kernel/trace/trace_output.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 0d6ff35..3efd718 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -300,7 +300,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 	unsigned long mask;
 	const char *str;
 	const char *ret = p->buffer + p->len;
-	int i;
+	int i, first = 1;
 
 	for (i = 0;  flag_array[i].name && flags; i++) {
 
@@ -310,8 +310,10 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 
 		str = flag_array[i].name;
 		flags &= ~mask;
-		if (p->len && delim)
+		if (!first && delim)
 			trace_seq_puts(p, delim);
+		else
+			first = 0;
 		trace_seq_puts(p, str);
 	}
 
-- 
1.7.1

