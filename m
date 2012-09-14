Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab2INLqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:46:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51312 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672Ab2INLk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:40:58 -0400
Date: Fri, 14 Sep 2012 04:40:41 -0700
From: tip-bot for Yuanhan Liu <yuanhan.liu@linux.intel.com>
Message-ID: <tip-76bab1b78ab6f25d5f74165f94526c25fc93d984@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yuanhan.liu@linux.intel.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yuanhan.liu@linux.intel.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1346051625-25231-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1346051625-25231-1-git-send-email-yuanhan.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Skip printing "OK"
  if failed to disable event
Git-Commit-ID: 76bab1b78ab6f25d5f74165f94526c25fc93d984
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 14 Sep 2012 04:40:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  76bab1b78ab6f25d5f74165f94526c25fc93d984
Gitweb:     http://git.kernel.org/tip/76bab1b78ab6f25d5f74165f94526c25fc93d984
Author:     Yuanhan Liu <yuanhan.liu@linux.intel.com>
AuthorDate: Mon, 27 Aug 2012 15:13:45 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 13 Sep 2012 22:52:07 -0400

tracing: Skip printing "OK" if failed to disable event

No acutal case found. But logically, we should skip "OK" in case any
error met.

Link: http://lkml.kernel.org/r/1346051625-25231-1-git-send-email-yuanhan.liu@linux.intel.com

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 6825d83..bbb0e63 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1646,9 +1646,11 @@ static __init void event_trace_self_tests(void)
 		event_test_stuff();
 
 		ret = __ftrace_set_clr_event(NULL, system->name, NULL, 0);
-		if (WARN_ON_ONCE(ret))
+		if (WARN_ON_ONCE(ret)) {
 			pr_warning("error disabling system %s\n",
 				   system->name);
+			continue;
+		}
 
 		pr_cont("OK\n");
 	}
