Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab0FRMrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 08:47:21 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40297 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549Ab0FRMrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 08:47:20 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 18 Jun 2010 14:48:09 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv6 10/11] USB: gadget: composite: added disconnect callback
In-reply-to: <7337838b49bb102126eb678d330d7853ee55c5c6.1276864406.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <72a1ab93557746c55fe75d844c69bcca7f7c5121.1276864406.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <20100617175221.GE3644@kroah.com>
 <2809a031d19ac6ef793d7fe343e225b8d80099c3.1276864406.git.m.nazarewicz@samsung.com>
 <f4efaf12033f1e402303b60555c26f3779ba4aa1.1276864406.git.m.nazarewicz@samsung.com>
 <f8062cc154f51fc2a0812cda14deea0678644af9.1276864406.git.m.nazarewicz@samsung.com>
 <7337838b49bb102126eb678d330d7853ee55c5c6.1276864406.git.m.nazarewicz@samsung.com>
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

