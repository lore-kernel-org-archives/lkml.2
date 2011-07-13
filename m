Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab1GMFUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 01:20:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65082 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1GMFUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 01:20:49 -0400
Subject: [PATCH] i2c-pxa2xx: return proper error code in ce4100_i2c_probe
 error paths
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 13:20:39 +0800
Message-ID: <1310534439.6086.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
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



