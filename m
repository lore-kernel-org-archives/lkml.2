Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515Ab0G3LKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 07:10:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62794 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab0G3LKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 07:10:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=afDyG49QIaKcyqW5UDtQgjuVNUfwJqt4oFA6Cf8cIAHQcaPDPrmDSFowCduVSWVaCH
         R9jBCiuIqF9fxsFXVAUgb/rZBami7u+Ni+UlDQlE8Z4UiZkVtiS69A1GJ+CjecBWDKvq
         6UWZH/ZrldvZDrPI1CjUf0gav5Q5NHKeu5Zo4=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] fs: nfs: misused copy_to_user() return value
Date: Fri, 30 Jul 2010 15:09:50 +0400
Message-Id: <1280488190-20979-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user() returns nonzero value on error, this value may be any
value between 0 and requested count, not only requested count.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 fs/nfs/idmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index 21a84d4..a9f2cd5 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -362,7 +362,7 @@ idmap_pipe_upcall(struct file *filp, struct rpc_pipe_msg *msg,
 	unsigned long left;
 
 	left = copy_to_user(dst, data, mlen);
-	if (left == mlen) {
+	if (left)
 		msg->errno = -EFAULT;
 		return -EFAULT;
 	}
-- 
1.7.0.4

