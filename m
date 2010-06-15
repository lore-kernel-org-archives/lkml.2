Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab0FOIsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:48:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40217 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab0FOIsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:48:15 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Magnus Damm <damm@opensource.se>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Mundt <lethal@linux-sh.org>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 1/2] Driver core: use kmemdup in platform_device_add_resources
Date: Tue, 15 Jun 2010 10:47:55 +0200
Message-Id: <1276591677-4678-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes platform_device_add_resources look like
platform_device_add_data.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
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
1.7.1

