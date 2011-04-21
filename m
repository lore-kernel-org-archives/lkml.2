Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab1DUNP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:15:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54397 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1DUNP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:15:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=oNJXpOrpaNQq1QZWQYB59RK6X6EaBjV6xpz1A/Gk9IfkklY1V38xkv+5g0w3mZDszn
         pKbN9VPt0AEIdj/QfhVzfipQe+Btdx/CH4sOQfV4AJP+fmR5cxfOV2hMk5atel/ZuUsa
         tiV7jW8Z5z2h5p9HkppZOohi9SVpAXIHW75i0=
MIME-Version: 1.0
Date: Thu, 21 Apr 2011 21:15:56 +0800
Message-ID: <BANLkTi=41=2_QOMOabg1UrwQ2A06fJAY9w@mail.gmail.com>
Subject: [PATCH] sched: deduplicate mm checks in normalize_rt_tasks()
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When normalizing realtime tasks, only user tasks are concerned by
checking their ->mm.
If the task is not realtime, the -mm is checked again, thus the
overwork could be removed.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched.c	2011-03-30 03:09:48.000000000 +0800
+++ b/kernel/sched.c	2011-04-21 20:59:28.000000000 +0800
@@ -8364,7 +8364,7 @@ void normalize_rt_tasks(void)
 			 * Renice negative nice level userspace
 			 * tasks back to 0:
 			 */
-			if (TASK_NICE(p) < 0 && p->mm)
+			if (TASK_NICE(p) < 0)
 				set_user_nice(p, 0);
 			continue;
 		}
