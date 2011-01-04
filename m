Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab1ADOTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:19:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:32995 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab1ADOTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:19:42 -0500
Date: Tue, 4 Jan 2011 14:19:13 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, oleg@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        oleg@redhat.com, mingo@elte.hu
In-Reply-To: <1293784350.6839.2.camel@marge.simson.net>
References: <1293784350.6839.2.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, autogroup: Fix reference leak
Message-ID: <tip-101e5f77bf35679809586e250b6c62193d2ed179@git.kernel.org>
Git-Commit-ID: 101e5f77bf35679809586e250b6c62193d2ed179
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 Jan 2011 14:19:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  101e5f77bf35679809586e250b6c62193d2ed179
Gitweb:     http://git.kernel.org/tip/101e5f77bf35679809586e250b6c62193d2ed179
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Fri, 31 Dec 2010 09:32:30 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Jan 2011 15:10:36 +0100

sched, autogroup: Fix reference leak

The cgroup exit mess also uncovered a struct autogroup reference leak.
copy_process() was simply freeing vs putting the signal_struct,
stranding a reference.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>
LKML-Reference: <1293784350.6839.2.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/fork.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index b6f2475..0672444 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1317,7 +1317,7 @@ bad_fork_cleanup_mm:
 	}
 bad_fork_cleanup_signal:
 	if (!(clone_flags & CLONE_THREAD))
-		free_signal_struct(p->signal);
+		put_signal_struct(p->signal);
 bad_fork_cleanup_sighand:
 	__cleanup_sighand(p->sighand);
 bad_fork_cleanup_fs:
