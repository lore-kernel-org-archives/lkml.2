Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab2JKX2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 19:28:11 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37580 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab2JKX2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 19:28:02 -0400
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH v6 4/6] ftrace: Change unsigned long type of ring_buffer_oldest_event_ts() to u64
Date: Thu, 11 Oct 2012 16:27:54 -0700
Message-Id: <1349998076-15495-5-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1349998076-15495-1-git-send-email-dhsharp@google.com>
References: <1349998076-15495-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>

ring_buffer_oldest_event_ts() should return a value of u64 type, because
ring_buffer_per_cpu->buffer_page->buffer_data_page->time_stamp is u64 type.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: David Sharp <dhsharp@google.com>
---
 include/linux/ring_buffer.h |    2 +-
 kernel/trace/ring_buffer.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 6c8835f..c68a09a 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -159,7 +159,7 @@ int ring_buffer_record_is_on(struct ring_buffer *buffer);
 void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu);
 void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu);
 
-unsigned long ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int cpu);
+u64 ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_bytes_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_entries(struct ring_buffer *buffer);
 unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 49491fa..db3806e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2925,12 +2925,12 @@ rb_num_of_entries(struct ring_buffer_per_cpu *cpu_buffer)
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to read from.
  */
-unsigned long ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int cpu)
+u64 ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int cpu)
 {
 	unsigned long flags;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_page *bpage;
-	unsigned long ret;
+	u64 ret;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 0;
-- 
1.7.7.3

