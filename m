Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0IEBxK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 21:53:10 -0400
Received: from mail.perches.com ([173.55.12.10]:1341 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab0IEBxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 21:53:06 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/13] drivers/infiniband: Remove unnecessary casts of private_data
Date: Sat,  4 Sep 2010 18:52:43 -0700
Message-Id: <a13edeb14cc926b71e21daff892acbe2d76313ab.1283650107.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <cover.1283650107.git.joe@perches.com>
References: <cover.1283650107.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/qib/qib_file_ops.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 6b11645..cef5d67 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1722,7 +1722,7 @@ static int qib_close(struct inode *in, struct file *fp)
 
 	mutex_lock(&qib_mutex);
 
-	fd = (struct qib_filedata *) fp->private_data;
+	fd = fp->private_data;
 	fp->private_data = NULL;
 	rcd = fd->rcd;
 	if (!rcd) {
@@ -1808,7 +1808,7 @@ static int qib_ctxt_info(struct file *fp, struct qib_ctxt_info __user *uinfo)
 	struct qib_ctxtdata *rcd = ctxt_fp(fp);
 	struct qib_filedata *fd;
 
-	fd = (struct qib_filedata *) fp->private_data;
+	fd = fp->private_data;
 
 	info.num_active = qib_count_active_units();
 	info.unit = rcd->dd->unit;
-- 
1.7.2.19.g9a302

