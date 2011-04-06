Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1DFIeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 04:34:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab1DFIeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 04:34:11 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, WANG Cong <amwang@redhat.com>,
        Tejun Heo <tj@kernel.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org
Subject: [Patch] workqueue: remove cancel_rearming_delayed_work[queue]()
Date: Wed,  6 Apr 2011 16:33:13 +0800
Message-Id: <1302078793-2596-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cancel_rearming_delayed_work() and cancel_rearming_delayed_workqueue()
can be removed now.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Tejun Heo <tj@kernel.org>

---
 Documentation/feature-removal-schedule.txt |   10 ----------
 include/linux/workqueue.h                  |   15 ---------------
 2 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 274b32d..c70fb4b 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -541,16 +541,6 @@ Who:    NeilBrown <neilb@suse.de>
 
 ----------------------------
 
-What:	cancel_rearming_delayed_work[queue]()
-When:	2.6.39
-
-Why:	The functions have been superceded by cancel_delayed_work_sync()
-	quite some time ago.  The conversion is trivial and there is no
-	in-kernel user left.
-Who:	Tejun Heo <tj@kernel.org>
-
-----------------------------
-
 What:	Legacy, non-standard chassis intrusion detection interface.
 When:	June 2011
 Why:	The adm9240, w83792d and w83793 hardware monitoring drivers have
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index f584aba..57b31b3 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -412,21 +412,6 @@ static inline bool __cancel_delayed_work(struct delayed_work *work)
 	return ret;
 }
 
-/* Obsolete. use cancel_delayed_work_sync() */
-static inline __deprecated
-void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
-					struct delayed_work *work)
-{
-	cancel_delayed_work_sync(work);
-}
-
-/* Obsolete. use cancel_delayed_work_sync() */
-static inline __deprecated
-void cancel_rearming_delayed_work(struct delayed_work *work)
-{
-	cancel_delayed_work_sync(work);
-}
-
 #ifndef CONFIG_SMP
 static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 {
