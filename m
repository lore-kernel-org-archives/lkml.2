Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab0E0TH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:07:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665Ab0E0THl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:07:41 -0400
Date: Thu, 27 May 2010 15:07:40 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100527190336.24665.22701.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: mutex: Fix !CONFIG_MUTEX_SPIN_ON_OWNER compile warning
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes linux-next !CONFIG_MUTEX_SPIN_ON_OWNER compile warning:

kernel/mutex.c: In function ‘__mutex_lock_common’:
kernel/mutex.c:148: error: unused variable ‘timeout’

timeout is only used if CONFIG_MUTEX_SPIN_ON_OWNER is on.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 7d4626b..c262942 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -145,7 +145,9 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
 	unsigned long flags;
+#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 	unsigned long timeout;
+#endif
 
 	preempt_disable();
 	mutex_acquire(&lock->dep_map, subclass, 0, ip);
