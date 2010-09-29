Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab0I2SVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 14:21:35 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:45728 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754966Ab0I2SVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 14:21:34 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH] RDMA/cxgb4: use simple_read_from_buffer() for debugfs
	handlers.
To: rdreier@cisco.com, stable@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Sep 2010 13:21:33 -0500
Message-ID: <20100929182133.30260.84058.stgit@build.ogc.int>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb4/device.c |   26 +-------------------------
 1 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index b254357..22a290d 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -68,32 +68,8 @@ static ssize_t debugfs_read(struct file *file, char __user *buf, size_t count,
 			    loff_t *ppos)
 {
 	struct c4iw_debugfs_data *d = file->private_data;
-	loff_t pos = *ppos;
-	loff_t avail = d->pos;
 
-	if (pos < 0)
-		return -EINVAL;
-	if (pos >= avail)
-		return 0;
-	if (count > avail - pos)
-		count = avail - pos;
-
-	while (count) {
-		size_t len = 0;
-
-		len = min((int)count, (int)d->pos - (int)pos);
-		if (copy_to_user(buf, d->buf + pos, len))
-			return -EFAULT;
-		if (len == 0)
-			return -EINVAL;
-
-		buf += len;
-		pos += len;
-		count -= len;
-	}
-	count = pos - *ppos;
-	*ppos = pos;
-	return count;
+	return simple_read_from_buffer(buf, count, ppos, d->buf, d->pos);
 }
 
 static int dump_qp(int id, void *p, void *data)

