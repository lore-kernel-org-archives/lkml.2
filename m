Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1AIVLb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 16:11:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:38258 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab1AIVL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 16:11:29 -0500
Date: Sun, 9 Jan 2011 21:11:11 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, rostedt@goodmis.org,
        tglx@linutronix.de, laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, rostedt@goodmis.org,
        tglx@linutronix.de, laijs@cn.fujitsu.com
In-Reply-To: <4D22D4F1.50505@cn.fujitsu.com>
References: <4D22D4F1.50505@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracepoint: Add __rcu annotation
Message-ID: <tip-bd1c8b22b7b81c6f6c4f5c19cb2387da3d02fb0f@git.kernel.org>
Git-Commit-ID: bd1c8b22b7b81c6f6c4f5c19cb2387da3d02fb0f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 09 Jan 2011 21:11:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd1c8b22b7b81c6f6c4f5c19cb2387da3d02fb0f
Gitweb:     http://git.kernel.org/tip/bd1c8b22b7b81c6f6c4f5c19cb2387da3d02fb0f
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 4 Jan 2011 16:06:09 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 7 Jan 2011 20:57:22 -0500

tracepoint: Add __rcu annotation

Add __rcu annotation to :
	(struct tracepoint)->funcs

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4D22D4F1.50505@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 899103c..c681461 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -32,7 +32,7 @@ struct tracepoint {
 	int state;			/* State. */
 	void (*regfunc)(void);
 	void (*unregfunc)(void);
-	struct tracepoint_func *funcs;
+	struct tracepoint_func __rcu *funcs;
 } __attribute__((aligned(32)));		/*
 					 * Aligned on 32 bytes because it is
 					 * globally visible and gcc happily
