Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621Ab0FRPEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 11:04:11 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:49744 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab0FRPD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 11:03:57 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 18 Jun 2010 17:04:20 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv6.1 10/11] USB: gadget: composite: added disconnect callback
To: linux-usb@vger.kernel.org
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg KH <greg@kroah.com>, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <4c4ec019ac1c68d08e68c7a5eaf1afbbb2a7ccd0.1276871819.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
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
> Michal Nazarewicz wrote:
>> Added a disconnect() callback to compasite devices which

Sergei Shtylyov wrote:
> Your subject has "addad" -- probably instead of "added".
>
> Also, there's typo in the first line: "compasite"...

Argh...  I promise to use spell checker for all commit messages from
now on...  I hope this will catch most of the typos.


Damn...  Looking how I keep sending .1 patches I feel like my way of
submitting code is failing.  Sorry about all the mess guys, hope you
will make sens out of all this. ;) I have no idea how you manage all
those patches especially with me spamming the list. ;)


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

