Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1GRJgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 05:36:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61645 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab1GRJf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 05:35:59 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Wang Shaoyan <wangshaoyan.pt@inc.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: [PATCH] TRACING: Fix a copmile warning
Date: Mon, 18 Jul 2011 17:35:38 +0800
Message-Id: <1310981738-13529-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@inc.com>

It's harmless but annyoing.
  kernel/trace/trace_printk.c: In function ‘module_trace_bprintk_format_notify’:
  kernel/trace/trace_printk.c:52: warning: ‘fmt’ may be used uninitialized in this function

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>

---
 kernel/trace/trace_printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 1f06468..1a5fff8 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -49,7 +49,7 @@ static
 void hold_module_trace_bprintk_format(const char **start, const char **end)
 {
 	const char **iter;
-	char *fmt;
+	char *fmt = NULL;
 
 	mutex_lock(&btrace_mutex);
 	for (iter = start; iter < end; iter++) {
-- 
1.7.4.1

