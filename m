Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933881Ab2LILbA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 06:31:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56278 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933438Ab2LILa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 06:30:59 -0500
Date: Sun, 9 Dec 2012 03:30:45 -0800
From: tip-bot for Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <tip-70f77b3f7ec010ff9624c1f2e39a81babc9e2429@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, dan.carpenter@oracle.com
In-Reply-To: <20120609161027.GD6488@elgon.mountain>
References: <20120609161027.GD6488@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] ftrace: Clear bits properly in reset_iter_read(
 )
Git-Commit-ID: 70f77b3f7ec010ff9624c1f2e39a81babc9e2429
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 09 Dec 2012 03:30:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70f77b3f7ec010ff9624c1f2e39a81babc9e2429
Gitweb:     http://git.kernel.org/tip/70f77b3f7ec010ff9624c1f2e39a81babc9e2429
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Sat, 9 Jun 2012 19:10:27 +0300
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 15 Nov 2012 16:10:17 -0500

ftrace: Clear bits properly in reset_iter_read()

There is a typo here where '&' is used instead of '|' and it turns the
statement into a noop.  The original code is equivalent to:

	iter->flags &= ~((1 << 2) & (1 << 4));

Link: http://lkml.kernel.org/r/20120609161027.GD6488@elgon.mountain

Cc: stable@vger.kernel.org # all of them
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9dcf15d..51b7159 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2437,7 +2437,7 @@ static void reset_iter_read(struct ftrace_iterator *iter)
 {
 	iter->pos = 0;
 	iter->func_pos = 0;
-	iter->flags &= ~(FTRACE_ITER_PRINTALL & FTRACE_ITER_HASH);
+	iter->flags &= ~(FTRACE_ITER_PRINTALL | FTRACE_ITER_HASH);
 }
 
 static void *t_start(struct seq_file *m, loff_t *pos)
