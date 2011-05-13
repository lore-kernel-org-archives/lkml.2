Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab1EMNze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:55:34 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:53911 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab1EMNzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:55:32 -0400
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: gregkh@suse.de, linux-usb@vger.kernel.org, sshtylyov@mvista.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        plagnioj@jcrosoft.com
Subject: [PATCH V2] usb/gadget: at91sam9g20 fix end point max packet size
Date: Fri, 13 May 2011 17:03:02 +0200
Message-Id: <1305298982-5789-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1305042888-19401-1-git-send-email-plagnioj@jcrosoft.com>
References: <1305042888-19401-1-git-send-email-plagnioj@jcrosoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 9g20 they are the same as the 9260

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Resent upon Greg's request.
Based on current linux-next.
Applies cleanly on current linus' tree (2.6.39-rc7+)

BTW, can we imagine it going to mainline before .39-final in a "fixes" pull
request to Linus from a at91 tree?

 drivers/usb/gadget/at91_udc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 9b7cdb1..41dc093 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1767,7 +1767,7 @@ static int __init at91udc_probe(struct platform_device *pdev)
 	}
 
 	/* newer chips have more FIFO memory than rm9200 */
-	if (cpu_is_at91sam9260()) {
+	if (cpu_is_at91sam9260() || cpu_is_at91sam9g20()) {
 		udc->ep[0].maxpacket = 64;
 		udc->ep[3].maxpacket = 64;
 		udc->ep[4].maxpacket = 512;
-- 
1.7.3

