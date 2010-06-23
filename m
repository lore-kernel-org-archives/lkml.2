Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab0FWNEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 09:04:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59439 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab0FWNEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 09:04:13 -0400
X-Authority-Analysis: v=1.1 cv=hVjE12FRt4v4sD2HVuppbi620CRC5en4UNTr7KPd1ng= c=1 sm=0 a=EokWY2JoZfsA:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=ktHwwxjJXnWpiby5ysQA:9 a=xEKFaKEul9VtxlOoq8XRtHFPJWsA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL][v2.6.35] tracing: Fix undeclared ENOSYS in
 include/linux/tracepoint.h
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Wu Zhangjin <wuzhangjin@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 23 Jun 2010 09:04:10 -0400
Message-ID: <1277298250.9181.32.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Wu Zhangjin (1):
      tracing: Fix undeclared ENOSYS in include/linux/tracepoint.h

----
 include/linux/tracepoint.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
---------------------------
commit b70e4f0529c089b00d0a6da13106db4de1ada4c7
Author: Wu Zhangjin <wuzhangjin@gmail.com>
Date:   Mon Jun 21 19:09:09 2010 +0800

    tracing: Fix undeclared ENOSYS in include/linux/tracepoint.h
    
    The header file include/linux/tracepoint.h may be included without
    include/linux/errno.h and then the compiler will fail on building for
    undelcared ENOSYS. This patch fixes this problem via including <linux/errno.h>
    to include/linux/tracepoint.h.
    
    Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
    LKML-Reference: <1277118549-622-1-git-send-email-wuzhangjin@gmail.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 9a59d1f..103d1b6 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -14,6 +14,7 @@
  * See the file COPYING for more details.
  */
 
+#include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/rcupdate.h>
 


