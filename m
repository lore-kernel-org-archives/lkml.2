Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab2JQGIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:08:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47485 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755997Ab2JQGIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:08:43 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [PATCH 13/23] printk: Remove static from printk_ variables
Date: Tue, 16 Oct 2012 23:06:17 -0700
Message-Id: <366e54fbf5e6459f4c409d16438a1a404f4906ee.1350449852.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350449851.git.joe@perches.com>
References: <cover.1350449851.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow a separation of functions and variables into
multiple files.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/printk.c |   46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 3785ac4..0134b2e 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -208,7 +208,7 @@ struct printk_log {
  * The printk_logbuf_lock protects kmsg buffer, indices, counters. It is also
  * used in interesting ways to provide interlocking in console_unlock();
  */
-static DEFINE_RAW_SPINLOCK(printk_logbuf_lock);
+DEFINE_RAW_SPINLOCK(printk_logbuf_lock);
 
 #ifdef CONFIG_PRINTK
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
@@ -218,12 +218,12 @@ static enum printk_log_flags syslog_prev;
 static size_t syslog_partial;
 
 /* index and sequence number of the first record stored in the buffer */
-static u64 printk_log_first_seq;
-static u32 printk_log_first_idx;
+u64 printk_log_first_seq;
+u32 printk_log_first_idx;
 
 /* index and sequence number of the next record to store in the buffer */
-static u64 printk_log_next_seq;
-static u32 printk_log_next_idx;
+u64 printk_log_next_seq;
+u32 printk_log_next_idx;
 
 /* the next printk record to write to the console */
 static u64 console_seq;
@@ -231,8 +231,8 @@ static u32 console_idx;
 static enum printk_log_flags console_prev;
 
 /* the next printk record to read after the last 'clear' command */
-static u64 printk_log_clear_seq;
-static u32 printk_log_clear_idx;
+u64 printk_log_clear_seq;
+u32 printk_log_clear_idx;
 
 #define PREFIX_MAX		32
 #define LOG_LINE_MAX		1024 - PREFIX_MAX
@@ -244,27 +244,27 @@ static u32 printk_log_clear_idx;
 #define LOG_ALIGN __alignof__(struct printk_log)
 #endif
 #define __PRINTK_LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
-static char __printk_log_buf[__PRINTK_LOG_BUF_LEN] __aligned(LOG_ALIGN);
-static char *printk_log_buf = __printk_log_buf;
-static u32 printk_log_buf_len = __PRINTK_LOG_BUF_LEN;
+char __printk_log_buf[__PRINTK_LOG_BUF_LEN] __aligned(LOG_ALIGN);
+char *printk_log_buf = __printk_log_buf;
+u32 printk_log_buf_len = __PRINTK_LOG_BUF_LEN;
 
 /* cpu currently holding printk_logbuf_lock */
 static volatile unsigned int logbuf_cpu = UINT_MAX;
 
 /* human readable text of the record */
-static char *printk_log_text(const struct printk_log *msg)
+char *printk_log_text(const struct printk_log *msg)
 {
 	return (char *)msg + sizeof(struct printk_log);
 }
 
 /* optional key/value pair dictionary attached to the record */
-static char *printk_log_dict(const struct printk_log *msg)
+char *printk_log_dict(const struct printk_log *msg)
 {
 	return (char *)msg + sizeof(struct printk_log) + msg->text_len;
 }
 
 /* get record by index; idx must point to valid msg */
-static struct printk_log *printk_log_from_idx(u32 idx)
+struct printk_log *printk_log_from_idx(u32 idx)
 {
 	struct printk_log *msg = (struct printk_log *)(printk_log_buf + idx);
 
@@ -278,7 +278,7 @@ static struct printk_log *printk_log_from_idx(u32 idx)
 }
 
 /* get next record; idx must point to valid msg */
-static u32 printk_log_next(u32 idx)
+u32 printk_log_next(u32 idx)
 {
 	struct printk_log *msg = (struct printk_log *)(printk_log_buf + idx);
 
@@ -296,10 +296,10 @@ static u32 printk_log_next(u32 idx)
 }
 
 /* insert record into the buffer, discard old ones, update heads */
-static void printk_log_store(int facility, int level,
-			     enum printk_log_flags flags, u64 ts_nsec,
-			     const char *dict, u16 dict_len,
-			     const char *text, u16 text_len)
+void printk_log_store(int facility, int level,
+		      enum printk_log_flags flags, u64 ts_nsec,
+		      const char *dict, u16 dict_len,
+		      const char *text, u16 text_len)
 {
 	struct printk_log *msg;
 	u32 size, pad_len;
@@ -1690,9 +1690,9 @@ static u32 syslog_idx;
 static u64 console_seq;
 static u32 console_idx;
 static enum printk_log_flags syslog_prev;
-static u64 printk_log_first_seq;
-static u32 printk_log_first_idx;
-static u64 printk_log_next_seq;
+u64 printk_log_first_seq;
+u32 printk_log_first_idx;
+u64 printk_log_next_seq;
 static enum printk_log_flags console_prev;
 static struct cont {
 	size_t len;
@@ -1700,8 +1700,8 @@ static struct cont {
 	u8 level;
 	bool flushed:1;
 } cont;
-static struct printk_log *printk_log_from_idx(u32 idx) { return NULL; }
-static u32 printk_log_next(u32 idx) { return 0; }
+struct printk_log *printk_log_from_idx(u32 idx) { return NULL; }
+u32 printk_log_next(u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
 static size_t msg_print_text(const struct printk_log *msg,
 			     enum printk_log_flags prev,
-- 
1.7.10.4

