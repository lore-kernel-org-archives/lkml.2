Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab1G0H6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 03:58:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:60582 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab1G0H6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 03:58:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,275,1309762800"; 
   d="scan'208";a="31953067"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] adp1653: check error code of adp1653_init_controls
Date: Wed, 27 Jul 2011 10:58:02 +0300
Message-Id: <1b238cd98e03909bc4955113ffbe7e0c9f0db4f8.1311753459.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Potentially the adp1653_init_controls could return an error. In our case the
error was ignored, meanwhile it means incorrect initialization of V4L2
controls.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/adp1653.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
index 8ad89ff..3379e6d 100644
--- a/drivers/media/video/adp1653.c
+++ b/drivers/media/video/adp1653.c
@@ -429,7 +429,11 @@ static int adp1653_probe(struct i2c_client *client,
 	flash->subdev.internal_ops = &adp1653_internal_ops;
 	flash->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
-	adp1653_init_controls(flash);
+	ret = adp1653_init_controls(flash);
+	if (ret) {
+		kfree(flash);
+		return ret;
+	}
 
 	ret = media_entity_init(&flash->subdev.entity, 0, NULL, 0);
 	if (ret < 0)
-- 
1.7.5.4

