Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab2L1Tdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:33:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55508 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932316Ab2L1TTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:14 -0500
Message-Id: <20121228190343.385449351@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 063/173] ftrace: Clear bits properly in reset_iter_read()
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 70f77b3f7ec010ff9624c1f2e39a81babc9e2429 upstream.

There is a typo here where '&' is used instead of '|' and it turns the
statement into a noop.  The original code is equivalent to:

	iter->flags &= ~((1 << 2) & (1 << 4));

Link: http://lkml.kernel.org/r/20120609161027.GD6488@elgon.mountain

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/ftrace.c |    2 +-
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


