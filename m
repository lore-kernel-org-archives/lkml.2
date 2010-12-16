Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab0LPIWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 03:22:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:44357 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab0LPIWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 03:22:36 -0500
Date: Thu, 16 Dec 2010 08:22:06 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, xiyou.wangcong@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl, peterz@infradead.org,
        tglx@linutronix.de, xiyou.wangcong@gmail.com
In-Reply-To: <1290591835.2072.438.camel@laptop>
References: <1290591835.2072.438.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] scripts/tags.sh: Add magic for trace-events
Message-ID: <tip-15664125f7cadcb6d725cb2d9b90f9715397848d@git.kernel.org>
Git-Commit-ID: 15664125f7cadcb6d725cb2d9b90f9715397848d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 08:22:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15664125f7cadcb6d725cb2d9b90f9715397848d
Gitweb:     http://git.kernel.org/tip/15664125f7cadcb6d725cb2d9b90f9715397848d
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 24 Nov 2010 10:43:55 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 2 Dec 2010 09:39:48 -0500

scripts/tags.sh: Add magic for trace-events

Make tags find the trace-event definitions

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1290591835.2072.438.camel@laptop>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/tags.sh |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 8509bb5..bbbe584 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -125,7 +125,9 @@ exuberant()
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
 	--extra=+f --c-kinds=-px                                \
 	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
-	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/'
+	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
+	--regex-c++='/^TRACE_EVENT\(([^,)]*).*/trace_\1/'		\
+	--regex-c++='/^DEFINE_EVENT\(([^,)]*).*/trace_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
