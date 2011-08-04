Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab1HDIfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:35:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:48590 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab1HDIfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:35:08 -0400
Date: Thu, 4 Aug 2011 08:34:50 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-70a0686a72c7a7e554b404ca11406ceec709d425@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, lacombar@gmail.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, lacombar@gmail.com,
        mingo@elte.hu
In-Reply-To: <1311588599.2617.56.camel@laptop>
References: <1311588599.2617.56.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] lockdep: Fix up warning
Git-Commit-ID: 70a0686a72c7a7e554b404ca11406ceec709d425
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Aug 2011 08:34:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70a0686a72c7a7e554b404ca11406ceec709d425
Gitweb:     http://git.kernel.org/tip/70a0686a72c7a7e554b404ca11406ceec709d425
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 25 Jul 2011 12:09:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Aug 2011 10:17:41 +0200

lockdep: Fix up warning

On Sun, 2011-07-24 at 21:06 -0400, Arnaud Lacombe wrote:

> /src/linux/linux/kernel/lockdep.c: In function 'mark_held_locks':
> /src/linux/linux/kernel/lockdep.c:2471:31: warning: comparison of
> distinct pointer types lacks a cast

The warning is harmless in this case, but the below makes it go away.

Reported-by: Arnaud Lacombe <lacombar@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1311588599.2617.56.camel@laptop
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 74ca247..5903586 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2468,7 +2468,7 @@ mark_held_locks(struct task_struct *curr, enum mark_type mark)
 
 		BUG_ON(usage_bit >= LOCK_USAGE_STATES);
 
-		if (hlock_class(hlock)->key == &__lockdep_no_validate__)
+		if (hlock_class(hlock)->key == __lockdep_no_validate__.subkeys)
 			continue;
 
 		if (!mark_lock(curr, hlock, usage_bit))
