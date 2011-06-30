Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1F3WGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:06:11 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:59768 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753463Ab1F3WES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:18 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/28] staging: ft1000-pcmcia: remove misleading and template comments from ft1000_cs.c
Date: Fri,  1 Jul 2011 00:03:50 +0200
Message-Id: <1309471437-12633-22-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
References: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove misleading, useless and template comments from ft1000_cs.c

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c |   78 ++--------------------
 1 files changed, 5 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
index b99f07d..34fc21f 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
@@ -54,18 +54,6 @@ MODULE_AUTHOR("Wai Chan");
 MODULE_DESCRIPTION("FT1000 PCMCIA driver");
 MODULE_LICENSE("GPL");
 
-/* Newer, simpler way of listing specific interrupts */
-
-/* The old way: bit map of interrupts to choose from */
-/* This means pick from 15, 14, 12, 11, 10, 9, 7, 5, 4, and 3 */
-
-/*
-   All the PCMCIA modules use PCMCIA_DEBUG to control debugging.  If
-   you do not define PCMCIA_DEBUG at all, all the debug code will be
-   left out.  If you compile with PCMCIA_DEBUG=0, the debug code will
-   be present but disabled.
-*/
-
 /*====================================================================*/
 
 struct net_device *init_ft1000_card(struct pcmcia_device *link,
@@ -74,13 +62,6 @@ void stop_ft1000_card(struct net_device *);
 
 static int ft1000_config(struct pcmcia_device *link);
 static void ft1000_release(struct pcmcia_device *link);
-
-/*
-   The attach() and detach() entry points are used to create and destroy
-   "instances" of the driver, where each instance represents everything
-   needed to manage one actual PCMCIA card.
-*/
-
 static void ft1000_detach(struct pcmcia_device *link);
 static int  ft1000_attach(struct pcmcia_device *link);
 
@@ -91,11 +72,6 @@ static void ft1000_reset(struct pcmcia_device * link)
 	pcmcia_reset_card(link->socket);
 }
 
-/*======================================================================
-
-
-======================================================================*/
-
 static int ft1000_attach(struct pcmcia_device *link)
 {
 	link->priv = NULL;
@@ -103,16 +79,7 @@ static int ft1000_attach(struct pcmcia_device *link)
 
 	return ft1000_config(link);
 
-}				/* ft1000_attach */
-
-/*======================================================================
-
-    This deletes a driver "instance".  The device is de-registered
-    with Card Services.  If it has been released, all local data
-    structures are freed.  Otherwise, the structures will be freed
-    when the device is released.
-
-======================================================================*/
+}
 
 static void ft1000_detach(struct pcmcia_device *link)
 {
@@ -126,18 +93,12 @@ static void ft1000_detach(struct pcmcia_device *link)
 
 	free_netdev(dev);
 
-}				/* ft1000_detach */
-
-/*======================================================================
-
-   Check if the io window is configured
+}
 
-======================================================================*/
 int ft1000_confcheck(struct pcmcia_device *link, void *priv_data)
 {
-
 	return pcmcia_request_io(link);
-}				/* ft1000_confcheck */
+}
 
 /*======================================================================
 
@@ -180,7 +141,7 @@ failed:
 	ft1000_release(link);
 	return -ENODEV;
 
-}				/* ft1000_config */
+}
 
 /*======================================================================
 
@@ -192,33 +153,8 @@ failed:
 
 static void ft1000_release(struct pcmcia_device * link)
 {
-
-	/*
-	   If the device is currently in use, we won't release until it
-	   is actually closed, because until then, we can't be sure that
-	   no one will try to access the device or its data structures.
-	 */
-
-	/*
-	   In a normal driver, additional code may be needed to release
-	   other kernel data structures associated with this device.
-	 */
-	/* Don't bother checking to see if these succeed or not */
-
 	 pcmcia_disable_device(link);
-}				/* ft1000_release */
-
-/*======================================================================
-
-    The card status event handler.  Mostly, this schedules other
-    stuff to run after an event is received.
-
-    When a CARD_REMOVAL event is received, we immediately set a
-    private flag to block future accesses to this device.  All the
-    functions that actually access the device should check this flag
-    to make sure the card is still present.
-
-======================================================================*/
+}
 
 static int ft1000_suspend(struct pcmcia_device *link)
 {
@@ -231,13 +167,9 @@ static int ft1000_suspend(struct pcmcia_device *link)
 
 static int ft1000_resume(struct pcmcia_device *link)
 {
-/*	struct net_device *dev = link->priv;
- */
 	return 0;
 }
 
-
-
 /*====================================================================*/
 
 static const struct pcmcia_device_id ft1000_ids[] = {
-- 
Ondrej Zary

