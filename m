Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab2IDPL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:11:56 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:34934 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932460Ab2IDPKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:46 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 11:10:17 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4IgAQEFIw8BRhAgBQImAgJXBhOIEad7kmCBIZAMgRIDlVmJM4lM
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821825"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 12/16] Staging: ipack: Make ipack_driver_ops const.
Date: Tue,  4 Sep 2012 17:01:17 +0200
Message-Id: <1346770881-4723-13-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
References: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |    8 +++++---
 drivers/staging/ipack/ipack.h           |    2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index ed08864..7e1e6f7 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -28,7 +28,6 @@
 #define IP_OCTAL_ID_SPACE_VECTOR    0x41
 #define IP_OCTAL_NB_BLOCKS          4
 
-static struct ipack_driver driver;
 static const struct tty_operations ipoctal_fops;
 
 struct ipoctal {
@@ -846,15 +845,18 @@ static void ipoctal_remove(struct ipack_device *device)
 	}
 }
 
-static struct ipack_driver_ops ipoctal_drv_ops = {
+static const struct ipack_driver_ops ipoctal_drv_ops = {
 	.match = ipoctal_match,
 	.probe = ipoctal_probe,
 	.remove = ipoctal_remove,
 };
 
+static struct ipack_driver driver = {
+	.ops      = &ipoctal_drv_ops,
+};
+
 static int __init ipoctal_init(void)
 {
-	driver.ops = &ipoctal_drv_ops;
 	return ipack_driver_register(&driver, THIS_MODULE, KBUILD_MODNAME);
 }
 
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index a3cd559..e6e38e7 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -104,7 +104,7 @@ struct ipack_driver_ops {
 struct ipack_driver {
 	struct device_driver driver;
 	const struct ipack_device_id *id_table;
-	struct ipack_driver_ops *ops;
+	const struct ipack_driver_ops *ops;
 };
 
 /**
-- 
1.7.10.4

