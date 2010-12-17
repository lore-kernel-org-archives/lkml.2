Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0LQP7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:59:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374Ab0LQP7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:59:44 -0500
Message-ID: <4D0B88E5.4040005@redhat.com>
Date: Fri, 17 Dec 2010 16:59:33 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nitin Gupta <ngupta@vflare.org>
Subject: [PATCH 1/4] Staging: zram: make ZRAM depends on SYSFS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We can not configure zram device without sysfs anyway, so make zram
depends on it.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 Kconfig      |    2 +-
 zram_drv.c   |    4 ----
 zram_sysfs.c |    4 ----
 3 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
index da079f8..d3982e6 100644
--- a/drivers/staging/zram/Kconfig
+++ b/drivers/staging/zram/Kconfig
@@ -1,6 +1,6 @@
 config ZRAM
 	tristate "Compressed RAM block device support"
-	depends on BLOCK
+	depends on BLOCK && SYSFS
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	default n
diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 8c3c057..d649b3e 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -633,14 +633,12 @@ static int create_device(struct zram *zram, int device_id)
 
 	add_disk(zram->disk);
 
-#ifdef CONFIG_SYSFS
 	ret = sysfs_create_group(&disk_to_dev(zram->disk)->kobj,
 				&zram_disk_attr_group);
 	if (ret < 0) {
 		pr_warning("Error creating sysfs group");
 		goto out;
 	}
-#endif
 
 	zram->init_done = 0;
 
@@ -650,10 +648,8 @@ out:
 
 static void destroy_device(struct zram *zram)
 {
-#ifdef CONFIG_SYSFS
 	sysfs_remove_group(&disk_to_dev(zram->disk)->kobj,
 			&zram_disk_attr_group);
-#endif
 
 	if (zram->disk) {
 		del_gendisk(zram->disk);
diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index 6b3cf00..ad62db2 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -17,8 +17,6 @@
 
 #include "zram_drv.h"
 
-#ifdef CONFIG_SYSFS
-
 static u64 zram_stat64_read(struct zram *zram, u64 *v)
 {
 	u64 val;
@@ -220,5 +218,3 @@ static struct attribute *zram_disk_attrs[] = {
 struct attribute_group zram_disk_attr_group = {
 	.attrs = zram_disk_attrs,
 };
-
-#endif	/* CONFIG_SYSFS */
