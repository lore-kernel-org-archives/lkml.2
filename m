Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921Ab0EDDpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 23:45:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36290 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759454Ab0EDDpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 23:45:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=u1UxINFfh8/2HBR56ZjiCxRhmutbl2AZVdc9gyrIv/7FSh1csMXt8GlYNjzhy2g+hI
         c44OTVwp/bmUJkxYD/TxbXV64RqgpcRysKYqW8z7neJGne357+qNemGBFsCZ+/5iWJXc
         VGnW3wZC8T+qOTDguSEydkCA0pZLqQL6aj26w=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/3] lockdep: No need to disable preemption in debug atomic ops
Date: Tue,  4 May 2010 05:45:36 +0200
Message-Id: <1272944736-25141-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1272944736-25141-1-git-send-regression-fweisbec@gmail.com>
References: <1272944736-25141-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to disable preemption in the debug_atomic_* ops, as
we ensure interrupts are disabled already.

So let's use the __this_cpu_ops() rather than this_cpu_ops() that
enclose the ops in a preempt disabled section.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/lockdep_internals.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 8d929c7..4f560cf 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -144,12 +144,12 @@ DECLARE_PER_CPU(struct lockdep_stats, lockdep_stats);
 
 #define debug_atomic_inc(ptr)			{		\
 	WARN_ON_ONCE(!irqs_disabled());				\
-	this_cpu_inc(lockdep_stats.ptr);			\
+	__this_cpu_inc(lockdep_stats.ptr);			\
 }
 
 #define debug_atomic_dec(ptr)			{		\
 	WARN_ON_ONCE(!irqs_disabled());				\
-	this_cpu_dec(lockdep_stats.ptr);			\
+	__this_cpu_dec(lockdep_stats.ptr);			\
 }
 
 #define debug_atomic_read(ptr)		({				\
-- 
1.6.2.3

