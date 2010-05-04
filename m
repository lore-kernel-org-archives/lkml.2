Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125Ab0EDSKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:10:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:48209 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757881Ab0EDSKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:10:09 -0400
Date: Tue, 4 May 2010 18:09:35 GMT
From: tip-bot for Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, bp@alien8.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, bp@alien8.de
In-Reply-To: <20100502060354.GA5281@liondog.tnic>
References: <20100502060354.GA5281@liondog.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] ring-buffer: Wrap open-coded WARN_ONCE
Message-ID: <tip-956097912c40a03bf22603a3be73503fd9ea9e44@git.kernel.org>
Git-Commit-ID: 956097912c40a03bf22603a3be73503fd9ea9e44
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 18:09:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  956097912c40a03bf22603a3be73503fd9ea9e44
Gitweb:     http://git.kernel.org/tip/956097912c40a03bf22603a3be73503fd9ea9e44
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Sun, 2 May 2010 08:03:54 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 4 May 2010 12:23:47 -0400

ring-buffer: Wrap open-coded WARN_ONCE

Wrap open-coded WARN_ONCE functionality into the equivalent macro.

Signed-off-by: Borislav Petkov <bp@alien8.de>
LKML-Reference: <20100502060354.GA5281@liondog.tnic>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2a09044..7f6059c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2000,17 +2000,13 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 		  u64 *ts, u64 *delta)
 {
 	struct ring_buffer_event *event;
-	static int once;
 	int ret;
 
-	if (unlikely(*delta > (1ULL << 59) && !once++)) {
-		printk(KERN_WARNING "Delta way too big! %llu"
-		       " ts=%llu write stamp = %llu\n",
-		       (unsigned long long)*delta,
-		       (unsigned long long)*ts,
-		       (unsigned long long)cpu_buffer->write_stamp);
-		WARN_ON(1);
-	}
+	WARN_ONCE(*delta > (1ULL << 59),
+		  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n",
+		  (unsigned long long)*delta,
+		  (unsigned long long)*ts,
+		  (unsigned long long)cpu_buffer->write_stamp);
 
 	/*
 	 * The delta is too big, we to add a
