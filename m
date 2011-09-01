Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab1IAP5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:57:22 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56061 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab1IAP5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:57:21 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] mm/backing-dev.c: Call del_timer_sync instead of del_timer
Date: Thu,  1 Sep 2011 21:27:02 +0530
Message-Id: <1314892622-18267-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is important for SMP scenario, to check whether the timer
callback is executing on another CPU when we are deleting the
timer.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 mm/backing-dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index d6edf8d..754b35a 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -385,7 +385,7 @@ static int bdi_forker_thread(void *ptr)
 		 * dirty data on the default backing_dev_info
 		 */
 		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list)) {
-			del_timer(&me->wakeup_timer);
+			del_timer_sync(&me->wakeup_timer);
 			wb_do_writeback(me, 0);
 		}
 
-- 
1.7.4.1

