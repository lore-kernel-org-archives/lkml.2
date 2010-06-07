Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab0FGMmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:42:43 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35000 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab0FGMjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:39:23 -0400
Date: Mon, 07 Jun 2010 14:39:58 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv4 11/13] USB: gadget: composite: addad disconnect callback
In-reply-to: <b2b534da1e741bd0438e5e13df65aa7e2be72a7c.1275906835.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org, linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <6999e11de09e1f7f1091ee43882a8fc75bf2aab3.1275906835.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1275906835.git.m.nazarewicz@samsung.com>
 <72866638a69b660e3eb534330937955d15dde4de.1275906835.git.m.nazarewicz@samsung.com>
 <df04b95ee38845c46fa735c3e53768f57f94f748.1275906835.git.m.nazarewicz@samsung.com>
 <897d8ae37d4fa2fdb7dad8787add81c720581313.1275906835.git.m.nazarewicz@samsung.com>
 <b34cbaab37bf0590cb254a03478c5297bc4a1723.1275906835.git.m.nazarewicz@samsung.com>
 <7781ec0d22fa9dde7afbd3bf915af1a592780938.1275906835.git.m.nazarewicz@samsung.com>
 <871680934027e59f08ad63399a5923960147d313.1275906835.git.m.nazarewicz@samsung.com>
 <9e21e4f5440d2a2fcfa11bca18e62c713317b330.1275906835.git.m.nazarewicz@samsung.com>
 <61c7dcd3597ed56ec1caa5bcb66bf9bc1b09fb66.1275906835.git.m.nazarewicz@samsung.com>
 <9fe3db6d72e8376ece39bbe4f5ac9c8cd863af4c.1275906835.git.m.nazarewicz@samsung.com>
 <b2b534da1e741bd0438e5e13df65aa7e2be72a7c.1275906835.git.m.nazarewicz@samsung.com>
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

