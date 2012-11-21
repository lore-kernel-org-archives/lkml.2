Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab2KUKB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:01:56 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49082 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab2KUKBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:01:52 -0500
From: "Michael L. Hobbs" <rizean@gmail.com>
To: abelay@mit.edu
Cc: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        "Michael L. Hobbs" <rizean@gmail.com>
Subject: [PATCH] drivers/pnp: fixed coding style on numerious lines.
Date: Wed, 21 Nov 2012 19:01:19 +0900
Message-Id: <1353492079-25587-1-git-send-email-rizean@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Michael L. Hobbs <rizean@gmail.com>
References: <Michael L. Hobbs <rizean@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style on numerious lines.

Signed-off-by: Michael L. Hobbs <rizean@gmail.com>
---
 drivers/pnp/card.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/pnp/card.c b/drivers/pnp/card.c
index bc00693..400568a 100644
--- a/drivers/pnp/card.c
+++ b/drivers/pnp/card.c
@@ -152,7 +152,8 @@ static void pnp_release_card(struct device *dmdev)
 	kfree(card);
 }
 
-struct pnp_card *pnp_alloc_card(struct pnp_protocol *protocol, int id, char *pnpid)
+struct pnp_card *pnp_alloc_card(struct pnp_protocol *protocol,
+				 int id, char *pnpid)
 {
 	struct pnp_card *card;
 	struct pnp_id *dev_id;
@@ -165,7 +166,8 @@ struct pnp_card *pnp_alloc_card(struct pnp_protocol *protocol, int id, char *pnp
 	card->number = id;
 
 	card->dev.parent = &card->protocol->dev;
-	dev_set_name(&card->dev, "%02x:%02x", card->protocol->number, card->number);
+	dev_set_name(&card->dev, "%02x:%02x", card->protocol->number,
+		     card->number);
 
 	card->dev.coherent_dma_mask = DMA_BIT_MASK(24);
 	card->dev.dma_mask = &card->dev.coherent_dma_mask;
@@ -186,7 +188,7 @@ static ssize_t pnp_show_card_name(struct device *dmdev,
 	struct pnp_card *card = to_pnp_card(dmdev);
 
 	str += sprintf(str, "%s\n", card->name);
-	return (str - buf);
+	return str - buf;
 }
 
 static DEVICE_ATTR(name, S_IRUGO, pnp_show_card_name, NULL);
@@ -202,7 +204,7 @@ static ssize_t pnp_show_card_ids(struct device *dmdev,
 		str += sprintf(str, "%s\n", pos->id);
 		pos = pos->next;
 	}
-	return (str - buf);
+	return str - buf;
 }
 
 static DEVICE_ATTR(card_id, S_IRUGO, pnp_show_card_ids, NULL);
@@ -366,6 +368,7 @@ err_out:
 	dev->card_link = NULL;
 	return NULL;
 }
+EXPORT_SYMBOL(pnp_request_card_device);
 
 /**
  * pnp_release_card_device - call this when the driver no longer needs the device
@@ -379,6 +382,7 @@ void pnp_release_card_device(struct pnp_dev *dev)
 	device_release_driver(&dev->dev);
 	drv->link.remove = &card_remove_first;
 }
+EXPORT_SYMBOL(pnp_release_card_device);
 
 /*
  * suspend/resume callbacks
@@ -404,6 +408,7 @@ static int card_resume(struct pnp_dev *dev)
 	return 0;
 }
 
+
 /**
  * pnp_register_card_driver - registers a PnP card driver with the PnP Layer
  * @drv: pointer to the driver to register
@@ -436,6 +441,7 @@ int pnp_register_card_driver(struct pnp_card_driver *drv)
 	}
 	return 0;
 }
+EXPORT_SYMBOL(pnp_register_card_driver);
 
 /**
  * pnp_unregister_card_driver - unregisters a PnP card driver from the PnP Layer
@@ -448,8 +454,4 @@ void pnp_unregister_card_driver(struct pnp_card_driver *drv)
 	spin_unlock(&pnp_lock);
 	pnp_unregister_driver(&drv->link);
 }
-
-EXPORT_SYMBOL(pnp_request_card_device);
-EXPORT_SYMBOL(pnp_release_card_device);
-EXPORT_SYMBOL(pnp_register_card_driver);
 EXPORT_SYMBOL(pnp_unregister_card_driver);
-- 
1.7.9.5

