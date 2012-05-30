Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab2E3U0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:26:43 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41823 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755964Ab2E3U0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:26:40 -0400
From: Joe Perches <joe@perches.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] usb: gadget: pch_udc: Fix likely misuse of | for &
Date: Wed, 30 May 2012 13:25:57 -0700
Message-Id: <2530fb0cbede64dad718d41012156043d1ca424e.1338408931.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1338408931.git.joe@perches.com>
References: <cover.1338408931.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using | with a constant is always true.
Likely this should have be &.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/gadget/pch_udc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 1cfcc9e..f4fb71c 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2208,7 +2208,7 @@ static void pch_udc_complete_receiver(struct pch_udc_ep *ep)
 			return;
 		}
 		if ((td->status & PCH_UDC_BUFF_STS) == PCH_UDC_BS_DMA_DONE)
-			if (td->status | PCH_UDC_DMA_LAST) {
+			if (td->status & PCH_UDC_DMA_LAST) {
 				count = td->status & PCH_UDC_RXTX_BYTES;
 				break;
 			}
-- 
1.7.8.111.gad25c.dirty

