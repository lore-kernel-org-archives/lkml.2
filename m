Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab0LMPG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:06:57 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51774 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab0LMPG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:06:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RETfIbLURKpgDivPyOo0Xj+GpCQTXkdgExF0Rl2Hxjctw3GbR75A3Dp5/mRqjVXm8f
         Eqscrqtc4dqC+ASFj6sERMGLy4tDM93zJzNaNE1n2jj4E7D2JGyXf8cAHvRBJ1R0bTdw
         5l1X+E4KLsswDSABvTfXr+vWX3ZkH8MXR5c6c=
From: Namhyung Kim <namhyung@gmail.com>
To: Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] aio: check return value of create_workqueue()
Date: Tue, 14 Dec 2010 00:06:25 +0900
Message-Id: <1292252785-3683-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/aio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 8c8f6c5b6d79..c56153f5f73e 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -87,7 +87,7 @@ static int __init aio_setup(void)
 
 	aio_wq = create_workqueue("aio");
 	abe_pool = mempool_create_kmalloc_pool(1, sizeof(struct aio_batch_entry));
-	BUG_ON(!abe_pool);
+	BUG_ON(!aio_wq || !abe_pool);
 
 	pr_debug("aio_setup: sizeof(struct page) = %d\n", (int)sizeof(struct page));
 
-- 
1.7.3.3.400.g93cef

