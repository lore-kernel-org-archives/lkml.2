Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab2KPG5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:57:43 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:59325 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2KPG5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:57:40 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 13/14] misc: tsl2550: Remove redundant check on unsigned variable
Date: Fri, 16 Nov 2012 12:20:45 +0530
Message-Id: <1353048646-10935-14-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to check whether unsigned variable is less than 0.

CC: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/misc/tsl2550.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/tsl2550.c b/drivers/misc/tsl2550.c
index 0beb298..0438569 100644
--- a/drivers/misc/tsl2550.c
+++ b/drivers/misc/tsl2550.c
@@ -204,7 +204,7 @@ static ssize_t tsl2550_store_power_state(struct device *dev,
 	unsigned long val = simple_strtoul(buf, NULL, 10);
 	int ret;
 
-	if (val < 0 || val > 1)
+	if (val > 1)
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);
@@ -236,7 +236,7 @@ static ssize_t tsl2550_store_operating_mode(struct device *dev,
 	unsigned long val = simple_strtoul(buf, NULL, 10);
 	int ret;
 
-	if (val < 0 || val > 1)
+	if (val > 1)
 		return -EINVAL;
 
 	if (data->power_state == 0)
-- 
1.7.4.1

