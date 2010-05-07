Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab0EGSlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:41:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:46348 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800Ab0EGSlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:41:01 -0400
Date: Fri, 7 May 2010 18:40:42 GMT
From: tip-bot for Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, error27@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       error27@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20100320143911.GF5331@bicker>
References: <20100320143911.GF5331@bicker>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix check at end of event search
Message-ID: <tip-d9f599e1e6d019968b35d2dc63074b9e8964fa69@git.kernel.org>
Git-Commit-ID: d9f599e1e6d019968b35d2dc63074b9e8964fa69
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:40:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9f599e1e6d019968b35d2dc63074b9e8964fa69
Gitweb:     http://git.kernel.org/tip/d9f599e1e6d019968b35d2dc63074b9e8964fa69
Author:     Dan Carpenter <error27@gmail.com>
AuthorDate: Sat, 20 Mar 2010 17:39:11 +0300
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 6 May 2010 19:49:52 -0400

perf: Fix check at end of event search

The original code doesn't work because "call" is never NULL there.

Signed-off-by: Dan Carpenter <error27@gmail.com>
LKML-Reference: <20100320143911.GF5331@bicker>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 88c0b6d..58092d8 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1398,7 +1398,7 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 	}
 
 	err = -EINVAL;
-	if (!call)
+	if (&call->list == &ftrace_events)
 		goto out_unlock;
 
 	err = -EEXIST;
