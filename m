Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1AIVLX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 16:11:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:38254 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab1AIVLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 16:11:22 -0500
Date: Sun, 9 Jan 2011 21:10:49 GMT
From: tip-bot for Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, zhaolei@cn.fujitsu.com,
        davem@davemloft.net, fweisbec@gmail.com, nhorman@tuxdriver.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, zhaolei@cn.fujitsu.com,
        davem@davemloft.net, fweisbec@gmail.com, nhorman@tuxdriver.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110106175319.GA30610@Krystal>
References: <20110106175319.GA30610@Krystal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: remove duplicate null-pointer check in skb tracepoint
Message-ID: <tip-881fe4bdcdc899674524e30a76c76d298b447008@git.kernel.org>
Git-Commit-ID: 881fe4bdcdc899674524e30a76c76d298b447008
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 09 Jan 2011 21:10:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  881fe4bdcdc899674524e30a76c76d298b447008
Gitweb:     http://git.kernel.org/tip/881fe4bdcdc899674524e30a76c76d298b447008
Author:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
AuthorDate: Thu, 6 Jan 2011 12:53:19 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 7 Jan 2011 20:55:42 -0500

tracing: remove duplicate null-pointer check in skb tracepoint

The check for NULL skb in the kfree_skb trace event is a duplicate from the
check already done in its only caller, kfree_skb(). Remove this duplicate check.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <20110106175319.GA30610@Krystal>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: David S. Miller <davem@davemloft.net>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Zhaolei <zhaolei@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/skb.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 75ce9d5..f10293c 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -25,9 +25,7 @@ TRACE_EVENT(kfree_skb,
 
 	TP_fast_assign(
 		__entry->skbaddr = skb;
-		if (skb) {
-			__entry->protocol = ntohs(skb->protocol);
-		}
+		__entry->protocol = ntohs(skb->protocol);
 		__entry->location = location;
 	),
 
