Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316Ab1FWTlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 15:41:42 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:50937 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932726Ab1FWTll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 15:41:41 -0400
Subject: [PATCH 08/11] Remove useless ft1000_release() function
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
From: Ondrej Zary <linux@rainbow-software.org>
Date: Thu, 23 Jun 2011 21:41:31 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106232141.32876.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove useless ft1000_release() function.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
index 13b6837..6a1c1d4 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
@@ -46,7 +46,6 @@ struct net_device *init_ft1000_card(struct pcmcia_device *link,
 void stop_ft1000_card(struct net_device *);
 
 static int ft1000_config(struct pcmcia_device *link);
-static void ft1000_release(struct pcmcia_device *link);
 static void ft1000_detach(struct pcmcia_device *link);
 static int ft1000_attach(struct pcmcia_device *link);
 
@@ -119,23 +118,10 @@ static int ft1000_config(struct pcmcia_device *link)
 
 	return 0;
 failed:
-	ft1000_release(link);
+	pcmcia_disable_device(link);
 	return -ENODEV;
 }
 
-/*======================================================================
-
-    After a card is removed, ft1000_release() will unregister the
-    device, and release the PCMCIA configuration.  If the device is
-    still open, this will be postponed until it is closed.
-
-======================================================================*/
-
-static void ft1000_release(struct pcmcia_device *link)
-{
-	 pcmcia_disable_device(link);
-}
-
 static int ft1000_suspend(struct pcmcia_device *link)
 {
 	struct net_device *dev = link->priv;
-- 
Ondrej Zary

