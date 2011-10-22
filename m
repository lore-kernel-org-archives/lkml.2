Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1JVKOO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 06:14:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47030 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab1JVKOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 06:14:12 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
Subject: [PATCH 36/49] dirvers/parisc: irq: Remove IRQF_DISABLED
Date: Sat, 22 Oct 2011 17:56:48 +0800
Message-Id: <1319277421-9203-37-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 drivers/parisc/superio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/parisc/superio.c b/drivers/parisc/superio.c
index e3b76d4..5e6fd94 100644
--- a/drivers/parisc/superio.c
+++ b/drivers/parisc/superio.c
@@ -274,7 +274,7 @@ superio_init(struct pci_dev *pcidev)
 	else
 		printk(KERN_ERR PFX "USB regulator not initialized!\n");
 
-	if (request_irq(pdev->irq, superio_interrupt, IRQF_DISABLED,
+	if (request_irq(pdev->irq, superio_interrupt, 0,
 			SUPERIO, (void *)sio)) {
 
 		printk(KERN_ERR PFX "could not get irq\n");
-- 
1.7.1

