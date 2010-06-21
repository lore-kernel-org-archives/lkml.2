Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab0FUL42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 07:56:28 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36945 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab0FUL4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 07:56:25 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 21 Jun 2010 13:57:08 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv7 10/11] USB: gadget: composite: added disconnect callback
In-reply-to: <a5951faaeb541e04ed99e9cf901faa527d40fa43.1277119876.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <98f552c7e1dd2d68b6eb27675f7fa3f5b211c29e.1277119876.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <caa6546b6691e75a7248415a4d50d681e4f8705d.1277119876.git.m.nazarewicz@samsung.com>
 <63fcea8d575e5c032d111840bf8cd82cea1aaa59.1277119876.git.m.nazarewicz@samsung.com>
 <57cb6dca50e173774cdc0135c6a921fc006adc9e.1277119876.git.m.nazarewicz@samsung.com>
 <a5951faaeb541e04ed99e9cf901faa527d40fa43.1277119876.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a disconnect() callback to composite devices which
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

