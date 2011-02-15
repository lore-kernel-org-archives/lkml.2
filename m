Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab1BOWZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 17:25:54 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48965 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313Ab1BOWZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 17:25:41 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] mfd-core: remove driver_data field from mfd_cell
Date: Tue, 15 Feb 2011 14:25:29 -0800
Message-Id: <1297808729-21110-10-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297808729-21110-1-git-send-email-dilinger@queued.net>
References: <1297808729-21110-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users of this have now been switched over to using mfd_data;
it can go away now.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/mfd-core.c   |    1 -
 include/linux/mfd/core.h |    3 ---
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 21a39dc..01115f6 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -37,7 +37,6 @@ static int mfd_add_device(struct device *parent, int id,
 		goto fail_device;
 
 	pdev->dev.parent = parent;
-	platform_set_drvdata(pdev, cell->driver_data);
 
 	ret = platform_device_add_data(pdev, cell, sizeof(*cell));
 	if (ret)
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index f317fe4..71cd1f9 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -30,9 +30,6 @@ struct mfd_cell {
 	int			(*suspend)(struct platform_device *dev);
 	int			(*resume)(struct platform_device *dev);
 
-	/* driver-specific data for MFD-aware "cell" drivers */
-	void			*driver_data;
-
 	/* mfd_data can be used to pass data to client drivers */
 	void			*mfd_data;
 
-- 
1.7.2.3

