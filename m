Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1F3WGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:06:19 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:33510 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753417Ab1F3WES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:18 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/28] staging: ft1000-pcmcia: remove useless ft1000_release() function
Date: Fri,  1 Jul 2011 00:03:54 +0200
Message-Id: <1309471437-12633-26-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
References: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
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

