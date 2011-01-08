Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1AHURJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 15:17:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49711 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1AHUQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 15:16:48 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=avmG3L3dyTAA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7d_E57ReAAAA:8 a=vmLDa1wCAAAA:8 a=J1Y8HTJGAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=omOdbC7AAAAA:8 a=fvfMJ6VmQ66XwW72YKMA:9 a=_yWWt9VZEVZ2Pem2cGXVVQnBYEYA:4 a=D6-X0JM3zdQA:10 a=gv_BBZfBKR8A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110108201645.155505021@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 08 Jan 2011 15:16:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Zhaolei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/7] tracing: remove duplicate null-pointer check in skb tracepoint
References: <20110108201559.130182944@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-remove-duplicate-null-pointer-check-in-skb-t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

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
 
-- 
1.7.2.3


