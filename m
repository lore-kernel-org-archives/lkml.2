Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab2JROva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:51:30 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50706 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab2JROv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:51:26 -0400
MIME-Version: 1.0
Date: Thu, 18 Oct 2012 22:51:25 +0800
Message-ID: <CAPgLHd8MSy-k8Vpdw7r8iP3XL8Od-3jVGBzs63gnCv75yM8KUQ@mail.gmail.com>
Subject: [PATCH] fuse: remove unused variable in fuse_try_move_page()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: miklos@szeredi.hu
Cc: yongjun_wei@trendmicro.com.cn, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variables mapping,index are initialized but never used
otherwise, so remove the unused variables.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/fuse/dev.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 8c23fa7..53c294c 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -692,8 +692,6 @@ static int fuse_try_move_page(struct fuse_copy_state *cs, struct page **pagep)
 	struct page *oldpage = *pagep;
 	struct page *newpage;
 	struct pipe_buffer *buf = cs->pipebufs;
-	struct address_space *mapping;
-	pgoff_t index;
 
 	unlock_request(cs->fc, cs->req);
 	fuse_copy_finish(cs);
@@ -724,9 +722,6 @@ static int fuse_try_move_page(struct fuse_copy_state *cs, struct page **pagep)
 	if (fuse_check_page(newpage) != 0)
 		goto out_fallback_unlock;
 
-	mapping = oldpage->mapping;
-	index = oldpage->index;
-
 	/*
 	 * This is a new and locked page, it shouldn't be mapped or
 	 * have any special flags on it


