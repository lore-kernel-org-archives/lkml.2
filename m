Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab1JSBie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 21:38:34 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:33637 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273Ab1JSBiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 21:38:24 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Dan Carpenter <dan.carpenter@oracle.com>,
        David Rientjes <rientjes@google.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 2/2] gpio-ml-ioh: Use NUMA_NO_NODE not GFP_KERNEL
Date: Wed, 19 Oct 2011 10:37:40 +0900
Message-Id: <1318988260-19462-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318988260-19462-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1318988260-19462-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
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
 drivers/gpio/gpio-ml-ioh.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index 88d65be..1b59003 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -429,7 +429,7 @@ static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
 	chip = chip_save;
 	for (j = 0; j < 8; j++, chip++) {
 		irq_base = irq_alloc_descs(-1, IOH_IRQ_BASE, num_ports[j],
-					   GFP_KERNEL);
+					   NUMA_NO_NODE);
 		if (irq_base < 0) {
 			dev_warn(&pdev->dev,
 				"ml_ioh_gpio: Failed to get IRQ base num\n");
-- 
1.7.4.4

