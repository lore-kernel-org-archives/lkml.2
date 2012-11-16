Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab2KPNWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 08:22:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9208 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2KPNWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 08:22:24 -0500
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ZVw62ScINJoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=-IsNnZDw7B4A:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=XiS71eQw0hOa5WyzGs0A:9 a=PUjeQqilurYA:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1353072143.7586.7.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL] ftrace: Clear bits properly in reset_iter_read()
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 16 Nov 2012 08:22:23 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 70f77b3f7ec010ff9624c1f2e39a81babc9e2429


Dan Carpenter (1):
      ftrace: Clear bits properly in reset_iter_read()

----
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---------------------------
commit 70f77b3f7ec010ff9624c1f2e39a81babc9e2429
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Sat Jun 9 19:10:27 2012 +0300

    ftrace: Clear bits properly in reset_iter_read()
    
    There is a typo here where '&' is used instead of '|' and it turns the
    statement into a noop.  The original code is equivalent to:
    
    	iter->flags &= ~((1 << 2) & (1 << 4));
    
    Link: http://lkml.kernel.org/r/20120609161027.GD6488@elgon.mountain
    
    Cc: stable@vger.kernel.org # all of them
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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


