Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1HaUnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 16:43:41 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:55710 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab1HaUni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 16:43:38 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Steve Wise <swise@chelsio.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] RDMA/cxgb4: remove accidentally left mutex_unlock(&dev_mutex)
Date: Thu,  1 Sep 2011 00:43:30 +0400
Message-Id: <1314823410-12621-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch "RDMA/cxgb4: EEH errors can hang the driver" removes
mutex lock/unlock from c4iw_alloc() except for error path.
This patch removes the remained mutex_unlock(&dev_mutex).

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/infiniband/hw/cxgb4/device.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 40a13cc..35896ff 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -414,7 +414,6 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 
 	ret = c4iw_rdev_open(&devp->rdev);
 	if (ret) {
-		mutex_unlock(&dev_mutex);
 		printk(KERN_ERR MOD "Unable to open CXIO rdev err %d\n", ret);
 		ib_dealloc_device(&devp->ibdev);
 		return ERR_PTR(ret);
-- 
1.7.4.1

