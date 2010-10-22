Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0JVHQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:16:36 -0400
Received: from beaker.bytemark.co.uk ([80.68.81.2]:49494 "EHLO
	beaker.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab0JVHQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:16:35 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: [PATCH 22/30] staging/vme/vme_user: use __dev{init,exit} for .probe and .remove
Date: Fri, 22 Oct 2010 02:36:44 -0400
Message-Id: <1287729412-24356-23-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287729412-24356-1-git-send-email-cota@braap.org>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/devices/vme_user.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index a7b97be..5def455 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -134,8 +134,8 @@ static ssize_t vme_user_write(struct file *, const char __user *, size_t, loff_t
 static loff_t vme_user_llseek(struct file *, loff_t, int);
 static long vme_user_unlocked_ioctl(struct file *, unsigned int, unsigned long);
 
-static int __init vme_user_probe(struct device *, int, int);
-static int __exit vme_user_remove(struct device *, int, int);
+static int __devinit vme_user_probe(struct device *, int, int);
+static int __devexit vme_user_remove(struct device *, int, int);
 
 static struct file_operations vme_user_fops = {
 	.open = vme_user_open,
@@ -593,7 +593,7 @@ static void buf_unalloc(int num)
 static struct vme_driver vme_user_driver = {
 	.name = driver_name,
 	.probe = vme_user_probe,
-	.remove = vme_user_remove,
+	.remove = __devexit_p(vme_user_remove),
 };
 
 
@@ -663,7 +663,7 @@ err_nocard:
  * as practical. We will therefore reserve the buffers and request the images
  * here so that we don't have to do it later.
  */
-static int __init vme_user_probe(struct device *dev, int cur_bus, int cur_slot)
+static int __devinit vme_user_probe(struct device *dev, int cur_bus, int cur_slot)
 {
 	int i, err;
 	char name[12];
@@ -838,7 +838,7 @@ err_dev:
 	return err;
 }
 
-static int __exit vme_user_remove(struct device *dev, int cur_bus, int cur_slot)
+static int __devexit vme_user_remove(struct device *dev, int cur_bus, int cur_slot)
 {
 	int i;
 
-- 
1.7.1

