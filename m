Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab1FQCAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 22:00:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56323 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967Ab1FQB7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:59:20 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=WQ6hdsuZvB4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=z9S55zyz-Ag2jrM_XFEA:9 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110617015918.505012497@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 16 Jun 2011 21:55:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Hillf Danton <dhillf@gmail.com>
Subject: [RFC][PATCH 3/7] sched: Remove noop in lowest_flag_domain()
References: <20110617015516.301117218@goodmis.org>
Content-Disposition: inline; filename=0003-sched-Remove-noop-in-lowest_flag_domain.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hillf Danton <dhillf@gmail.com>

Checking for the validity of sd is removed, since it is already
checked by the for_each_domain macro.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Link: http://lkml.kernel.org/r/BANLkTimT+Tut-3TshCDm-NiLLXrOznibNA@mail.gmail.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 433491c..47f79d0 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3655,7 +3655,7 @@ static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
 	struct sched_domain *sd;
 
 	for_each_domain(cpu, sd)
-		if (sd && (sd->flags & flag))
+		if (sd->flags & flag)
 			break;
 
 	return sd;
-- 
1.7.4.4


