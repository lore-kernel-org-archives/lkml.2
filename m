Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab2KORWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 12:22:30 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54763 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2KORW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 12:22:29 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: gregkh@linuxfoundation.org
Cc: seanm@seanm.ca, s.l-h@gmx.de, tim.gardner@canonical.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: rtl8192e: rtl8192e: rtl_core.c: Audit the return value of register_netdev()
Date: Thu, 15 Nov 2012 22:52:13 +0530
Message-Id: <1353000133-13462-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspect the return value of register_netdev() in the driver probe routine and
return -ENODEV in case of error.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index 81134d3..f68df24 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -2955,7 +2955,8 @@ static int __devinit rtl8192_pci_probe(struct pci_dev *pdev,
 	netif_carrier_off(dev);
 	netif_stop_queue(dev);
 
-	register_netdev(dev);
+	if (register_netdev(dev))
+		goto err_free_irq;
 	RT_TRACE(COMP_INIT, "dev name: %s\n", dev->name);
 
 	rtl8192_proc_init_one(dev);
-- 
1.7.9.5

