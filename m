Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab1CKJuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:50:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:38567 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906Ab1CKJue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:50:34 -0500
Date: Fri, 11 Mar 2011 09:50:09 GMT
From: tip-bot for David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, nhorman@tuxdriver.com, dhsharp@google.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        nhorman@tuxdriver.com, rostedt@goodmis.org, dhsharp@google.com,
        tglx@linutronix.de
In-Reply-To: <1291421609-14665-10-git-send-email-dhsharp@google.com>
References: <1291421609-14665-10-git-send-email-dhsharp@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Fix event alignment: skb:kfree_skb
Message-ID: <tip-ca9da2dd63b0b32de1b693953dff66cadeb6400b@git.kernel.org>
Git-Commit-ID: ca9da2dd63b0b32de1b693953dff66cadeb6400b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Mar 2011 09:50:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca9da2dd63b0b32de1b693953dff66cadeb6400b
Gitweb:     http://git.kernel.org/tip/ca9da2dd63b0b32de1b693953dff66cadeb6400b
Author:     David Sharp <dhsharp@google.com>
AuthorDate: Fri, 3 Dec 2010 16:13:23 -0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 10 Mar 2011 10:34:31 -0500

tracing: Fix event alignment: skb:kfree_skb

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
