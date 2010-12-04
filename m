Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab0LDAP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:15:59 -0500
Received: from smtp-out.google.com ([74.125.121.35]:16972 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab0LDANw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:13:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=EnTSDUbtNDbES1e9hA44PYwtL40QOrdZOptQph0ZoE3xSAVbQ/2Z3l96zQ7EBdSfE
	lvU/scs9KKaT1J00xUkTA==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH 06/15] ftrace: fix event alignment: module:module_request
Date: Fri,  3 Dec 2010 16:13:20 -0800
Message-Id: <1291421609-14665-7-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291421609-14665-1-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David Sharp <dhsharp@google.com>
---
 include/trace/events/module.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index c7bb2f0..8154f5f 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -98,14 +98,14 @@ TRACE_EVENT(module_request,
 	TP_ARGS(name, wait, ip),
 
 	TP_STRUCT__entry(
-		__field(	bool,		wait		)
 		__field(	unsigned long,	ip		)
+		__field(	bool,		wait		)
 		__string(	name,		name		)
 	),
 
 	TP_fast_assign(
-		__entry->wait	= wait;
 		__entry->ip	= ip;
+		__entry->wait	= wait;
 		__assign_str(name, name);
 	),
 
@@ -119,4 +119,3 @@ TRACE_EVENT(module_request,
 
 /* This part must be outside protection */
 #include <trace/define_trace.h>
-
-- 
1.7.3.1

