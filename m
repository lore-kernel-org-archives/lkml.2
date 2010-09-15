Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab0IOVHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:07:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab0IOVHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:07:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: nauman@google.com, dpshah@google.com, guijianfeng@cn.fujitsu.com,
        vgoyal@redhat.com
Subject: [PATCH 1/7] blk-cgroup: Kill the header printed at the start of blkio.weight_device file
Date: Wed, 15 Sep 2010 17:06:32 -0400
Message-Id: <1284584798-10264-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1284584798-10264-1-git-send-email-vgoyal@redhat.com>
References: <1284584798-10264-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Kill extra "dev weight" header which is printed when somebody reads
  blkio.weight_device file. This really seems to be out of convention. No other
  blkio files are printing any header at the start of file. I think it is ok
  to just print values and how to interpret values should be part of
  documentation.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 2fef1ef..e3d2506 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -811,8 +811,6 @@ static int blkiocg_weight_device_read(struct cgroup *cgrp, struct cftype *cft,
 	struct blkio_cgroup *blkcg;
 	struct blkio_policy_node *pn;
 
-	seq_printf(m, "dev\tweight\n");
-
 	blkcg = cgroup_to_blkio_cgroup(cgrp);
 	if (!list_empty(&blkcg->policy_list)) {
 		spin_lock_irq(&blkcg->lock);
-- 
1.7.2.3

