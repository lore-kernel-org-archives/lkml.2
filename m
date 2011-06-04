Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1FDJaA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 05:30:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab1FDJ37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 05:29:59 -0400
Subject: [patch] sched, cgroups: fix MIN_SHARES on 64 bit boxen
From: Mike Galbraith <mgalbraith@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Nikhil Rao <ncrao@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Jun 2011 11:29:56 +0200
Message-ID: <1307179796.25172.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


c8b28116 claimed to have no user-visible effect, but allows setting cpu.shares
to < MIN_SHARES, which the user then indeed sees.

Signed-off-by: Mike Galbraith <efault@gmx.de>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -292,7 +292,7 @@ static DEFINE_SPINLOCK(task_group_lock);
  * (The default weight is 1024 - so there's no practical
  *  limitation from this.)
  */
-#define MIN_SHARES	2
+#define MIN_SHARES	(scale_load(2))
 #define MAX_SHARES	(1UL << (18 + SCHED_LOAD_RESOLUTION))
 
 static int root_task_group_load = ROOT_TASK_GROUP_LOAD;


