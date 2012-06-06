Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057Ab2FFVoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:44:05 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:7149 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758083Ab2FFVly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:41:54 -0400
X-IronPort-AV: E=Sophos;i="4.75,726,1330902000"; 
   d="scan'208";a="161655286"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Felipe Balbi <balbi@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, Julia Lawall <julia@diku.dk>
Subject: [PATCH 3/7] drivers/usb/gadget/pch_udc.c: adjust suspicious bit operation
Date: Wed,  6 Jun 2012 23:41:37 +0200
Message-Id: <1339018901-28439-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

PCH_UDC_DMA_LAST is 0x08000000 so a bit-or with this value always gives a
nonzero result.  The test is rewritten as done elsewhere in the same file.

This problem was found using Coccinelle (http://coccinelle.lip6.fr/).

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/gadget/pch_udc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 1cfcc9e..79f7a53 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2208,7 +2208,8 @@ static void pch_udc_complete_receiver(struct pch_udc_ep *ep)
 			return;
 		}
 		if ((td->status & PCH_UDC_BUFF_STS) == PCH_UDC_BS_DMA_DONE)
-			if (td->status | PCH_UDC_DMA_LAST) {
+			if ((td_data->status & PCH_UDC_DMA_LAST)
+			    == PCH_UDC_DMA_LAST) {
 				count = td->status & PCH_UDC_RXTX_BYTES;
 				break;
 			}

