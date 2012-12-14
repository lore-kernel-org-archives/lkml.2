Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab2LNW2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:28:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:38364 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab2LNW2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:28:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 20/22] ftrace: Clear bits properly in reset_iter_read()
Date: Fri, 14 Dec 2012 14:26:05 -0800
Message-Id: <20121214222254.459419060@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222249.889051473@linuxfoundation.org>
References: <20121214222249.889051473@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 70f77b3f7ec010ff9624c1f2e39a81babc9e2429 upstream.

There is a typo here where '&' is used instead of '|' and it turns the
statement into a noop.  The original code is equivalent to:

	iter->flags &= ~((1 << 2) & (1 << 4));

Link: http://lkml.kernel.org/r/20120609161027.GD6488@elgon.mountain

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2058,7 +2058,7 @@ static void reset_iter_read(struct ftrac
 {
 	iter->pos = 0;
 	iter->func_pos = 0;
-	iter->flags &= ~(FTRACE_ITER_PRINTALL & FTRACE_ITER_HASH);
+	iter->flags &= ~(FTRACE_ITER_PRINTALL | FTRACE_ITER_HASH);
 }
 
 static void *t_start(struct seq_file *m, loff_t *pos)


