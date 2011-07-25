Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1GYORT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:17:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:28728 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab1GYORP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 10:17:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,261,1309762800"; 
   d="scan'208";a="32009498"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] adp1653: check platform_data before usage
Date: Mon, 25 Jul 2011 17:16:41 +0300
Message-Id: <55316b63b7084f869d550fd600f29d2e0dfa862c.1311603384.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver requires platform_data to be present. That's why we need to check
and fail in case of the absence of necessary data.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/adp1653.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
index be7befd..8ad89ff 100644
--- a/drivers/media/video/adp1653.c
+++ b/drivers/media/video/adp1653.c
@@ -413,6 +413,10 @@ static int adp1653_probe(struct i2c_client *client,
 	struct adp1653_flash *flash;
 	int ret;
 
+	/* we couldn't work without platform data */
+	if (client->dev.platform_data == NULL)
+		return -ENODEV;
+
 	flash = kzalloc(sizeof(*flash), GFP_KERNEL);
 	if (flash == NULL)
 		return -ENOMEM;
-- 
1.7.5.4

