Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab0I1STK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 14:19:10 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:54975 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757403Ab0I1STH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 14:19:07 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: jgarzik@pobox.com
Subject: [PATCH] de2104x: disable media debug messages by default
Date: Tue, 28 Sep 2010 20:18:55 +0200
User-Agent: KMail/1.9.10
Cc: netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009282018.57547.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print media debug messages only when HW debug is enabled.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.36-rc3-/drivers/net/tulip/de2104x.c	2010-09-28 19:50:51.000000000 +0200
+++ linux-2.6.36-rc3/drivers/net/tulip/de2104x.c	2010-09-28 20:05:34.000000000 +0200
@@ -948,8 +948,9 @@ static void de_set_media (struct de_priv
 	else
 		macmode &= ~FullDuplex;
 
-	if (netif_msg_link(de)) {
+	if (netif_msg_link(de))
 		dev_info(&de->dev->dev, "set link %s\n", media_name[media]);
+	if (netif_msg_hw(de)) {
 		dev_info(&de->dev->dev, "mode 0x%x, sia 0x%x,0x%x,0x%x,0x%x\n",
 			 dr32(MacMode), dr32(SIAStatus),
 			 dr32(CSR13), dr32(CSR14), dr32(CSR15));


-- 
Ondrej Zary
