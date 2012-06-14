Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab2FNGjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 02:39:09 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:47806 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750986Ab2FNGjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 02:39:07 -0400
From: ning.n.jiang@gmail.com
To: rjw@sisk.pl, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Ning Jiang <ning.n.jiang@gmail.com>
Subject: [PATCH] PM: Deprecate suspend/resume in device_driver
Date: Thu, 14 Jun 2012 14:42:17 +0800
Message-Id: <1339656138-28060-1-git-send-email-ning.n.jiang@gmail.com>
X-Mailer: git-send-email 1.7.1
X-OriginalArrivalTime: 14 Jun 2012 06:37:45.0120 (UTC) FILETIME=[34DC9200:01CD49F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ning Jiang <ning.n.jiang@gmail.com>

Make suspend/resume callbacks in device_driver deprecated and scheduled
for removal since they are not used in PM core anymore.

Legacy drivers who still use them need to move suspend/resume callbacks
to dev_pm_ops.

Signed-off-by: Ning Jiang <ning.n.jiang@gmail.com>
---
 include/linux/device.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index e04f577..884d9a6 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -226,8 +226,8 @@ struct device_driver {
 	int (*probe) (struct device *dev);
 	int (*remove) (struct device *dev);
 	void (*shutdown) (struct device *dev);
-	int (*suspend) (struct device *dev, pm_message_t state);
-	int (*resume) (struct device *dev);
+	int (*suspend) (struct device *dev, pm_message_t state) __deprecated;
+	int (*resume) (struct device *dev) __deprecated;
 	const struct attribute_group **groups;
 
 	const struct dev_pm_ops *pm;
-- 
1.7.1

