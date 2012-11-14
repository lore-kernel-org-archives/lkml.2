Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161174Ab2KNLfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:35:48 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48495 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161052Ab2KNLfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:35:47 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: gregkh@linuxfoundation.org
Cc: amiller@amilx.com, akpm@linux-foundation.org, joe@perches.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: rtl8187se: r8180_core.c: Inspect the return value of register_netdev()
Date: Wed, 14 Nov 2012 15:30:57 +0530
Message-Id: <1352887257-23142-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspect the return value of register_netdev() in the driver probe routine and
return -ENODEV in case of error.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 20e5fb5..833b083 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -3638,7 +3638,8 @@ static int __devinit rtl8180_pci_probe(struct pci_dev *pdev,
 
 	netif_carrier_off(dev);
 
-	register_netdev(dev);
+	if (register_netdev(dev))
+		goto fail1;
 
 	rtl8180_proc_init_one(dev);
 
-- 
1.7.9.5

