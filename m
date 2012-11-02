Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338Ab2KBQCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:02:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58766 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588Ab2KBQCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:02:04 -0400
Message-ID: <5093EE75.9040006@gmail.com>
Date: Sat, 03 Nov 2012 00:01:57 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: rostedt@goodmis.org, fweisbec@gmail.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>, mingo@redhat.com,
        cl@linux-foundation.org, Shan Wei <shanwei88@gmail.com>
Subject: [PATCH v2 7/9] trace: use this_cpu_ptr per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>


Signed-off-by: Shan Wei <davidshan@tencent.com>
---
 kernel/trace/blktrace.c |    2 +-
 kernel/trace/trace.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c0bd030..71259e2 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -147,7 +147,7 @@ void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
 		return;
 
 	local_irq_save(flags);
-	buf = per_cpu_ptr(bt->msg_data, smp_processor_id());
+	buf = this_cpu_ptr(bt->msg_data);
 	va_start(args, fmt);
 	n = vscnprintf(buf, BLK_TN_MAX_MSG, fmt, args);
 	va_end(args);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 31e4f55..81ae35b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1513,7 +1513,7 @@ static char *get_trace_buf(void)
 	if (!percpu_buffer)
 		return NULL;
 
-	buffer = per_cpu_ptr(percpu_buffer, smp_processor_id());
+	buffer = this_cpu_ptr(percpu_buffer);
 
 	return buffer->buffer;
 }
-- 1.7.1

