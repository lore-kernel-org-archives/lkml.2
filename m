Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab0JROhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:37:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223Ab0JROhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:51 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/22] GFS2: Fix compiler warning from previous patch
Date: Mon, 18 Oct 2010 15:15:40 +0100
Message-Id: <1287411346-17855-17-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This shouldn't really be required, but gcc can't tell that
"al" is only accessed when initialised.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 1bf1788..6b24afb 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -615,7 +615,7 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 	unsigned int data_blocks = 0, ind_blocks = 0, rblocks;
 	int alloc_required;
 	int error = 0;
-	struct gfs2_alloc *al;
+	struct gfs2_alloc *al = NULL;
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
 	unsigned to = from + len;
-- 
1.7.1.1

