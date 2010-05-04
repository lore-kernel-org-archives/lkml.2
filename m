Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050Ab0EDDqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 23:46:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64819 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab0EDDpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 23:45:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=V8qZxla4q8sOphxb9nM6yijQT/lfnhowk44URell4lZZEbcOd0olmadX60tuoFHC8l
         v0GbzuM3LFGrK99MeO1bczG8+8Si/nDwamY5HD+Ky9wQ8wenOTzylgSAkrZHvT9uCkeZ
         k46HKgHyYiogY9xZ79IWzQp8elvmJpAtJn8y8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/3] lockdep: Actually _dec_ in debug_atomic_dec
Date: Tue,  4 May 2010 05:45:35 +0200
Message-Id: <1272944736-25141-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1272944736-25141-1-git-send-regression-fweisbec@gmail.com>
References: <1272944736-25141-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a silly copy-paste mistake that was making debug_atomic_dec use
this_cpu_inc instead of this_cpu_dec.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/lockdep_internals.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 7de27a8..8d929c7 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -149,7 +149,7 @@ DECLARE_PER_CPU(struct lockdep_stats, lockdep_stats);
 
 #define debug_atomic_dec(ptr)			{		\
 	WARN_ON_ONCE(!irqs_disabled());				\
-	this_cpu_inc(lockdep_stats.ptr);			\
+	this_cpu_dec(lockdep_stats.ptr);			\
 }
 
 #define debug_atomic_read(ptr)		({				\
-- 
1.6.2.3

