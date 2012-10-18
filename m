Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2JRKnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:43:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:50582 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab2JRKnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:43:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="207595223"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Keith Busch <keith.busch@intel.com>
Subject: [PATCH] NVMe: check the return of nvme_alloc_iod
Date: Thu, 18 Oct 2012 18:43:20 +0800
Message-Id: <1350557000-18825-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It maybe failed due to out of memory.

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Keith Busch <keith.busch@intel.com>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/block/nvme.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/block/nvme.c b/drivers/block/nvme.c
index 931769e..eb58978 100644
--- a/drivers/block/nvme.c
+++ b/drivers/block/nvme.c
@@ -1091,6 +1091,10 @@ static struct nvme_iod *nvme_map_user_pages(struct nvme_dev *dev, int write,
 	}
 
 	iod = nvme_alloc_iod(count, length, GFP_KERNEL);
+	if (!iod) {
+		err = -ENOMEM;
+		goto put_pages;
+	}
 	sg = iod->sg;
 	sg_init_table(sg, count);
 	for (i = 0; i < count; i++) {
-- 
1.7.7.6

