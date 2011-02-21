Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab1BUJEC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 04:04:02 -0500
Received: from mail-bw0-f52.google.com ([209.85.214.52]:41061 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab1BUJD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 04:03:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=MvAOP3dQa1/NvHdiUR+FembqTN4IggnMBGBM2LxSOAqKEjSgFnyM2H04Ff5/LS3I5M
         MtrqPFECg79M3rXDhMWZJ1iVuJ61wq6tYXZBZ5Kry/PVCWclJbDdnJ+40J9PhxyemHId
         qAc8aXiqiDmN/xQ/g7c6Zy80kwudgx9/5p1Wo=
Date: Mon, 21 Feb 2011 10:03:54 +0100
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH wq#for-2.6.39] workqueue: fix build failure introduced by
 s/freezeable/freezable/
Message-ID: <20110221090354.GE31267@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

new usage of the flag.  The combination of the two creates a build
failure after merge.  Fix it by renaming all freezeables to
freezables.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
I pulled mainline into wq#for-2.6.39 and applied the build fix.
#for-next updated accordingly.  Dmitry, please feel free to pull in
the following branch for system_wq_freezable.  The branch is stable.
HEAD is 6c9e293a1f (workqueue: fix build failure introduced by
s/freezeable/freezable/).

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-2.6.39

Thank you.

 include/linux/workqueue.h |    6 +++---
 kernel/workqueue.c        |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index d110cc4..f584aba 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -287,14 +287,14 @@ enum {
  * executed immediately as long as max_active limit is not reached and
  * resources are available.
  *
- * system_freezeable_wq is equivalent to system_wq except that it's
- * freezeable.
+ * system_freezable_wq is equivalent to system_wq except that it's
+ * freezable.
  */
 extern struct workqueue_struct *system_wq;
 extern struct workqueue_struct *system_long_wq;
 extern struct workqueue_struct *system_nrt_wq;
 extern struct workqueue_struct *system_unbound_wq;
-extern struct workqueue_struct *system_freezeable_wq;
+extern struct workqueue_struct *system_freezable_wq;
 
 extern struct workqueue_struct *
 __alloc_workqueue_key(const char *name, unsigned int flags, int max_active,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 572f559..1b64d22 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -251,12 +251,12 @@ struct workqueue_struct *system_wq __read_mostly;
 struct workqueue_struct *system_long_wq __read_mostly;
 struct workqueue_struct *system_nrt_wq __read_mostly;
 struct workqueue_struct *system_unbound_wq __read_mostly;
-struct workqueue_struct *system_freezeable_wq __read_mostly;
+struct workqueue_struct *system_freezable_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_wq);
 EXPORT_SYMBOL_GPL(system_long_wq);
 EXPORT_SYMBOL_GPL(system_nrt_wq);
 EXPORT_SYMBOL_GPL(system_unbound_wq);
-EXPORT_SYMBOL_GPL(system_freezeable_wq);
+EXPORT_SYMBOL_GPL(system_freezable_wq);
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/workqueue.h>
@@ -3777,10 +3777,10 @@ static int __init init_workqueues(void)
 	system_nrt_wq = alloc_workqueue("events_nrt", WQ_NON_REENTRANT, 0);
 	system_unbound_wq = alloc_workqueue("events_unbound", WQ_UNBOUND,
 					    WQ_UNBOUND_MAX_ACTIVE);
-	system_freezeable_wq = alloc_workqueue("events_freezeable",
-					       WQ_FREEZEABLE, 0);
+	system_freezable_wq = alloc_workqueue("events_freezable",
+					      WQ_FREEZABLE, 0);
 	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq ||
-	       !system_unbound_wq || !system_freezeable_wq);
+	       !system_unbound_wq || !system_freezable_wq);
 	return 0;
 }
 early_initcall(init_workqueues);
-- 
1.7.1

