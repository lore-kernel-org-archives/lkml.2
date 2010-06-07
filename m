Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0FGMmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:42:45 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56223 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab0FGMjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:39:23 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 07 Jun 2010 14:39:50 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv4 03/13] USB: gadget: f_fs: functionfs_add() renamed to
 functionfs_bind_config()
In-reply-to: <df04b95ee38845c46fa735c3e53768f57f94f748.1275906835.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org, linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <897d8ae37d4fa2fdb7dad8787add81c720581313.1275906835.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1275906835.git.m.nazarewicz@samsung.com>
 <72866638a69b660e3eb534330937955d15dde4de.1275906835.git.m.nazarewicz@samsung.com>
 <df04b95ee38845c46fa735c3e53768f57f94f748.1275906835.git.m.nazarewicz@samsung.com>
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

