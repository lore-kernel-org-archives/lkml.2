Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab1GUKJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:09:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:60142 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab1GUKJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:09:49 -0400
Date: Thu, 21 Jul 2011 10:09:19 GMT
From: tip-bot for Jean Delvare <khali@linux-fr.org>
Message-ID: <tip-4582c0a4866ea70c35aa9279e1f91834d3348a93@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, khali@linux-fr.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, khali@linux-fr.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110716174200.41002352@endymion.delvare>
References: <20110716174200.41002352@endymion.delvare>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] mutex: Make mutex_destroy() an inline function
Git-Commit-ID: 4582c0a4866ea70c35aa9279e1f91834d3348a93
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:09:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4582c0a4866ea70c35aa9279e1f91834d3348a93
Gitweb:     http://git.kernel.org/tip/4582c0a4866ea70c35aa9279e1f91834d3348a93
Author:     Jean Delvare <khali@linux-fr.org>
AuthorDate: Sat, 16 Jul 2011 17:42:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 09:36:09 +0200

mutex: Make mutex_destroy() an inline function

The non-debug variant of mutex_destroy is a no-op, currently
implemented as a macro which does nothing. This approach fails
to check the type of the parameter, so an error would only show
when debugging gets enabled. Using an inline function instead,
offers type checking for earlier bug catching.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110716174200.41002352@endymion.delvare
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/mutex.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index a940fe4..7f87217 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -92,7 +92,7 @@ do {							\
 							\
 	__mutex_init((mutex), #mutex, &__key);		\
 } while (0)
-# define mutex_destroy(mutex)				do { } while (0)
+static inline void mutex_destroy(struct mutex *lock) {}
 #endif
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
