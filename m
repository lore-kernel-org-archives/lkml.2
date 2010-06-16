Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521Ab0FPKJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:09:29 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57058 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab0FPKHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:07:23 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 16 Jun 2010 12:07:57 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv5 02/11] USB: gadget: f_mass_storage: fsg_add() renamed to
 fsg_bind_config()
In-reply-to: <7131891c93ac20a3360068e2f4b8fff0de7dfafb.1276681840.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <1cf0484e46e3b2b5ce0dea8cdc7396d4bfa977c5.1276681840.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <20100615185527.GA22803@kroah.com>
 <cover.1276681840.git.m.nazarewicz@samsung.com>
 <7131891c93ac20a3360068e2f4b8fff0de7dfafb.1276681840.git.m.nazarewicz@samsung.com>
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
index e68c00e..2b11e20 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -161,7 +161,7 @@ static int __init msg_do_config(struct usb_configuration *c)
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

