Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab2JQGIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:08:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56540 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754516Ab2JQGIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:08:05 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [PATCH 09/23] printk: Rename enum log_flags to printk_log_flags
Date: Tue, 16 Oct 2012 23:06:13 -0700
Message-Id: <671efbf307fa7d921d5d951974ef13d933a04c26.1350449852.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350449851.git.joe@perches.com>
References: <cover.1350449851.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make this generic enum more specific to the printk subsystem.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/printk.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 992c064..341f2d9 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -187,7 +187,7 @@ static int console_may_schedule;
  * separated by ',', and find the message after the ';' character.
  */
 
-enum log_flags {
+enum printk_log_flags {
 	LOG_NOCONS	= 1,	/* already flushed, do not print to console */
 	LOG_NEWLINE	= 2,	/* text ended with a newline */
 	LOG_PREFIX	= 4,	/* text started with a prefix */
@@ -214,7 +214,7 @@ static DEFINE_RAW_SPINLOCK(logbuf_lock);
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
 static u64 syslog_seq;
 static u32 syslog_idx;
-static enum log_flags syslog_prev;
+static enum printk_log_flags syslog_prev;
 static size_t syslog_partial;
 
 /* index and sequence number of the first record stored in the buffer */
@@ -228,7 +228,7 @@ static u32 printk_log_next_idx;
 /* the next printk record to write to the console */
 static u64 console_seq;
 static u32 console_idx;
-static enum log_flags console_prev;
+static enum printk_log_flags console_prev;
 
 /* the next printk record to read after the last 'clear' command */
 static u64 clear_seq;
@@ -297,7 +297,7 @@ static u32 printk_log_next(u32 idx)
 
 /* insert record into the buffer, discard old ones, update heads */
 static void printk_log_store(int facility, int level,
-			     enum log_flags flags, u64 ts_nsec,
+			     enum printk_log_flags flags, u64 ts_nsec,
 			     const char *dict, u16 dict_len,
 			     const char *text, u16 text_len)
 {
@@ -360,7 +360,7 @@ static void printk_log_store(int facility, int level,
 struct devkmsg_user {
 	u64 seq;
 	u32 idx;
-	enum log_flags prev;
+	enum printk_log_flags prev;
 	struct mutex lock;
 	char buf[8192];
 };
@@ -872,7 +872,8 @@ static size_t print_prefix(const struct printk_log *msg, bool syslog, char *buf)
 	return len;
 }
 
-static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
+static size_t msg_print_text(const struct printk_log *msg,
+			     enum printk_log_flags prev,
 			     bool syslog, char *buf, size_t size)
 {
 	const char *text = printk_log_text(msg);
@@ -1009,7 +1010,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		u64 next_seq;
 		u64 seq;
 		u32 idx;
-		enum log_flags prev;
+		enum printk_log_flags prev;
 
 		if (clear_seq < printk_log_first_seq) {
 			/* messages are gone, move to first available one */
@@ -1194,7 +1195,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 		} else {
 			u64 seq = syslog_seq;
 			u32 idx = syslog_idx;
-			enum log_flags prev = syslog_prev;
+			enum printk_log_flags prev = syslog_prev;
 
 			error = 0;
 			while (seq < printk_log_next_seq) {
@@ -1383,11 +1384,11 @@ static struct cont {
 	u64 ts_nsec;			/* time of first print */
 	u8 level;			/* log level of first message */
 	u8 facility;			/* log level of first message */
-	enum log_flags flags;		/* prefix, newline flags */
+	enum printk_log_flags flags;	/* prefix, newline flags */
 	bool flushed:1;			/* buffer sealed and committed */
 } cont;
 
-static void cont_flush(enum log_flags flags)
+static void cont_flush(enum printk_log_flags flags)
 {
 	if (cont.flushed)
 		return;
@@ -1481,7 +1482,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	static char textbuf[LOG_LINE_MAX];
 	char *text = textbuf;
 	size_t text_len;
-	enum log_flags lflags = 0;
+	enum printk_log_flags lflags = 0;
 	unsigned long flags;
 	int this_cpu;
 	int printed_len = 0;
@@ -1688,11 +1689,11 @@ static u64 syslog_seq;
 static u32 syslog_idx;
 static u64 console_seq;
 static u32 console_idx;
-static enum log_flags syslog_prev;
+static enum printk_log_flags syslog_prev;
 static u64 printk_log_first_seq;
 static u32 printk_log_first_idx;
 static u64 printk_log_next_seq;
-static enum log_flags console_prev;
+static enum printk_log_flags console_prev;
 static struct cont {
 	size_t len;
 	size_t cons;
@@ -1702,7 +1703,8 @@ static struct cont {
 static struct printk_log *printk_log_from_idx(u32 idx) { return NULL; }
 static u32 printk_log_next(u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
-static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
+static size_t msg_print_text(const struct printk_log *msg,
+			     enum printk_log_flags prev,
 			     bool syslog, char *buf, size_t size) { return 0; }
 static size_t cont_print_text(char *text, size_t size) { return 0; }
 
@@ -2688,7 +2690,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	u32 idx;
 	u64 next_seq;
 	u32 next_idx;
-	enum log_flags prev;
+	enum printk_log_flags prev;
 	size_t l = 0;
 	bool ret = false;
 
-- 
1.7.10.4

