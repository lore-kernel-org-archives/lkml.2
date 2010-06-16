Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab0FPKHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:07:23 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34491 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab0FPKHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:07:21 -0400
Date: Wed, 16 Jun 2010 12:07:58 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv5 03/11] USB: gadget: f_fs: functionfs_add() renamed to
 functionfs_bind_config()
In-reply-to: <1cf0484e46e3b2b5ce0dea8cdc7396d4bfa977c5.1276681840.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <0022e21e1b622b3a54d1e55aed727e7e429c7c70.1276681840.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <20100615185527.GA22803@kroah.com>
 <cover.1276681840.git.m.nazarewicz@samsung.com>
 <7131891c93ac20a3360068e2f4b8fff0de7dfafb.1276681840.git.m.nazarewicz@samsung.com>
 <1cf0484e46e3b2b5ce0dea8cdc7396d4bfa977c5.1276681840.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FunctionFS had a bit unique name for function used to add it
to USB configuration.  Renamed as to match naming convention
of other functions.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/f_fs.c      |    6 +++---
 drivers/usb/gadget/g_ffs.c     |    2 +-
 include/linux/usb/functionfs.h |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index d69eccf..3fe120f 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1480,9 +1480,9 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 }
 
 
-static int functionfs_add(struct usb_composite_dev *cdev,
-			  struct usb_configuration *c,
-			  struct ffs_data *ffs)
+static int functionfs_bind_config(struct usb_composite_dev *cdev,
+				  struct usb_configuration *c,
+				  struct ffs_data *ffs)
 {
 	struct ffs_function *func;
 	int ret;
diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index 4b0e4a0..2f26470 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -388,7 +388,7 @@ static int __gfs_do_config(struct usb_configuration *c,
 			return ret;
 	}
 
-	ret = functionfs_add(c->cdev, c, gfs_ffs_data);
+	ret = functionfs_bind_config(c->cdev, c, gfs_ffs_data);
 	if (unlikely(ret < 0))
 		return ret;
 
diff --git a/include/linux/usb/functionfs.h b/include/linux/usb/functionfs.h
index a34a2a0..6f649c1 100644
--- a/include/linux/usb/functionfs.h
+++ b/include/linux/usb/functionfs.h
@@ -180,9 +180,9 @@ static int functionfs_bind(struct ffs_data *ffs, struct usb_composite_dev *cdev)
 static void functionfs_unbind(struct ffs_data *ffs)
 	__attribute__((nonnull));
 
-static int functionfs_add(struct usb_composite_dev *cdev,
-			  struct usb_configuration *c,
-			  struct ffs_data *ffs)
+static int functionfs_bind_config(struct usb_composite_dev *cdev,
+				  struct usb_configuration *c,
+				  struct ffs_data *ffs)
 	__attribute__((warn_unused_result, nonnull));
 
 
-- 
1.7.1

