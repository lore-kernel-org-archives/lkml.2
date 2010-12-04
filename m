Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0LDAQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:16:17 -0500
Received: from smtp-out.google.com ([216.239.44.51]:58497 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab0LDANv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:13:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=POC9q5B86hlpPJSCP3tZc345d7njmjUK3SaLcJn/H+ld8LkQ/ZUrr6v5BVhSbRC1s
	2Lpmdd2QsYeCVpE+OqlFA==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH 09/15] ftrace: fix event alignment: skb:kfree_skb
Date: Fri,  3 Dec 2010 16:13:23 -0800
Message-Id: <1291421609-14665-10-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291421609-14665-1-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David Sharp <dhsharp@google.com>
---
 include/trace/events/skb.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 75ce9d5..aa4a56a 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -19,16 +19,16 @@ TRACE_EVENT(kfree_skb,
 
 	TP_STRUCT__entry(
 		__field(	void *,		skbaddr		)
-		__field(	unsigned short,	protocol	)
 		__field(	void *,		location	)
+		__field(	unsigned short,	protocol	)
 	),
 
 	TP_fast_assign(
 		__entry->skbaddr = skb;
+		__entry->location = location;
 		if (skb) {
 			__entry->protocol = ntohs(skb->protocol);
 		}
-		__entry->location = location;
 	),
 
 	TP_printk("skbaddr=%p protocol=%u location=%p",
-- 
1.7.3.1

