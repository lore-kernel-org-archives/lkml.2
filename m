Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab1IARzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 13:55:42 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44695 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901Ab1IARzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 13:55:41 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] drivers/amba/bus.c: Don't perform extra matching when any one fails
Date: Thu,  1 Sep 2011 23:25:15 +0530
Message-Id: <1314899715-20311-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If any one operation fails, then r anyways gets set to 0, which will
cause the device to not match the find_data.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 drivers/amba/bus.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index d74926e..af2e0a1 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -699,10 +699,12 @@ static int amba_find_match(struct device *dev, void *data)
 	int r;
 
 	r = (pcdev->periphid & d->mask) == d->id;
-	if (d->parent)
-		r &= d->parent == dev->parent;
-	if (d->busid)
-		r &= strcmp(dev_name(dev), d->busid) == 0;
+	if (r) {
+		if (d->parent)
+			r &= d->parent == dev->parent;
+		if (r && d->busid)
+			r &= strcmp(dev_name(dev), d->busid) == 0;
+	}
 
 	if (r) {
 		get_device(dev);
-- 
1.7.4.1

