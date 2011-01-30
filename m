Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab1A3GFF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 01:05:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35110
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049Ab1A3GFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 01:05:04 -0500
Date: Sat, 29 Jan 2011 22:05:38 -0800 (PST)
Message-Id: <20110129.220538.104056157.davem@davemloft.net>
To: alek.du@intel.com
Cc: buytenh@secretlab.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] langwell_gpio: Fix deprecated refs to irq_desc->chip
 and chip->eoi
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110125.225034.39182208.davem@davemloft.net>
References: <20110125.222948.112596409.davem@davemloft.net>
	<1865303E0DED764181A9D882DEF65FB685DF499ACF@shsmsx502.ccr.corp.intel.com>
	<20110125.225034.39182208.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 25 Jan 2011 22:50:34 -0800 (PST)

> From: "Du, Alek" <alek.du@intel.com>
> Date: Wed, 26 Jan 2011 14:48:02 +0800
> 
>> Another patch from Feng Tang already covers this and picked up by Andrew Morton.
>> 
>> [patch 04/23] langwell_gpio: modify EOI handling following change of kernel irq subsystem
> 
> Ok, thanks.

It doesn't cover "this".  Somthing like my patch is still necessary to
get this driver to build:

drivers/gpio/langwell_gpio.c: In function 'lnw_irq_handler':
drivers/gpio/langwell_gpio.c:210:10: error: 'struct irq_desc' has no member named 'chip'
drivers/gpio/langwell_gpio.c:211:7: error: 'struct irq_desc' has no member named 'chip'

--------------------
Subject: [PATCH] langwell_gpio: Fix deprecated refs to irq_desc->chip
From: David Miller <davem@davemloft.net>

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 54d70a4..fb3e439 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -207,8 +207,8 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 		writel(gedr_v, gedr);
 	}
 
-	if (desc->chip->irq_eoi)
-		desc->chip->irq_eoi(irq_get_irq_data(irq));
+	if (desc->irq_data.chip->irq_eoi)
+		desc->irq_data.chip->irq_eoi(irq_get_irq_data(irq));
 	else
 		dev_warn(lnw->chip.dev, "missing EOI handler for irq %d\n", irq);
 
