Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1JTVIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:08:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab1JTVIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:08:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: vgoyal@redhat.com, tj@kernel.org
Subject: [PATCH 1/2] blk-throttle: Free up policy node associated with deleted rule
Date: Thu, 20 Oct 2011 17:08:25 -0400
Message-Id: <1319144906-5066-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a rule is being deleted, free up associated policy node. Otherwise
that memory is leaked.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b596e54..4ddf11f 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1085,6 +1085,7 @@ static int blkiocg_file_write(struct cgroup *cgrp, struct cftype *cft,
 
 	if (blkio_delete_rule_command(newpn)) {
 		blkio_policy_delete_node(pn);
+		kfree(pn);
 		spin_unlock_irq(&blkcg->lock);
 		goto update_io_group;
 	}
-- 
1.7.4.4

