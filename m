Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab2EIItv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:49:51 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:46122 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785Ab2EIItt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:49:49 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <stern@rowland.harvard.edu>, <linux-usb@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <plagnioj@jcrosoft.com>, <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] USB: ohci-at91: use resource_size() for memory/io resource length
Date: Wed, 9 May 2012 10:49:41 +0200
Message-ID: <1336553381-31131-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.159.245.203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/usb/host/ohci-at91.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 13ebeca..da9ddd1 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -129,7 +129,7 @@ static int __devinit usb_hcd_at91_probe(const struct hc_driver *driver,
 	if (!hcd)
 		return -ENOMEM;
 	hcd->rsrc_start = pdev->resource[0].start;
-	hcd->rsrc_len = pdev->resource[0].end - pdev->resource[0].start + 1;
+	hcd->rsrc_len = resource_size(&pdev->resource[0]);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
 		pr_debug("request_mem_region failed\n");
-- 
1.7.10

