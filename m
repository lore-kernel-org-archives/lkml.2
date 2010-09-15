Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab0IODEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 23:04:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33499 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab0IODEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 23:04:04 -0400
X-Authority-Analysis: v=1.1 cv=2ipXt8Ao/PPbK329gQN1nC6XU/V8QMABDttguNTIlb0= c=1 sm=0 a=sQHJX5_9QLgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=tMyJRXMan_OHwGL2mxMA:9 a=SkGnl6RqEKepcU38FwsA:7 a=pnt6ZGvAVcinRFf1r-h5DRUsmb4A:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100915030402.346004778@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 14 Sep 2010 23:01:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] tracing: Remove leftover FTRACE_ENABLE/DISABLE_MCOUNT enums
References: <20100915030139.444219083@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Remove-leftover-FTRACE_ENABLE-DISABLE_MCOUNT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The enums for FTRACE_ENABLE_MCOUNT and FTRACE_DISABLE_MCOUNT were
used as commands to ftrace_run_update_code(). But these commands
were used by the old nasty ftrace daemon that has long been slain.

This is a clean up patch to remove the references to these enums
and simplify the code a little.

Reported-by: Wu Zhangjin <wuzhangjin@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 83a16e9..20aff3f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -884,10 +884,8 @@ enum {
 	FTRACE_ENABLE_CALLS		= (1 << 0),
 	FTRACE_DISABLE_CALLS		= (1 << 1),
 	FTRACE_UPDATE_TRACE_FUNC	= (1 << 2),
-	FTRACE_ENABLE_MCOUNT		= (1 << 3),
-	FTRACE_DISABLE_MCOUNT		= (1 << 4),
-	FTRACE_START_FUNC_RET		= (1 << 5),
-	FTRACE_STOP_FUNC_RET		= (1 << 6),
+	FTRACE_START_FUNC_RET		= (1 << 3),
+	FTRACE_STOP_FUNC_RET		= (1 << 4),
 };
 
 static int ftrace_filtered;
@@ -1226,8 +1224,6 @@ static void ftrace_shutdown(int command)
 
 static void ftrace_startup_sysctl(void)
 {
-	int command = FTRACE_ENABLE_MCOUNT;
-
 	if (unlikely(ftrace_disabled))
 		return;
 
@@ -1235,23 +1231,17 @@ static void ftrace_startup_sysctl(void)
 	saved_ftrace_func = NULL;
 	/* ftrace_start_up is true if we want ftrace running */
 	if (ftrace_start_up)
-		command |= FTRACE_ENABLE_CALLS;
-
-	ftrace_run_update_code(command);
+		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
 }
 
 static void ftrace_shutdown_sysctl(void)
 {
-	int command = FTRACE_DISABLE_MCOUNT;
-
 	if (unlikely(ftrace_disabled))
 		return;
 
 	/* ftrace_start_up is true if ftrace is running */
 	if (ftrace_start_up)
-		command |= FTRACE_DISABLE_CALLS;
-
-	ftrace_run_update_code(command);
+		ftrace_run_update_code(FTRACE_DISABLE_CALLS);
 }
 
 static cycle_t		ftrace_update_time;
-- 
1.7.1


