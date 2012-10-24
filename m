Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935214Ab2JXTqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:46:17 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:36325 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161038Ab2JXTqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:46:13 -0400
Date: Wed, 24 Oct 2012 12:46:05 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [GIT PULL] workqueue fixes for v3.7-rc2
Message-ID: <20121024194605.GH12182@atj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This pull request contains one patch from Dan Magenheimer to fix
cancel_delayed_work() regression introduced by its reimplementation
using try_to_grab_pending().  The reimplementation made it incorrectly
return %true when the work item is idle.  There aren't too many
consumers of the return value but it broke at least ramster.

Please pull from the following branch to receive the fix.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.7-fixes

  workqueue: cancel_delayed_work() should return %false if work item is idle (2012-10-24 12:38:16 -0700)

----------------------------------------------------------------
Dan Magenheimer (1):
      workqueue: cancel_delayed_work() should return %false if work item is idle

 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1
---
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d951daa..042d221 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2982,7 +2982,7 @@ bool cancel_delayed_work(struct delayed_work *dwork)
 
 	set_work_cpu_and_clear_pending(&dwork->work, work_cpu(&dwork->work));
 	local_irq_restore(flags);
-	return true;
+	return ret;
 }
 EXPORT_SYMBOL(cancel_delayed_work);
 
