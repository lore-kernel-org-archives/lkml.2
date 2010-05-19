Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab0ESJF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:05:58 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44956 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab0ESJEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:04:04 -0400
Date: Wed, 19 May 2010 11:04:16 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 2/8] USB: gadget: f_mass_storage: fsg_add() renamed to
 fsg_bind_config()
In-reply-to: <6577770c2519efd2193ed6454dcd895472bba404.1274187425.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <f888a55a4bd4d631c0d36e8463bb5bbb8e9d7a3d.1274187425.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1274187425.git.m.nazarewicz@samsung.com>
 <6577770c2519efd2193ed6454dcd895472bba404.1274187425.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mass Storage Function had a bit unique name for function
used to add it to USB configuration.  Renamed as to match
naming convention of other functions.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/f_mass_storage.c |   13 ++++++++++---
 drivers/usb/gadget/mass_storage.c   |    2 +-
 drivers/usb/gadget/multi.c          |    4 ++--
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 7d05a0b..072cbf9 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -3023,9 +3023,9 @@ static struct usb_gadget_strings *fsg_strings_array[] = {
 	NULL,
 };
 
-static int fsg_add(struct usb_composite_dev *cdev,
-		   struct usb_configuration *c,
-		   struct fsg_common *common)
+static int fsg_bind_config(struct usb_composite_dev *cdev,
+			   struct usb_configuration *c,
+			   struct fsg_common *common)
 {
 	struct fsg_dev *fsg;
 	int rc;
@@ -3072,6 +3072,13 @@ error_free_fsg:
 	return rc;
 }
 
+static inline int __deprecated __maybe_unused
+fsg_add(struct usb_composite_dev *cdev,
+	struct usb_configuration *c,
+	struct fsg_common *common)
+{
+	return fsg_bind_config(cdev, c, common);
+}
 
 
 /************************* Module parameters *************************/
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index a3349f2..d6975f4 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -159,7 +159,7 @@ static int __init msg_do_config(struct usb_configuration *c)
 	if (IS_ERR(retp))
 		return PTR_ERR(retp);
 
-	ret = fsg_add(c->cdev, c, &common);
+	ret = fsg_bind_config(c->cdev, c, &common);
 	fsg_common_put(&common);
 	return ret;
 }
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index a930d7f..d3d3140 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -172,7 +172,7 @@ static int __init rndis_do_config(struct usb_configuration *c)
 	if (ret < 0)
 		return ret;
 
-	ret = fsg_add(c->cdev, c, fsg_common);
+	ret = fsg_bind_config(c->cdev, c, fsg_common);
 	if (ret < 0)
 		return ret;
 
@@ -208,7 +208,7 @@ static int __init cdc_do_config(struct usb_configuration *c)
 	if (ret < 0)
 		return ret;
 
-	ret = fsg_add(c->cdev, c, fsg_common);
+	ret = fsg_bind_config(c->cdev, c, fsg_common);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.1

