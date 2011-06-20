Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab1FTUpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:45:30 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:41951 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751956Ab1FTUp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:45:28 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Subject: staging: ft1000-pcmcia: don't crash on load
Date: Mon, 20 Jun 2011 22:45:16 +0200
User-Agent: KMail/1.9.10
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106202245.18698.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't crash with NULL pointer dereference on load because of empty .name.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
@@ -295,9 +295,7 @@ MODULE_DEVICE_TABLE(pcmcia, ft1000_ids);
 
 static struct pcmcia_driver ft1000_cs_driver = {
 	.owner = THIS_MODULE,
-	.drv = {
-		.name = "ft1000_cs",
-		},
+	.name = "ft1000_cs",
 	.probe      = ft1000_attach,
 	.remove     = ft1000_detach,
 	.id_table	= ft1000_ids,


-- 
Ondrej Zary
