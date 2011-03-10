Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab1CJQAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:00:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41186 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab1CJP7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:59:13 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=e1eq3qaPrXEA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=vmLDa1wCAAAA:8 a=meVymXHHAAAA:8 a=WjJ91Z8ph75Tghrdv-oA:9 a=nSq_8MGjRWvMi_ZVg_8A:7 a=9p5FondaxfWwezPstntUFxyG2xwA:4 a=UTB_XpHje0EA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110310155911.021074929@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Mar 2011 10:58:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, David Sharp <dhsharp@google.com>
Subject: [PATCH 08/15] tracing: Fix event alignment: skb:kfree_skb
References: <20110310155800.478792851@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-Fix-event-alignment-skb-kfree_skb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Sharp <dhsharp@google.com>

Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David Sharp <dhsharp@google.com>
LKML-Reference: <1291421609-14665-10-git-send-email-dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/skb.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index f10293c..0c68ae22 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -19,14 +19,14 @@ TRACE_EVENT(kfree_skb,
 
 	TP_STRUCT__entry(
 		__field(	void *,		skbaddr		)
-		__field(	unsigned short,	protocol	)
 		__field(	void *,		location	)
+		__field(	unsigned short,	protocol	)
 	),
 
 	TP_fast_assign(
 		__entry->skbaddr = skb;
-		__entry->protocol = ntohs(skb->protocol);
 		__entry->location = location;
+		__entry->protocol = ntohs(skb->protocol);
 	),
 
 	TP_printk("skbaddr=%p protocol=%u location=%p",
-- 
1.7.2.3


