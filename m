Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab1FKNKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 09:10:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50386 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab1FKNKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 09:10:43 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=GlIjFS2FHvoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=6E_QkzQ48XXZZBZaDhwA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL][v3.0] tracing: Fix regression in printk_formats
 file
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 11 Jun 2011 09:10:40 -0400
Message-ID: <1307797840.9218.48.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent

Head SHA1: db5e7ecc4abc91b9f26f0c0d79ef88a51e987d90


Steven Rostedt (1):
      tracing: Fix regression in printk_formats file

----
 kernel/trace/trace_printk.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)
---------------------------
commit db5e7ecc4abc91b9f26f0c0d79ef88a51e987d90
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Jun 9 08:40:59 2011 -0400

    tracing: Fix regression in printk_formats file
    
    The fix to fix the printk_formats of modules broke the
    printk_formats of trace_printks in the kernel.
    
    The update of what to show via the seq_file was only updated
    if the passed in fmt was NULL, which happens only on the first
    iteration. The result was showing the first format every time
    instead of iterating through the available formats.
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index dff763b..1f06468 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -240,13 +240,10 @@ static const char **find_next(void *v, loff_t *pos)
 	const char **fmt = v;
 	int start_index;
 
-	if (!fmt)
-		fmt = __start___trace_bprintk_fmt + *pos;
-
 	start_index = __stop___trace_bprintk_fmt - __start___trace_bprintk_fmt;
 
 	if (*pos < start_index)
-		return fmt;
+		return __start___trace_bprintk_fmt + *pos;
 
 	return find_next_mod_format(start_index, v, fmt, pos);
 }


