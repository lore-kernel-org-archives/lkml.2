Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab2F1TGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 15:06:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab2F1TFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 15:05:09 -0400
Date: Thu, 28 Jun 2012 15:04:57 -0400
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        a.p.zijlstra@chello.nl, hpa@zytor.com, linux-kernel@vger.kernel.org
Message-Id: <5fffcd40a6c063769badcdd74a7d90980500dbcb.1340909155.git.jbaron@redhat.com>
In-Reply-To: <cover.1340909155.git.jbaron@redhat.com>
References: <cover.1340909155.git.jbaron@redhat.com>
Subject: [PATCH 1/2] tracepoint: use static_key_false(), since static_branch() is deprecated
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert last user of static_branch() -> static_key_false().

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/tracepoint.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index bd96ecd..802de56 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -153,7 +153,7 @@ static inline void tracepoint_synchronize_unregister(void)
 	}								\
 	static inline void trace_##name##_rcuidle(proto)		\
 	{								\
-		if (static_branch(&__tracepoint_##name.key))		\
+		if (static_key_false(&__tracepoint_##name.key))		\
 			__DO_TRACE(&__tracepoint_##name,		\
 				TP_PROTO(data_proto),			\
 				TP_ARGS(data_args),			\
-- 
1.7.1

