Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab1HBKhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:37:11 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59109 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab1HBKfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:35:15 -0400
From: Julia Lawall <julia@diku.dk>
To: Ohad Ben-Cohen <ohad@wizery.com>, trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/11] drivers/iommu/iommu.c: trivial: use BUG_ON
Date: Tue,  2 Aug 2011 12:34:59 +0200
Message-Id: <1312281304-11847-7-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1312281304-11847-1-git-send-email-julia@diku.dk>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use BUG_ON(x) rather than if(x) BUG();

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ identifier x; @@
-if (x) BUG();
+BUG_ON(x);

@@ identifier x; @@
-if (!x) BUG();
+BUG_ON(!x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/iommu/iommu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -27,8 +27,7 @@ static struct iommu_ops *iommu_ops;
 
 void register_iommu(struct iommu_ops *ops)
 {
-	if (iommu_ops)
-		BUG();
+	BUG_ON(iommu_ops);
 
 	iommu_ops = ops;
 }

