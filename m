Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab2DIIbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:31:12 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42978 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab2DIIbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:31:10 -0400
From: zwu.kernel@gmail.com
To: linux-kernel@vger.kernel.org
Cc: mst@redhat.com, stefanha@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH] vhost_test: fix compile breakage
Date: Mon,  9 Apr 2012 16:30:56 +0800
Message-Id: <1333960256-7491-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040908-7408-0000-0000-0000040EDC4F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

The arguments of vhost_dev_cleanup has been changed. So test.c need to be changed accordingly.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 drivers/vhost/test.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index fc9a1d7..3de00d9 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -155,7 +155,7 @@ static int vhost_test_release(struct inode *inode, struct file *f)
 
 	vhost_test_stop(n, &private);
 	vhost_test_flush(n);
-	vhost_dev_cleanup(&n->dev);
+	vhost_dev_cleanup(&n->dev, false);
 	/* We do an extra flush before freeing memory,
 	 * since jobs can re-queue themselves. */
 	vhost_test_flush(n);
-- 
1.7.6

