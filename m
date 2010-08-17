Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab0HQROF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:14:05 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:24568 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255Ab0HQROB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:14:01 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=ycAbO7DtjP4A:10 a=VphdPIyG4kEA:10 a=dnsDqYgvY1eI8xxSV9Tekg==:17
 a=XZjFkfzufRU34aLV278A:9 a=7nlJcrArERUdgt-k3d7gnUdspEoA:4
 a=swgA7G9SNX3-Z-BJ:21 a=6h4h_qrny7eEAm3z:21
From: Graeme Smecher <graeme.smecher@mail.mcgill.ca>
To: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Cc: Graeme Smecher <graeme.smecher@mail.mcgill.ca>
Subject: [PATCH] Include missing headers for of_address_to_resource() in MTD and SysACE drivers
Date: Tue, 17 Aug 2010 10:13:44 -0700
Message-Id: <1282065224-28673-1-git-send-email-graeme.smecher@mail.mcgill.ca>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers for Xilinx' SystemACE and physically mapped MTDs were missing
prototypes for of_address_to_resource(). This patch adds the necessary
headers.

signed-off-by: Graeme Smecher <graeme.smecher@mail.mcgill.ca>
---
 drivers/block/xsysace.c       |    1 +
 drivers/mtd/maps/physmap_of.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 2982b3e..fa71ba5 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -96,6 +96,7 @@
 #if defined(CONFIG_OF)
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
+#include <linux/of_address.h>
 #endif
 
 MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
index 00af55d..07b13e8 100644
--- a/drivers/mtd/maps/physmap_of.c
+++ b/drivers/mtd/maps/physmap_of.c
@@ -23,6 +23,7 @@
 #include <linux/mtd/concat.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/of_address.h>
 #include <linux/slab.h>
 
 struct of_flash_list {
-- 
1.7.1

