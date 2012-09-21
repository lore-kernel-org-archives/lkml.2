Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab2IUFvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 01:51:20 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39606 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2IUFvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 01:51:19 -0400
MIME-Version: 1.0
Date: Fri, 21 Sep 2012 13:51:18 +0800
Message-ID: <CAPgLHd-Fpei5pNeyLrgvQogEF8phJrr2F-nKpchG6JE9ykxiWg@mail.gmail.com>
Subject: [PATCH] ufs: fix return value check in ufs_alloc_lastblock()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: dushistov@mail.ru
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function ufs_get_locked_page() returns ERR_PTR()
or NULL pointer. The IS_ERR() test in the error handling should be
replaced with IS_ERR_OR_NULL().

dpatch engine is used to auto generated this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/ufs/truncate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ufs/truncate.c b/fs/ufs/truncate.c
index f04f89f..82426ed 100644
--- a/fs/ufs/truncate.c
+++ b/fs/ufs/truncate.c
@@ -391,7 +391,7 @@ static int ufs_alloc_lastblock(struct inode *inode)
 
 	lastpage = ufs_get_locked_page(mapping, lastfrag >>
 				       (PAGE_CACHE_SHIFT - inode->i_blkbits));
-       if (IS_ERR(lastpage)) {
+	if (IS_ERR_OR_NULL(lastpage)) {
                err = -EIO;
                goto out;
        }

