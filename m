Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1JSBiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 21:38:24 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:33619 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797Ab1JSBiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 21:38:23 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Dan Carpenter <dan.carpenter@oracle.com>,
        David Rientjes <rientjes@google.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 1/2] gpio-pch: Use NUMA_NO_NODE not GFP_KERNEL
Date: Wed, 19 Oct 2011 10:37:39 +0900
Message-Id: <1318988260-19462-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, GFP_KERNEL is used as parameter of irq_alloc_descs like below.

          irq_base = irq_alloc_descs(-1, IOH_IRQ_BASE, num_ports[j],
                                     GFP_KERNEL); 

This is not true.
So, this patch uses NUMA_NO_NODE not GFP_KERNEL.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/gpio/gpio-pch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index 596e454..64b0e39 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -399,7 +399,7 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
 		goto err_gpiochip_add;
 	}
 
-	irq_base = irq_alloc_descs(-1, 0, gpio_pins[chip->ioh], GFP_KERNEL);
+	irq_base = irq_alloc_descs(-1, 0, gpio_pins[chip->ioh], NUMA_NO_NODE);
 	if (irq_base < 0) {
 		dev_warn(&pdev->dev, "PCH gpio: Failed to get IRQ base num\n");
 		chip->irq_base = -1;
-- 
1.7.4.4

