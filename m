Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab1FWTid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 15:38:33 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:43076 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932702Ab1FWTic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 15:38:32 -0400
Subject: [PATCH 03/11] Remove useless debugging from ft1000_cs.c
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
From: Ondrej Zary <linux@rainbow-software.org>
Date: Thu, 23 Jun 2011 21:38:22 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106232138.24293.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove useless debugging from ft1000_cs.c

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
index a9b0cff..b99f07d 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
@@ -65,11 +65,6 @@ MODULE_LICENSE("GPL");
    left out.  If you compile with PCMCIA_DEBUG=0, the debug code will
    be present but disabled.
 */
-#ifdef FT_DEBUG
-#define DEBUG(n, args...) printk(KERN_DEBUG args)
-#else
-#define DEBUG(n, args...)
-#endif
 
 /*====================================================================*/
 
@@ -103,8 +98,6 @@ static void ft1000_reset(struct pcmcia_device * link)
 
 static int ft1000_attach(struct pcmcia_device *link)
 {
-	DEBUG(0, "ft1000_cs: ft1000_attach()\n");
-
 	link->priv = NULL;
 	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO;
 
@@ -125,13 +118,6 @@ static void ft1000_detach(struct pcmcia_device *link)
 {
 	struct net_device *dev = link->priv;
 
-	DEBUG(0, "ft1000_cs: ft1000_detach(0x%p)\n", link);
-
-	if (link == NULL) {
-		DEBUG(0,"ft1000_cs:ft1000_detach: Got a NULL pointer\n");
-		return;
-	}
-
 	if (dev) {
 		stop_ft1000_card(dev);
 	}
@@ -207,8 +193,6 @@ failed:
 static void ft1000_release(struct pcmcia_device * link)
 {
 
-	DEBUG(0, "ft1000_cs: ft1000_release(0x%p)\n", link);
-
 	/*
 	   If the device is currently in use, we won't release until it
 	   is actually closed, because until then, we can't be sure that
@@ -277,13 +261,11 @@ static struct pcmcia_driver ft1000_cs_driver = {
 
 static int __init init_ft1000_cs(void)
 {
-	DEBUG(0, "ft1000_cs: loading\n");
 	return pcmcia_register_driver(&ft1000_cs_driver);
 }
 
 static void __exit exit_ft1000_cs(void)
 {
-	DEBUG(0, "ft1000_cs: unloading\n");
 	pcmcia_unregister_driver(&ft1000_cs_driver);
 }
 
-- 
Ondrej Zary

