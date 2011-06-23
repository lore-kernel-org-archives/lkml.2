Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab1FWTkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 15:40:53 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:39898 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932726Ab1FWTkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 15:40:51 -0400
Subject: [PATCH 06/11] Coding style fixes in ft1000_cs.c
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
From: Ondrej Zary <linux@rainbow-software.org>
Date: Thu, 23 Jun 2011 21:40:42 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106232140.44718.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor coding style fixes in ft1000_cs.c

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c |   29 +++++++++-------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
index 34fc21f..9a54c84 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
@@ -63,11 +63,11 @@ void stop_ft1000_card(struct net_device *);
 static int ft1000_config(struct pcmcia_device *link);
 static void ft1000_release(struct pcmcia_device *link);
 static void ft1000_detach(struct pcmcia_device *link);
-static int  ft1000_attach(struct pcmcia_device *link);
+static int ft1000_attach(struct pcmcia_device *link);
 
 /*====================================================================*/
 
-static void ft1000_reset(struct pcmcia_device * link)
+static void ft1000_reset(struct pcmcia_device *link)
 {
 	pcmcia_reset_card(link->socket);
 }
@@ -78,21 +78,17 @@ static int ft1000_attach(struct pcmcia_device *link)
 	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO;
 
 	return ft1000_config(link);
-
 }
 
 static void ft1000_detach(struct pcmcia_device *link)
 {
 	struct net_device *dev = link->priv;
 
-	if (dev) {
+	if (dev)
 		stop_ft1000_card(dev);
-	}
 
 	pcmcia_disable_device(link);
-
 	free_netdev(dev);
-
 }
 
 int ft1000_confcheck(struct pcmcia_device *link, void *priv_data)
@@ -110,7 +106,7 @@ int ft1000_confcheck(struct pcmcia_device *link, void *priv_data)
 
 static int ft1000_config(struct pcmcia_device *link)
 {
-	int  ret;
+	int ret;
 
 	dev_dbg(&link->dev, "ft1000_cs: ft1000_config(0x%p)\n", link);
 
@@ -129,7 +125,7 @@ static int ft1000_config(struct pcmcia_device *link)
 	}
 
 	link->priv = init_ft1000_card(link, &ft1000_reset);
-	if (link->priv == NULL) {
+	if (!link->priv) {
 		printk(KERN_INFO "ft1000: Could not register as network device\n");
 		goto failed;
 	}
@@ -140,7 +136,6 @@ static int ft1000_config(struct pcmcia_device *link)
 failed:
 	ft1000_release(link);
 	return -ENODEV;
-
 }
 
 /*======================================================================
@@ -151,7 +146,7 @@ failed:
 
 ======================================================================*/
 
-static void ft1000_release(struct pcmcia_device * link)
+static void ft1000_release(struct pcmcia_device *link)
 {
 	 pcmcia_disable_device(link);
 }
@@ -182,13 +177,13 @@ static const struct pcmcia_device_id ft1000_ids[] = {
 MODULE_DEVICE_TABLE(pcmcia, ft1000_ids);
 
 static struct pcmcia_driver ft1000_cs_driver = {
-	.owner = THIS_MODULE,
-	.name = "ft1000_cs",
-	.probe      = ft1000_attach,
-	.remove     = ft1000_detach,
+	.owner		= THIS_MODULE,
+	.name		= "ft1000_cs",
+	.probe		= ft1000_attach,
+	.remove		= ft1000_detach,
 	.id_table	= ft1000_ids,
-	.suspend    = ft1000_suspend,
-	.resume     = ft1000_resume,
+	.suspend	= ft1000_suspend,
+	.resume		= ft1000_resume,
 };
 
 static int __init init_ft1000_cs(void)
-- 
Ondrej Zary

