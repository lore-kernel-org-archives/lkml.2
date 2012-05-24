Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab2EXJTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:19:55 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:35551 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab2EXJTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:19:54 -0400
Date: Thu, 24 May 2012 11:19:33 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: RFC: amba: remove NO_IRQ
Message-ID: <20120524091933.GA8566@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using PrimeCell devices under PCIe, x86 platform. We discussed
this issue on Mar 1st, and you (Russell) reported that NO_IRQ is
expected to go away for ARM, as 0 is the new official "no irq" marker.

The trivial patch below is what I'm currently using to compile my
stuff, but I'd like to get an update about NO_IRQ in ARM (which you
complained was completely on your shoulders). If needed I can take it
over and propose patches.

I'm well aware that the few users within arch/arm are matched by a
much bigger number of users in drivers/ .  The work is not trivial,
but at least I hope to be able to remove NO_IRQ from amba/bus.c by
auditing all its users.

thanks
/alessandro
---
 drivers/amba/bus.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 64ddedd..490a308 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -546,10 +546,10 @@ int amba_device_add(struct amba_device *dev, struct resource *parent)
 		goto err_release;
 
 	printk(KERN_INFO "%s %i\n", __func__, __LINE__);
-	if (dev->irq[0] && dev->irq[0] != NO_IRQ)
+	if (dev->irq[0])
 		ret = device_create_file(&dev->dev, &dev_attr_irq0);
 	printk(KERN_INFO "%s %i\n", __func__, __LINE__);
-	if (ret == 0 && dev->irq[1] && dev->irq[1] != NO_IRQ)
+	if (ret == 0 && dev->irq[1])
 		ret = device_create_file(&dev->dev, &dev_attr_irq1);
 	printk(KERN_INFO "%s %i\n", __func__, __LINE__);
 	if (ret == 0)
-- 
1.7.7.2
