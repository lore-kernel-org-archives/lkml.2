Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965281Ab2EOCRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:49145 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964886Ab2EOCQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:23 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 029/179] usb/gadget: at91sam9g20 fix end point max packet size
Date: Mon, 14 May 2012 22:12:05 -0400
Message-ID: <1337048075-6132-30-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit bf1f0a05d472e33dda8e5e69525be1584cdbd03a upstream.

on 9g20 they are the same as the 9260

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/gadget/at91_udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index df1bae9..ad617d9 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1694,7 +1694,7 @@ static int __init at91udc_probe(struct platform_device *pdev)
 	}
 
 	/* newer chips have more FIFO memory than rm9200 */
-	if (cpu_is_at91sam9260()) {
+	if (cpu_is_at91sam9260() || cpu_is_at91sam9g20()) {
 		udc->ep[0].maxpacket = 64;
 		udc->ep[3].maxpacket = 64;
 		udc->ep[4].maxpacket = 512;
-- 
1.7.9.6

