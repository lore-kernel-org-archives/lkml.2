Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab0KLViX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:38:23 -0500
Received: from mail.perches.com ([173.55.12.10]:4999 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582Ab0KLViN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:38:13 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Ralph Campbell <infinipath@qlogic.com>, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] drivers/infiniband: Use printf extension %pR for struct resource
Date: Fri, 12 Nov 2010 13:37:55 -0800
Message-Id: <d12116b0a742471f5df94bd93a946b9171cce114.1289597644.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pR standardizes the struct resource output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/ipath/ipath_driver.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index 765f0fc..b33f045 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -530,9 +530,8 @@ static int __devinit ipath_init_one(struct pci_dev *pdev,
 	for (j = 0; j < 6; j++) {
 		if (!pdev->resource[j].start)
 			continue;
-		ipath_cdbg(VERBOSE, "BAR %d start %llx, end %llx, len %llx\n",
-			   j, (unsigned long long)pdev->resource[j].start,
-			   (unsigned long long)pdev->resource[j].end,
+		ipath_cdbg(VERBOSE, "BAR %d %pR, len %llx\n",
+			   j, &pdev->resource[j],
 			   (unsigned long long)pci_resource_len(pdev, j));
 	}
 
-- 
1.7.3.1.g432b3.dirty

