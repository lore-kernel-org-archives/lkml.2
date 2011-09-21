Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1IUJeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:34:50 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47439 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab1IUJes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:34:48 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
Subject: [PATCH 40/57] dirvers/parisc: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:41 +0800
Message-Id: <1316597339-29861-41-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
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
index e3b76d4..5e6fd94e 100644
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
1.7.4.1

