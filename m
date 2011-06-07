Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab1FGRId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 13:08:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45708 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab1FGRI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 13:08:28 -0400
X-Authority-Analysis: v=1.1 cv=rr9DlE2fnT1UeYFJeFag6ks/js+bHNfqVlaSByoS2d4= c=1 sm=0 a=vhdKIqpQuCYA:10 a=mRvQ3hcqCxEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=48ptq4NsoW1jBpPCVXMA:9 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110607170827.030733507@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 07 Jun 2011 13:07:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        GuoWen Li <guowen.li.linux@gmail.com>
Subject: [PATCH 1/3] ftrace: Fix possible undefined return code
References: <20110607170740.235441001@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Fix-possible-undefined-return-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GuoWen Li <guowen.li.linux@gmail.com>

kernel/trace/ftrace.c: In function 'ftrace_regex_write.clone.15':
kernel/trace/ftrace.c:2743:6: warning: 'ret' may be used uninitialized in this
function

Signed-off-by: GuoWen Li <guowen.li.linux@gmail.com>
Link: http://lkml.kernel.org/r/201106011918.47939.guowen.li.linux@gmail.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1ee417f..204b3eb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2740,7 +2740,7 @@ static int ftrace_process_regex(struct ftrace_hash *hash,
 {
 	char *func, *command, *next = buff;
 	struct ftrace_func_command *p;
-	int ret;
+	int ret = -EINVAL;
 
 	func = strsep(&next, ":");
 
-- 
1.7.4.4


