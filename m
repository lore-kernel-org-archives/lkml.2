Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab0FPKIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:08:23 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57058 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757661Ab0FPKH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:07:27 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 16 Jun 2010 12:08:05 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv5 10/11] USB: gadget: composite: addad disconnect callback
In-reply-to: <0de8ae564d9a562ee02bfb116b3a6bf0ff19ea3f.1276681840.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <42fc529dec5034b62c17d00791e4fe8b8d5f19ee.1276681840.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <20100615185527.GA22803@kroah.com>
 <cover.1276681840.git.m.nazarewicz@samsung.com>
 <7131891c93ac20a3360068e2f4b8fff0de7dfafb.1276681840.git.m.nazarewicz@samsung.com>
 <1cf0484e46e3b2b5ce0dea8cdc7396d4bfa977c5.1276681840.git.m.nazarewicz@samsung.com>
 <0022e21e1b622b3a54d1e55aed727e7e429c7c70.1276681840.git.m.nazarewicz@samsung.com>
 <45fc10256bd2374706e4153360427257d15804a9.1276681840.git.m.nazarewicz@samsung.com>
 <bb0d9f73c7caae31c0bc291d3dfce44a2f6a3736.1276681840.git.m.nazarewicz@samsung.com>
 <c7fbb2934e18cfd25df3e00a548ac33e5b0a7353.1276681840.git.m.nazarewicz@samsung.com>
 <9f32ae2ab133d27642ac4c1e81777b1e34a0c1a1.1276681840.git.m.nazarewicz@samsung.com>
 <c4143e7fdd0fc61f05118c30a0a9edbbc0a97db4.1276681840.git.m.nazarewicz@samsung.com>
 <0de8ae564d9a562ee02bfb116b3a6bf0ff19ea3f.1276681840.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a disconnect() callback to compasite devices which
is called by composite glue when its disconnect callback
is called by gadget.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/gadget/composite.c |    2 ++
 include/linux/usb/composite.h  |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 125167e..e483f80 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -956,6 +956,8 @@ static void composite_disconnect(struct usb_gadget *gadget)
 	spin_lock_irqsave(&cdev->lock, flags);
 	if (cdev->config)
 		reset_config(cdev);
+	if (composite->disconnect)
+		composite->disconnect(cdev);
 	spin_unlock_irqrestore(&cdev->lock, flags);
 }
 
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index f378075..890bc14 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -276,6 +276,8 @@ struct usb_composite_driver {
 	int			(*bind)(struct usb_composite_dev *);
 	int			(*unbind)(struct usb_composite_dev *);
 
+	void			(*disconnect)(struct usb_composite_dev *);
+
 	/* global suspend hooks */
 	void			(*suspend)(struct usb_composite_dev *);
 	void			(*resume)(struct usb_composite_dev *);
-- 
1.7.1

