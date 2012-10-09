Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab2JICJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 22:09:12 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33861 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab2JICIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 22:08:45 -0400
X-AuditID: b753bd60-900c0ba0000047ca-8a-5073872aac6c
X-AuditID: b753bd60-900c0ba0000047ca-8a-5073872aac6c
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH 1/2] ftrace: Change unsigned long type of
 ring_buffer_oldest_event_ts() to u64
To: Steven Rostedt <rostedt@goodmis.org>, David Sharp <dhsharp@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 09 Oct 2012 11:08:41 +0900
Message-ID: <20121009020841.12110.70256.stgit@localhost.localdomain>
In-Reply-To: <20121009020838.12110.90016.stgit@localhost.localdomain>
References: <20121009020838.12110.90016.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ring_buffer_oldest_event_ts() should return a value of u64 type, because
ring_buffer_per_cpu->buffer_page->buffer_data_page->time_stamp is u64 type.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
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
index b32ed0e..7f4129e 100644
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

