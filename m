Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab1AZM3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:29:24 -0500
Received: from mail.sysgo.com ([195.145.229.155]:60346 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab1AZM3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:29:22 -0500
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jan 2011 07:29:22 EST
Date: Wed, 26 Jan 2011 13:22:16 +0100
From: Pavel Machek <pma@sysgo.com>
To: kernel list <linux-kernel@vger.kernel.org>, eric.y.miao@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: for mainline -- fix pcmcia interrupts
Message-ID: <20110126122216.GA29420@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit 08fa159003aa510027951671b94aadc380ab2d2a
Author: Eric Miao <eric.y.miao@gmail.com>
Date:   Sat Dec 26 12:32:38 2009 +0800

    [ARM] sa1111: avoid using hardcoded IRQ numbers for PCMCIA driver

switched ready interrupts for slot 0 and 1 by mistake. Fix that to
make CF work again.

Signed-off-by: Pavel Machek <pma@sysgo.com>

--- a/drivers/pcmcia/sa1111_generic.c
+++ b/drivers/pcmcia/sa1111_generic.c
@@ -145,8 +145,8 @@ int sa1111_pcmcia_add(struct sa1111_dev *dev, struct pcmcia_low_level *ops,
 		s->soc.socket.owner = ops->owner;
 		s->soc.socket.dev.parent = &dev->dev;
 		s->soc.socket.pci_irq = s->soc.nr ?
-				dev->irq[IDX_IRQ_S0_READY_NINT] :
-				dev->irq[IDX_IRQ_S1_READY_NINT];
+				dev->irq[IDX_IRQ_S1_READY_NINT] :
+				dev->irq[IDX_IRQ_S0_READY_NINT];
 		s->dev = dev;
 
 		ret = add(&s->soc);

