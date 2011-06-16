Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab1FPHKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:10:55 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58142 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756878Ab1FPHKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:10:46 -0400
X-Sasl-enc: 6jtGKs5WSobQ6LeTtVJ8q8oStr4sHTyjl3FB4F3ou23Z 1308208245
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:07 2011
Message-Id: <20110616002907.005329511@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [32/85] usb/gadget: at91sam9g20 fix end point max packet size
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

commit bf1f0a05d472e33dda8e5e69525be1584cdbd03a upstream.

on 9g20 they are the same as the 9260

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/at91_udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1687,7 +1687,7 @@ static int __init at91udc_probe(struct p
 	}
 
 	/* newer chips have more FIFO memory than rm9200 */
-	if (cpu_is_at91sam9260()) {
+	if (cpu_is_at91sam9260() || cpu_is_at91sam9g20()) {
 		udc->ep[0].maxpacket = 64;
 		udc->ep[3].maxpacket = 64;
 		udc->ep[4].maxpacket = 512;


