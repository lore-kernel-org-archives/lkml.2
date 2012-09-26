Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2IZIwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:52:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480Ab2IZIwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:52:05 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 25/27] GFS2: Fix infinite loop in rbm_find
Date: Wed, 26 Sep 2012 09:25:46 +0100
Message-Id: <1348647948-3219-26-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes an infinite loop in gfs2_rbm_find that was introduced
by the previous patch. The problem occurred when the length was less
than 3 but the rbm block was byte-aligned, causing it to improperly
return a extent length of zero, which caused it to spin.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Tested-by: Bob Peterson <rpeterso@redhat.com>
Tested-by: Barry Marson <bmarson@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index b933cdc..3cc402c 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -329,6 +329,7 @@ static u32 gfs2_free_extlen(const struct gfs2_rbm *rrbm, u32 len)
 	    gfs2_unaligned_extlen(&rbm, 4 - n_unaligned, &len))
 		goto out;
 
+	n_unaligned = len & 3;
 	/* Start is now byte aligned */
 	while (len > 3) {
 		start = rbm.bi->bi_bh->b_data;
-- 
1.7.4

