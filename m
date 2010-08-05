Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934616Ab0HEWZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:25:26 -0400
Received: from kroah.org ([198.145.64.141]:37732 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760869Ab0HEWY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/28] Driver core: use kmemdup in platform_device_add_resources
Date: Thu,  5 Aug 2010 15:23:59 -0700
Message-Id: <1281047058-23716-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

This makes platform_device_add_resources look like
platform_device_add_data.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 4d99c8b..26eb69d 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -191,13 +191,13 @@ int platform_device_add_resources(struct platform_device *pdev,
 {
 	struct resource *r;
 
-	r = kmalloc(sizeof(struct resource) * num, GFP_KERNEL);
+	r = kmemdup(res, sizeof(struct resource) * num, GFP_KERNEL);
 	if (r) {
-		memcpy(r, res, sizeof(struct resource) * num);
 		pdev->resource = r;
 		pdev->num_resources = num;
+		return 0;
 	}
-	return r ? 0 : -ENOMEM;
+	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(platform_device_add_resources);
 
-- 
1.7.2

