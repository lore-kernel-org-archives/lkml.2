Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2IZIvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:51:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab2IZIvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:51 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/27] GFS2: Eliminate unnecessary check for state > 3 in bitfit
Date: Wed, 26 Sep 2012 09:25:36 +0100
Message-Id: <1348647948-3219-16-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Function gfs2_bitfit was checking for state > 3, but that's
impossible since it is only called from rgblk_search, which receives
only GFS2_BLKST_ constants.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index c267118..47d2346 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -228,8 +228,6 @@ static u32 gfs2_bitfit(const u8 *buf, const unsigned int len,
 	u64 mask = 0x5555555555555555ULL;
 	u32 bit;
 
-	BUG_ON(state > 3);
-
 	/* Mask off bits we don't care about at the start of the search */
 	mask <<= spoint;
 	tmp = gfs2_bit_search(ptr, mask, state);
-- 
1.7.4

