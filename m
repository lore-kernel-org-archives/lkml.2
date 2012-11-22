Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab2KVU3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:29:54 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:64859 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab2KVU3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:29:51 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Cc: wim@iguana.be, patches@linaro.org, Anthony.Olech@diasemi.com
Subject: [PATCH] watchdog: da9052: Fix invalid free of devm_ allocated data
Date: Thu, 22 Nov 2012 10:13:04 +0530
Message-Id: <1353559384-26570-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not required to free devm_ allocated data. Since kref_put
needs a valid release function, da9052_wdt_release_resources()
is not deleted.

Fixes following warning.
drivers/watchdog/da9052_wdt.c:59:1-6: WARNING: invalid free of
devm_ allocated data

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/watchdog/da9052_wdt.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
index f7abbae..20071de 100644
--- a/drivers/watchdog/da9052_wdt.c
+++ b/drivers/watchdog/da9052_wdt.c
@@ -53,10 +53,6 @@ static const struct {
 
 static void da9052_wdt_release_resources(struct kref *r)
 {
-	struct da9052_wdt_data *driver_data =
-		container_of(r, struct da9052_wdt_data, kref);
-
-	kfree(driver_data);
 }
 
 static int da9052_wdt_set_timeout(struct watchdog_device *wdt_dev,
-- 
1.7.4.1

