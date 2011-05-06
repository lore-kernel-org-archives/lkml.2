Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab1EFVGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:06:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:30362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756747Ab1EFVFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:05:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,328,1301900400"; 
   d="scan'208";a="639164502"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, arnd@arndb.de, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/4] BKL: Remove BKL references in mutex code
Date: Fri,  6 May 2011 14:05:25 -0700
Message-Id: <1304715928-19266-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1304715928-19266-1-git-send-email-andi@firstfloor.org>
References: <1304715928-19266-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The mutex code still checks for the BKL which is already gone.
Remove that code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/mutex.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index c4195fa..62d0a06 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -163,13 +163,6 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		struct thread_info *owner;
 
 		/*
-		 * If we own the BKL, then don't spin. The owner of
-		 * the mutex might be waiting on us to release the BKL.
-		 */
-		if (unlikely(current->lock_depth >= 0))
-			break;
-
-		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
 		 */
-- 
1.7.4.4

