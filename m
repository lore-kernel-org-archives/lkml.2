Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab2KNHEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:04:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43607 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab2KNHEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:04:06 -0500
Date: Tue, 13 Nov 2012 23:03:52 -0800
From: tip-bot for Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Message-ID: <tip-50ecf2c3afead23a05227ab004e4212eca08c207@git.kernel.org>
Cc: vnagarnaik@google.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com, yoshihiro.yunomae.ez@hitachi.com,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vnagarnaik@google.com, yoshihiro.yunomae.ez@hitachi.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dhsharp@google.com,
        tglx@linutronix.de
In-Reply-To: <1349998076-15495-5-git-send-email-dhsharp@google.com>
References: <1349998076-15495-5-git-send-email-dhsharp@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ring-buffer:
  Change unsigned long type of ring_buffer_oldest_event_ts() to u64
Git-Commit-ID: 50ecf2c3afead23a05227ab004e4212eca08c207
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:03:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50ecf2c3afead23a05227ab004e4212eca08c207
Gitweb:     http://git.kernel.org/tip/50ecf2c3afead23a05227ab004e4212eca08c207
Author:     Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
AuthorDate: Thu, 11 Oct 2012 16:27:54 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 2 Nov 2012 10:21:48 -0400

ring-buffer: Change unsigned long type of ring_buffer_oldest_event_ts() to u64

ring_buffer_oldest_event_ts() should return a value of u64 type, because
ring_buffer_per_cpu->buffer_page->buffer_data_page->time_stamp is u64 type.

Link: http://lkml.kernel.org/r/1349998076-15495-5-git-send-email-dhsharp@google.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: David Sharp <dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |    2 +-
 kernel/trace/ring_buffer.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 2007375..519777e 100644
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
index 23a384b..3c7834c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2932,12 +2932,12 @@ rb_num_of_entries(struct ring_buffer_per_cpu *cpu_buffer)
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
