Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1DVMVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:21:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:57075 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab1DVMVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:21:42 -0400
Date: Fri, 22 Apr 2011 12:21:20 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-6be8c3935b914dfbc24b27c91c2b6d583645e61a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110421014300.135521252@goodmis.org>
References: <20110421014300.135521252@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Replace "Bad BFS generated tree" message with something less cryptic
Git-Commit-ID: 6be8c3935b914dfbc24b27c91c2b6d583645e61a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Apr 2011 12:21:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6be8c3935b914dfbc24b27c91c2b6d583645e61a
Gitweb:     http://git.kernel.org/tip/6be8c3935b914dfbc24b27c91c2b6d583645e61a
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 20 Apr 2011 21:41:58 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Apr 2011 11:06:59 +0200

lockdep: Replace "Bad BFS generated tree" message with something less cryptic

The message of "Bad BFS generated tree" is a bit confusing.
Replace it with a more sane error message.

Thanks to Peter Zijlstra for helping me come up with a better
message.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110421014300.135521252@goodmis.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 0b497dd..270cfa4 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1381,7 +1381,7 @@ print_shortest_lock_dependencies(struct lock_list *leaf,
 		printk("\n");
 
 		if (depth == 0 && (entry != root)) {
-			printk("lockdep:%s bad BFS generated tree\n", __func__);
+			printk("lockdep:%s bad path found in chain graph\n", __func__);
 			break;
 		}
 
