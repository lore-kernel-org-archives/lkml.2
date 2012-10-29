Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab2J2Fu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 01:50:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:20666 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab2J2Fua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 01:50:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,669,1344236400"; 
   d="scan'208";a="233906577"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] staging: dgrp: fix potential NULL defereference issue
Date: Mon, 29 Oct 2012 13:50:37 +0800
Message-Id: <1351489837-4176-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a coccinelle warning catched by Fengguang's 0-DAY system:
+ drivers/staging/dgrp/dgrp_net_ops.c:1061:11-27: ERROR: nd is NULL but dereferenced.

Put the "done:" label a bit down would solve this issue.

Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/staging/dgrp/dgrp_net_ops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_net_ops.c b/drivers/staging/dgrp/dgrp_net_ops.c
index ab839ea..1ad674f1 100644
--- a/drivers/staging/dgrp/dgrp_net_ops.c
+++ b/drivers/staging/dgrp/dgrp_net_ops.c
@@ -1057,13 +1057,13 @@ static int dgrp_net_release(struct inode *inode, struct file *file)
 
 	spin_unlock_irqrestore(&dgrp_poll_data.poll_lock, lock_flags);
 
-done:
 	down(&nd->nd_net_semaphore);
 
 	dgrp_monitor_message(nd, "Net Close");
 
 	up(&nd->nd_net_semaphore);
 
+done:
 	module_put(THIS_MODULE);
 	file->private_data = NULL;
 	return 0;
-- 
1.7.7.6

