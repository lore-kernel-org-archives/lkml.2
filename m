Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0KZPD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:03:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:40340 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab0KZPDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:03:54 -0500
Date: Fri, 26 Nov 2010 15:03:25 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, xiyou.wangcong@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, xiyou.wangcong@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1290591835.2072.438.camel@laptop>
References: <1290591835.2072.438.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] scripts/tags.sh: Add magic for trace-events
Message-ID: <tip-35d3778a8fe3c8b4a7513565e34d3bde00ce43ec@git.kernel.org>
Git-Commit-ID: 35d3778a8fe3c8b4a7513565e34d3bde00ce43ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:03:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35d3778a8fe3c8b4a7513565e34d3bde00ce43ec
Gitweb:     http://git.kernel.org/tip/35d3778a8fe3c8b4a7513565e34d3bde00ce43ec
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 24 Nov 2010 10:43:55 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 15:14:54 +0100

scripts/tags.sh: Add magic for trace-events

Make tags find the trace-event definitions

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
LKML-Reference: <1290591835.2072.438.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
