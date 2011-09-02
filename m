Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab1IBWyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 18:54:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537Ab1IBWy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 18:54:28 -0400
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] mm: Add comment explaining task state setting in bdi_forker_thread()
Date: Sat,  3 Sep 2011 00:54:19 +0200
Message-Id: <1315004059-9844-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1315004059-9844-1-git-send-email-jack@suse.cz>
References: <1315004059-9844-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/backing-dev.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 94a047b..a87da52 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -401,6 +401,13 @@ static int bdi_forker_thread(void *ptr)
 		}
 
 		spin_lock_bh(&bdi_lock);
+		/*
+		 * In the following loop we are going to check whether we have
+		 * some work to do without any synchronization with tasks
+		 * waking us up to do work for them. So we have to set task
+		 * state already here so that we don't miss wakeups coming
+		 * after we verify some condition.
+		 */
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		list_for_each_entry(bdi, &bdi_list, bdi_list) {
-- 
1.7.1

