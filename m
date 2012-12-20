Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab2LTWHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:07:04 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:50631 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab2LTWG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:06:57 -0500
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 17:06:56 EST
From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
To: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH] arm/davinci/musb: fix mispint introduced by commit 032ec49f5351e9cb242b1a1c367d14415043ab95
Date: Fri, 21 Dec 2012 01:59:06 +0400
Message-Id: <1356040747-15105-1-git-send-email-mikhail.kshevetskiy@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
---
 drivers/usb/musb/da8xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
index 8bc44b7..0ed24a6 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -327,7 +327,7 @@ static irqreturn_t da8xx_musb_interrupt(int irq, void *hci)
 		u8 devctl = musb_readb(mregs, MUSB_DEVCTL);
 		int err;
 
-		err = musb->int_usb & USB_INTR_VBUSERROR;
+		err = musb->int_usb & MUSB_INTR_VBUSERROR;
 		if (err) {
 			/*
 			 * The Mentor core doesn't debounce VBUS as needed
-- 
1.7.10.4

