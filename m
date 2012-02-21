Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2BUKIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:08:50 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49421 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab2BUKIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:08:48 -0500
From: santosh nayak <santoshprasadnayak@gmail.com>
To: stefanr@s5r6.in-berlin.de
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH 1/2] Driver: firewire: Use the macro DMA_BIT_MASK().
Date: Tue, 21 Feb 2012 15:38:13 +0530
Message-Id: <1329818893-8276-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

Use the macro DMA_BIT_MASK instead of the constant  0xffffffff

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/firewire/nosy.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/nosy.c b/drivers/firewire/nosy.c
index 763626b..a7c4422 100644
--- a/drivers/firewire/nosy.c
+++ b/drivers/firewire/nosy.c
@@ -36,7 +36,7 @@
 #include <linux/timex.h>
 #include <linux/uaccess.h>
 #include <linux/wait.h>
-
+#include <linux/dma-mapping.h>
 #include <linux/atomic.h>
 #include <asm/byteorder.h>
 
@@ -536,7 +536,7 @@ add_card(struct pci_dev *dev, const struct pci_device_id *unused)
 	u32 p, end;
 	int ret, i;
 
-	if (pci_set_dma_mask(dev, 0xffffffff)) {
+	if (pci_set_dma_mask(dev, DMA_BIT_MASK(32))) {
 		dev_err(&dev->dev,
 		    "DMA address limits not supported for PCILynx hardware\n");
 		return -ENXIO;
-- 
1.7.4.4

