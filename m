Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331Ab1IVGge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 02:36:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64656 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab1IVGgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 02:36:32 -0400
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] ipc:fix the wrong use of schedule_hrtimeout_range_clock()
Date: Thu, 22 Sep 2011 14:35:23 +0800
Message-Id: <1316673323-5048-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.rc1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-22 14:35:03,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-22 14:35:05,
	Serialize complete at 2011-09-22 14:35:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the wrong use of schedule_hrtimeout_range_clock() in wq_sleep(), although
it is harmless for the syscall mq_timed* now.
It's introduced by 9ca7d8e.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 ipc/mqueue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index ed049ea..2e0ecfc 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -449,8 +449,8 @@ static int wq_sleep(struct mqueue_inode_info *info, int sr,
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		spin_unlock(&info->lock);
-		time = schedule_hrtimeout_range_clock(timeout,
-		    HRTIMER_MODE_ABS, 0, CLOCK_REALTIME);
+		time = schedule_hrtimeout_range_clock(timeout, 0,
+			HRTIMER_MODE_ABS, CLOCK_REALTIME);
 
 		while (ewp->state == STATE_PENDING)
 			cpu_relax();
-- 
1.7.7.rc1

