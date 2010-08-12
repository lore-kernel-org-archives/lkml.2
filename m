Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423Ab0HLUE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:04:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:33058 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab0HLUEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:04:25 -0400
Date: Thu, 12 Aug 2010 20:03:48 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Add back list_head data types
Message-ID: <tip-88d89da64951377962334b684634cfc1468aa93f@git.kernel.org>
Git-Commit-ID: 88d89da64951377962334b684634cfc1468aa93f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 12 Aug 2010 20:03:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88d89da64951377962334b684634cfc1468aa93f
Gitweb:     http://git.kernel.org/tip/88d89da64951377962334b684634cfc1468aa93f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 12 Aug 2010 21:50:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Aug 2010 21:50:00 +0200

perf: Add back list_head data types

This commit:

 de5d9bf: Move list types from <linux/list.h> to <linux/types.h>.

Moved the list head data types out of list.h, breaking the build.
Add them to the perf types.h as well.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/include/linux/types.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/include/linux/types.h b/tools/perf/util/include/linux/types.h
index 196862a..12de3b8 100644
--- a/tools/perf/util/include/linux/types.h
+++ b/tools/perf/util/include/linux/types.h
@@ -6,4 +6,16 @@
 #define DECLARE_BITMAP(name,bits) \
 	unsigned long name[BITS_TO_LONGS(bits)]
 
+struct list_head {
+	struct list_head *next, *prev;
+};
+
+struct hlist_head {
+	struct hlist_node *first;
+};
+
+struct hlist_node {
+	struct hlist_node *next, **pprev;
+};
+
 #endif
