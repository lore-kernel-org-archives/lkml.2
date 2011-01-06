Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab1AFRxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:53:25 -0500
Received: from mail.openrapids.net ([64.15.138.104]:42407 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751030Ab1AFRxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 12:53:23 -0500
Date: Thu, 6 Jan 2011 12:53:19 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Zhaolei <zhaolei@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] trace event skb remove duplicate null-pointer check
Message-ID: <20110106175319.GA30610@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:51:44 up 43 days, 22:54,  6 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check for NULL skb in the kfree_skb trace event is a duplicate from the
check already done in its only caller, kfree_skb(). Remove this duplicate check.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Zhaolei <zhaolei@cn.fujitsu.com>
---
 include/trace/events/skb.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6-lttng/include/trace/events/skb.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/skb.h
+++ linux-2.6-lttng/include/trace/events/skb.h
@@ -25,9 +25,7 @@ TRACE_EVENT(kfree_skb,
 
 	TP_fast_assign(
 		__entry->skbaddr = skb;
-		if (skb) {
-			__entry->protocol = ntohs(skb->protocol);
-		}
+		__entry->protocol = ntohs(skb->protocol);
 		__entry->location = location;
 	),
 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
