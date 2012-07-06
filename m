Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab2GFL0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:26:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52360 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2GFL0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:26:33 -0400
Date: Fri, 6 Jul 2012 04:26:21 -0700
From: tip-bot for Jason Baron <jbaron@redhat.com>
Message-ID: <tip-326f418b4c74ab4a6066f38b6144bc6461f9447b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbaron@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jbaron@redhat.com
In-Reply-To: <5fffcd40a6c063769badcdd74a7d90980500dbcb.1340909155.git.jbaron@redhat.com>
References: <5fffcd40a6c063769badcdd74a7d90980500dbcb.1340909155.git.jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracepoint: Use static_key_false(),
  since static_branch() is deprecated
Git-Commit-ID: 326f418b4c74ab4a6066f38b6144bc6461f9447b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:26:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  326f418b4c74ab4a6066f38b6144bc6461f9447b
Gitweb:     http://git.kernel.org/tip/326f418b4c74ab4a6066f38b6144bc6461f9447b
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Thu, 28 Jun 2012 15:04:57 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 6 Jul 2012 10:53:49 +0200

tracepoint: Use static_key_false(), since static_branch() is deprecated

Convert the last user of static_branch() -> static_key_false().

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: a.p.zijlstra@chello.nl
Link: http://lkml.kernel.org/r/5fffcd40a6c063769badcdd74a7d90980500dbcb.1340909155.git.jbaron@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
