Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab2IBOTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 10:19:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48669 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab2IBOTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 10:19:07 -0400
MIME-Version: 1.0
Date: Sun, 2 Sep 2012 22:19:06 +0800
Message-ID: <CAPgLHd-Qcfx2XSo_Ykq55yojTg3aCx_uvyxFA+YfKQaURwPUbg@mail.gmail.com>
Subject: [PATCH] mtd: fix possible memory leak in logfs_mtd_can_write_buf()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: joern@logfs.org, prasadjoshi.linux@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, logfs@logfs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

buf has been allocated in this function and should be
freed before leaving from the error handling case.

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/logfs/dev_mtd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/logfs/dev_mtd.c b/fs/logfs/dev_mtd.c
index 9c50144..427bb73 100644
--- a/fs/logfs/dev_mtd.c
+++ b/fs/logfs/dev_mtd.c
@@ -245,8 +245,8 @@ static int logfs_mtd_can_write_buf(struct super_block *sb, u64 ofs)
 		goto out;
 	if (memchr_inv(buf, 0xff, super->s_writesize))
 		err = -EIO;
-	kfree(buf);
 out:
+	kfree(buf);
 	return err;
 }
 


