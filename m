Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab0LCNoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 08:44:19 -0500
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:38627 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab0LCNoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 08:44:18 -0500
Subject: [PATCH] staging/vme/vme_user: use __dev{init,
	exit} for .probe and .remove
To: Greg KH <greg@kroah.com>
From: Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 03 Dec 2010 13:44:15 +0000
Message-ID: <20101203134414.10275.22271.stgit@ES-BJ21R4J>
In-Reply-To: <1288055476-19438-23-git-send-email-cota@braap.org>
References: <1288055476-19438-23-git-send-email-cota@braap.org>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Signed-off-by: Emilio G. Cota <cota@braap.org>
[martyn.welch@ge.com: Fixed checkpatch line length warnings]
Signed-off-by: Martyn Welch <martyn.welch@ge.com>
---

 drivers/staging/vme/devices/vme_user.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)


diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index dc7175b..db445ed 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -135,8 +135,8 @@ static ssize_t vme_user_write(struct file *, const char __user *, size_t,
 static loff_t vme_user_llseek(struct file *, loff_t, int);
 static long vme_user_unlocked_ioctl(struct file *, unsigned int, unsigned long);
 
-static int __init vme_user_probe(struct device *, int, int);
-static int __exit vme_user_remove(struct device *, int, int);
+static int __devinit vme_user_probe(struct device *, int, int);
+static int __devexit vme_user_remove(struct device *, int, int);
 
 static struct file_operations vme_user_fops = {
 	.open = vme_user_open,
@@ -596,7 +596,7 @@ static void buf_unalloc(int num)
 static struct vme_driver vme_user_driver = {
 	.name = driver_name,
 	.probe = vme_user_probe,
-	.remove = vme_user_remove,
+	.remove = __devexit_p(vme_user_remove),
 };
 
 
@@ -666,7 +666,8 @@ err_nocard:
  * as practical. We will therefore reserve the buffers and request the images
  * here so that we don't have to do it later.
  */
-static int __init vme_user_probe(struct device *dev, int cur_bus, int cur_slot)
+static int __devinit vme_user_probe(struct device *dev, int cur_bus,
+	int cur_slot)
 {
 	int i, err;
 	char name[12];
@@ -841,7 +842,8 @@ err_dev:
 	return err;
 }
 
-static int __exit vme_user_remove(struct device *dev, int cur_bus, int cur_slot)
+static int __devexit vme_user_remove(struct device *dev, int cur_bus,
+	int cur_slot)
 {
 	int i;
 


--
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
