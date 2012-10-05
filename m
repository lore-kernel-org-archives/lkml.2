Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab2JEMVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:21:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46479 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab2JEMVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:21:30 -0400
From: Philippe De Swert <philippedeswert@gmail.com>
To: Philippe De Swert <philippe.deswert@jollamobile.com>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] musb : Fix section mismatch with musb_init_controller
Date: Fri,  5 Oct 2012 14:32:12 +0300
Message-Id: <1349436732-13165-1-git-send-email-philippe.deswert@jollamobile.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel reports a section mismatch when compiling in musb drivers.
This patch fixes that.

Signed-off-by: Philippe De Swert <philippe.deswert@jollamobile.com>
---
 drivers/usb/musb/musb_dma.h  |    2 +-
 drivers/usb/musb/musbhsdma.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/musb/musb_dma.h b/drivers/usb/musb/musb_dma.h
index 3a97c4e..24d3921 100644
--- a/drivers/usb/musb/musb_dma.h
+++ b/drivers/usb/musb/musb_dma.h
@@ -178,7 +178,7 @@ struct dma_controller {
 extern void musb_dma_completion(struct musb *musb, u8 epnum, u8 transmit);
 
 
-extern struct dma_controller *__init
+extern struct dma_controller *__devinit
 dma_controller_create(struct musb *, void __iomem *);
 
 extern void dma_controller_destroy(struct dma_controller *);
diff --git a/drivers/usb/musb/musbhsdma.c b/drivers/usb/musb/musbhsdma.c
index c1be687..0fc6ca6 100644
--- a/drivers/usb/musb/musbhsdma.c
+++ b/drivers/usb/musb/musbhsdma.c
@@ -380,7 +380,7 @@ void dma_controller_destroy(struct dma_controller *c)
 	kfree(controller);
 }
 
-struct dma_controller *__init
+struct dma_controller *__devinit
 dma_controller_create(struct musb *musb, void __iomem *base)
 {
 	struct musb_dma_controller *controller;
-- 
1.7.9.5

