Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab0FBMpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:45:14 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57176 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847Ab0FBMpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:45:00 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 02 Jun 2010 14:45:30 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv3 09/11] USB: gadget: composite: addad disconnect callback
In-reply-to: <762e84e05c338446cb4c51797b4773d3db321179.1275481997.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <3e06c1fa8a9bec733305e8e6e7fc9aa72fd840b2.1275481997.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1275481997.git.mina86@mina86.com>
 <5e151207bced1e418bcfed136a871d2da47e417e.1275481997.git.mina86@mina86.com>
 <e4cb4e647e0ebc51956d6581cd930e3d32f29b99.1275481997.git.mina86@mina86.com>
 <785f09f63fe30ba52ce15fd7cb3f5750aa279ab9.1275481997.git.mina86@mina86.com>
 <5492eaf531c8a59c7c188b9e341572c9cdaed5f2.1275481997.git.mina86@mina86.com>
 <17b54e2cc00a7f730483401f06c79c781491dc62.1275481997.git.mina86@mina86.com>
 <381c3f8318e39caaffa1ecfdf5e3cf13ed59cd27.1275481997.git.mina86@mina86.com>
 <c8725442e3c5b8c7be2cc381ed69a3dc0283ebe1.1275481997.git.mina86@mina86.com>
 <762e84e05c338446cb4c51797b4773d3db321179.1275481997.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a disconnect() callback to compasite devices which
is called by composite glue when its disconnect callback
is called by gadget.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
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

