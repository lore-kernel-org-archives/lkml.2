Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab1LRKM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 05:12:57 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40344 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab1LRKMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 05:12:55 -0500
MIME-Version: 1.0
Date: Sun, 18 Dec 2011 15:42:53 +0530
Message-ID: <CAJd0RV=NdYFY8sLnB5EQY9wiWm+0U0C3EaCmKE8jpunHdYkcAA@mail.gmail.com>
Subject: [PATCH] sched: Simplify task_group_is_autogroup
From: Sisir Koppaka <sisir.koppaka@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the !! in task_group_is_autogroup doesn't impede functionality.

Tested with and without CONFIG_SCHED_AUTOGROUP.

Signed-off-by: Sisir Koppaka <sisir.koppaka@gmail.com>
---
 kernel/sched/auto_group.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/auto_group.h b/kernel/sched/auto_group.h
index 8bd0471..f628798 100644
--- a/kernel/sched/auto_group.h
+++ b/kernel/sched/auto_group.h
@@ -21,7 +21,7 @@ extern void autogroup_free(struct task_group *tg);

 static inline bool task_group_is_autogroup(struct task_group *tg)
 {
-	return !!tg->autogroup;
+	return tg->autogroup;
 }

 extern bool task_wants_autogroup(struct task_struct *p, struct task_group *tg);
-- 
1.7.7.4


                sk
