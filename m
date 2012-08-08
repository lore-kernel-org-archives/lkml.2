Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab2HHGK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:10:59 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58410 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab2HHGKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:10:54 -0400
X-AuditID: 9c93016f-b7b08ae00000790d-00-502202eaa029
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 6/7] zram: promote zram from staging
Date: Wed,  8 Aug 2012 15:12:19 +0900
Message-Id: <1344406340-14128-7-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344406340-14128-1-git-send-email-minchan@kernel.org>
References: <1344406340-14128-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's time to promote zram from staging because zram is in staging
for a long time and is improved by many contributors so code is
very clean. Most important issue, zram's dependency with x86 is
solved by making zsmalloc portable. In addition, many embedded
product uses zram in real practive so I think there is no reason
to prevent promotion now.

Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/Kconfig                        |    1 +
 drivers/block/Makefile                       |    1 +
 drivers/{staging => block}/zram/Kconfig      |    0
 drivers/{staging => block}/zram/Makefile     |    0
 drivers/{staging => block}/zram/zram.txt     |    0
 drivers/{staging => block}/zram/zram_drv.c   |    0
 drivers/{staging => block}/zram/zram_drv.h   |    0
 drivers/{staging => block}/zram/zram_sysfs.c |    0
 drivers/staging/Kconfig                      |    2 --
 drivers/staging/Makefile                     |    1 -
 10 files changed, 2 insertions(+), 3 deletions(-)
 rename drivers/{staging => block}/zram/Kconfig (100%)
 rename drivers/{staging => block}/zram/Makefile (100%)
 rename drivers/{staging => block}/zram/zram.txt (100%)
 rename drivers/{staging => block}/zram/zram_drv.c (100%)
 rename drivers/{staging => block}/zram/zram_drv.h (100%)
 rename drivers/{staging => block}/zram/zram_sysfs.c (100%)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index a796407..4277454 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -289,6 +289,7 @@ config BLK_DEV_CRYPTOLOOP
 	  cryptoloop device.
 
 source "drivers/block/drbd/Kconfig"
+source "drivers/block/zram/Kconfig"
 
 config BLK_DEV_NBD
 	tristate "Network block device support"
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 5b79505..951ba69 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_BLK_DEV_UMEM)	+= umem.o
 obj-$(CONFIG_BLK_DEV_NBD)	+= nbd.o
 obj-$(CONFIG_BLK_DEV_CRYPTOLOOP) += cryptoloop.o
 obj-$(CONFIG_VIRTIO_BLK)	+= virtio_blk.o
+obj-$(CONFIG_ZRAM)	+= zram/
 
 obj-$(CONFIG_VIODASD)		+= viodasd.o
 obj-$(CONFIG_BLK_DEV_SX8)	+= sx8.o
diff --git a/drivers/staging/zram/Kconfig b/drivers/block/zram/Kconfig
similarity index 100%
rename from drivers/staging/zram/Kconfig
rename to drivers/block/zram/Kconfig
diff --git a/drivers/staging/zram/Makefile b/drivers/block/zram/Makefile
similarity index 100%
rename from drivers/staging/zram/Makefile
rename to drivers/block/zram/Makefile
diff --git a/drivers/staging/zram/zram.txt b/drivers/block/zram/zram.txt
similarity index 100%
rename from drivers/staging/zram/zram.txt
rename to drivers/block/zram/zram.txt
diff --git a/drivers/staging/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
similarity index 100%
rename from drivers/staging/zram/zram_drv.c
rename to drivers/block/zram/zram_drv.c
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
similarity index 100%
rename from drivers/staging/zram/zram_drv.h
rename to drivers/block/zram/zram_drv.h
diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/block/zram/zram_sysfs.c
similarity index 100%
rename from drivers/staging/zram/zram_sysfs.c
rename to drivers/block/zram/zram_sysfs.c
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index b7f7bc7..1a628eb 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -74,8 +74,6 @@ source "drivers/staging/sep/Kconfig"
 
 source "drivers/staging/iio/Kconfig"
 
-source "drivers/staging/zram/Kconfig"
-
 source "drivers/staging/zcache/Kconfig"
 
 source "drivers/staging/wlags49_h2/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index ad74bee..ed8889f 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -32,7 +32,6 @@ obj-$(CONFIG_VME_BUS)		+= vme/
 obj-$(CONFIG_IPACK_BUS)		+= ipack/
 obj-$(CONFIG_DX_SEP)            += sep/
 obj-$(CONFIG_IIO)		+= iio/
-obj-$(CONFIG_ZRAM)		+= zram/
 obj-$(CONFIG_ZCACHE)		+= zcache/
 obj-$(CONFIG_WLAGS49_H2)	+= wlags49_h2/
 obj-$(CONFIG_WLAGS49_H25)	+= wlags49_h25/
-- 
1.7.9.5

