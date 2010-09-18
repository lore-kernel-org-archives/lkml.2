Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab0IRToT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:44:19 -0400
Received: from kroah.org ([198.145.64.141]:51629 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab0IRTCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:02 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:59 2010
Message-Id: <20100918185959.582265183@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [079/123] sched: Make warning less noisy
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-make-warning-less-noisy.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

commit 416eb39556a03d1c7e52b0791e9052ccd71db241 upstream

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170517.807938893@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2071,7 +2071,7 @@ void set_task_cpu(struct task_struct *p,
 	 * We should never call set_task_cpu() on a blocked task,
 	 * ttwu() will sort out the placement.
 	 */
-	WARN_ON(p->state != TASK_RUNNING && p->state != TASK_WAKING);
+	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING);
 #endif
 
 	trace_sched_migrate_task(p, new_cpu);


