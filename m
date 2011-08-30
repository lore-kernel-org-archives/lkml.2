Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab1H3Ghu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 02:37:50 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37139 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab1H3Ghs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 02:37:48 -0400
Subject: [PATCH RESEND] i2c-pxa2xx: return proper error code in
 ce4100_i2c_probe error paths
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 14:37:37 +0800
Message-ID: <1314686257.3270.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
Hi Ben,
Seems this patch is not yet upstream. Here is the resend.

Axel

 drivers/i2c/busses/i2c-pxa-pci.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa-pci.c b/drivers/i2c/busses/i2c-pxa-pci.c
index 6659d26..b73da6c 100644
--- a/drivers/i2c/busses/i2c-pxa-pci.c
+++ b/drivers/i2c/busses/i2c-pxa-pci.c
@@ -109,12 +109,15 @@ static int __devinit ce4100_i2c_probe(struct pci_dev *dev,
 		return -EINVAL;
 	}
 	sds = kzalloc(sizeof(*sds), GFP_KERNEL);
-	if (!sds)
+	if (!sds) {
+		ret = -ENOMEM;
 		goto err_mem;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(sds->pdev); i++) {
 		sds->pdev[i] = add_i2c_device(dev, i);
 		if (IS_ERR(sds->pdev[i])) {
+			ret = PTR_ERR(sds->pdev[i]);
 			while (--i >= 0)
 				platform_device_unregister(sds->pdev[i]);
 			goto err_dev_add;
-- 
1.7.4.1



