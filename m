Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab0KLVjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:39:33 -0500
Received: from mail.perches.com ([173.55.12.10]:1050 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932863Ab0KLViQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:38:16 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Wolfgang Grandegger <wg@grandegger.com>, socketcan-core@lists.berlios.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] drivers/net/can/sja1000: Use printf extension %pR for struct resource
Date: Fri, 12 Nov 2010 13:37:59 -0800
Message-Id: <199bf35f52ea48bef79d4b40b504b0c85dca6fad.1289597644.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pR standardizes the struct resource output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/can/sja1000/sja1000_of_platform.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000_of_platform.c b/drivers/net/can/sja1000/sja1000_of_platform.c
index 5bfccfd..09c3e9d 100644
--- a/drivers/net/can/sja1000/sja1000_of_platform.c
+++ b/drivers/net/can/sja1000/sja1000_of_platform.c
@@ -107,17 +107,13 @@ static int __devinit sja1000_ofp_probe(struct platform_device *ofdev,
 	res_size = resource_size(&res);
 
 	if (!request_mem_region(res.start, res_size, DRV_NAME)) {
-		dev_err(&ofdev->dev, "couldn't request %#llx..%#llx\n",
-			(unsigned long long)res.start,
-			(unsigned long long)res.end);
+		dev_err(&ofdev->dev, "couldn't request %pR\n", &res);
 		return -EBUSY;
 	}
 
 	base = ioremap_nocache(res.start, res_size);
 	if (!base) {
-		dev_err(&ofdev->dev, "couldn't ioremap %#llx..%#llx\n",
-			(unsigned long long)res.start,
-			(unsigned long long)res.end);
+		dev_err(&ofdev->dev, "couldn't ioremap %pR\n", &res);
 		err = -ENOMEM;
 		goto exit_release_mem;
 	}
-- 
1.7.3.1.g432b3.dirty

