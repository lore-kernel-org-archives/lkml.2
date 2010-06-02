Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab0FBMqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:46:47 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57176 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab0FBMo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:44:59 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 02 Jun 2010 14:45:24 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv3 03/11] USB: gadget: f_fs: functionfs_add() renamed to
 functionfs_bind_config()
In-reply-to: <e4cb4e647e0ebc51956d6581cd930e3d32f29b99.1275481997.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <785f09f63fe30ba52ce15fd7cb3f5750aa279ab9.1275481997.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1275481997.git.mina86@mina86.com>
 <5e151207bced1e418bcfed136a871d2da47e417e.1275481997.git.mina86@mina86.com>
 <e4cb4e647e0ebc51956d6581cd930e3d32f29b99.1275481997.git.mina86@mina86.com>
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

