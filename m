Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab2DKJV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:21:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507Ab2DKJV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:21:28 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/4] GFS2: put glock reference in error patch of read_rindex_entry
Date: Wed, 11 Apr 2012 09:56:51 +0100
Message-Id: <1334134614-19805-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1334134614-19805-1-git-send-email-swhiteho@redhat.com>
References: <1334134614-19805-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes the error path of function read_rindex_entry
so that it correctly gives up its glock reference in cases where
there is a race to re-read the rindex after gfs2_grow.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 19bde40..19354a2 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -640,6 +640,7 @@ static int read_rindex_entry(struct gfs2_inode *ip,
 		return 0;
 
 	error = 0; /* someone else read in the rgrp; free it and ignore it */
+	gfs2_glock_put(rgd->rd_gl);
 
 fail:
 	kfree(rgd->rd_bits);
-- 
1.7.4

