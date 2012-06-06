Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030Ab2FFVnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:43:49 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:33774 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758728Ab2FFVly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:41:54 -0400
X-IronPort-AV: E=Sophos;i="4.75,726,1330902000"; 
   d="scan'208";a="161655287"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: kernel-janitors@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com,
        Julia Lawall <julia@diku.dk>
Subject: [PATCH 4/7] fs/direct-io.c: adjust suspicious bit operation
Date: Wed,  6 Jun 2012 23:41:38 +0200
Message-Id: <1339018901-28439-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

READ is 0, so the result of the bit-and operation is 0.  Rewrite with == as
done elsewhere in the same file.

This problem was found using Coccinelle (http://coccinelle.lip6.fr/).

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/direct-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 0c85fae..1faf4cb 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1258,7 +1258,7 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	 */
 	BUG_ON(retval == -EIOCBQUEUED);
 	if (dio->is_async && retval == 0 && dio->result &&
-	    ((rw & READ) || (dio->result == sdio.size)))
+	    ((rw == READ) || (dio->result == sdio.size)))
 		retval = -EIOCBQUEUED;
 
 	if (retval != -EIOCBQUEUED)

