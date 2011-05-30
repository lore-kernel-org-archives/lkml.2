Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab1E3Spx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 14:45:53 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:43233 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757717Ab1E3Spw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 14:45:52 -0400
Message-ID: <4DE3E5D6.207@freemail.hu>
Date: Mon, 30 May 2011 20:45:42 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] musb_host: compare status for negative error values
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 94.21.98.223
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Variable d is a struct usb_iso_packet_descriptor. The status filed is usually
negative when an error happens.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---

This was not tested at all! I just found this while I was browsing the
code and it looked like a typo. Please verify and test it before aplying
this patch. If I was wrong, sorry about that.

---
diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 7295e31..8b2473f 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -1575,7 +1575,7 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 			/* even if there was an error, we did the dma
 			 * for iso_frame_desc->length
 			 */
-			if (d->status != EILSEQ && d->status != -EOVERFLOW)
+			if (d->status != -EILSEQ && d->status != -EOVERFLOW)
 				d->status = 0;

 			if (++qh->iso_idx >= urb->number_of_packets)
