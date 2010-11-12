Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab0KLVpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:45:12 -0500
Received: from mail.perches.com ([173.55.12.10]:1028 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932538Ab0KLViM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:38:12 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/14] drivers/dma/ppc4xx: Use printf extension %pR for struct resource
Date: Fri, 12 Nov 2010 13:37:54 -0800
Message-Id: <f66de3cc7e0964d9066d991c4b4eba981ba3d752.1289597644.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pR standardizes the struct resource output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/dma/ppc4xx/adma.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index 0d58a4a..cef5845 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -4449,9 +4449,8 @@ static int __devinit ppc440spe_adma_probe(struct platform_device *ofdev,
 
 	if (!request_mem_region(res.start, resource_size(&res),
 				dev_driver_string(&ofdev->dev))) {
-		dev_err(&ofdev->dev, "failed to request memory region "
-			"(0x%016llx-0x%016llx)\n",
-			(u64)res.start, (u64)res.end);
+		dev_err(&ofdev->dev, "failed to request memory region %pR\n",
+			&res);
 		initcode = PPC_ADMA_INIT_MEMREG;
 		ret = -EBUSY;
 		goto out;
-- 
1.7.3.1.g432b3.dirty

