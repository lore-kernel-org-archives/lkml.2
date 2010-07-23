Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab0GWMK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:10:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:43020 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759265Ab0GWMKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:10:23 -0400
Date: Fri, 23 Jul 2010 12:10:03 GMT
From: tip-bot for Richard Kennedy <richard@rsk.demon.co.uk>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, richard@rsk.demon.co.uk, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, richard@rsk.demon.co.uk
In-Reply-To: <1269516456.2054.8.camel@localhost>
References: <1269516456.2054.8.camel@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] trace: Reorder struct ring_buffer_per_cpu to remove padding on 64bit
Message-ID: <tip-985023dee6e212493831431ba2e3ce8918f001b2@git.kernel.org>
Git-Commit-ID: 985023dee6e212493831431ba2e3ce8918f001b2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Jul 2010 12:10:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  985023dee6e212493831431ba2e3ce8918f001b2
Gitweb:     http://git.kernel.org/tip/985023dee6e212493831431ba2e3ce8918f001b2
Author:     Richard Kennedy <richard@rsk.demon.co.uk>
AuthorDate: Thu, 25 Mar 2010 11:27:36 +0000
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 20 Jul 2010 21:58:44 -0400

trace: Reorder struct ring_buffer_per_cpu to remove padding on 64bit

Reorder structure to remove 8 bytes of padding on 64 bit builds.
This shrinks the size to 128 bytes so allowing allocation from a smaller
slab & needed one fewer cache lines.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
LKML-Reference: <1269516456.2054.8.camel@localhost>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 28d0615..3632ce8 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -443,6 +443,7 @@ int ring_buffer_print_page_header(struct trace_seq *s)
  */
 struct ring_buffer_per_cpu {
 	int				cpu;
+	atomic_t			record_disabled;
 	struct ring_buffer		*buffer;
 	spinlock_t			reader_lock;	/* serialize readers */
 	arch_spinlock_t			lock;
@@ -462,7 +463,6 @@ struct ring_buffer_per_cpu {
 	unsigned long			read;
 	u64				write_stamp;
 	u64				read_stamp;
-	atomic_t			record_disabled;
 };
 
 struct ring_buffer {
