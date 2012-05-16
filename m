Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab2EPIXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:23:17 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:54704 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab2EPIXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:23:13 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-usb@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <plagnioj@jcrosoft.com>, <gregkh@linuxfoundation.org>,
        <idos@codeaurora.org>, <balbi@ti.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] usb: gadget: at91_udc: fix endpoint descriptor dereference
Date: Wed, 16 May 2012 10:23:07 +0200
Message-ID: <1337156587-7379-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.159.245.203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch 5a6506f (Update at91_udc to use usb_endpoint_descriptor inside the
struct usb_ep) removes the desc field of struct at91_ep. This convertion had
not been completed which leads to a compilation error.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/gadget/at91_udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 43943aa..1a4430f 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -475,7 +475,7 @@ static int at91_ep_enable(struct usb_ep *_ep,
 	unsigned long	flags;
 
 	if (!_ep || !ep
-			|| !desc || ep->desc
+			|| !desc || ep->ep.desc
 			|| _ep->name == ep0name
 			|| desc->bDescriptorType != USB_DT_ENDPOINT
 			|| (maxpacket = usb_endpoint_maxp(desc)) == 0
-- 
1.7.10

