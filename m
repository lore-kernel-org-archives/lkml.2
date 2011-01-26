Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab1AZGsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 01:48:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:62907 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1AZGsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 01:48:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,379,1291622400"; 
   d="scan'208";a="380020052"
From: "Du, Alek" <alek.du@intel.com>
To: David Miller <davem@davemloft.net>,
        "buytenh@secretlab.ca" <buytenh@secretlab.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 26 Jan 2011 14:48:02 +0800
Subject: RE: [PATCH] langwell_gpio: Fix deprecated refs to irq_desc->chip
 and chip->eoi
Thread-Topic: [PATCH] langwell_gpio: Fix deprecated refs to irq_desc->chip
 and chip->eoi
Thread-Index: Acu9Il6+X54P6OJWRyuxU5DRvituqwAAj+9w
Message-ID: <1865303E0DED764181A9D882DEF65FB685DF499ACF@shsmsx502.ccr.corp.intel.com>
References: <20110125.222948.112596409.davem@davemloft.net>
In-Reply-To: <20110125.222948.112596409.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another patch from Feng Tang already covers this and picked up by Andrew Morton.

[patch 04/23] langwell_gpio: modify EOI handling following change of kernel irq subsystem


Thanks,
Alek
-----Original Message-----
From: David Miller [mailto:davem@davemloft.net] 
Sent: Wednesday, January 26, 2011 2:30 PM
To: buytenh@secretlab.ca
Cc: Du, Alek; linux-kernel@vger.kernel.org
Subject: [PATCH] langwell_gpio: Fix deprecated refs to irq_desc->chip and chip->eoi


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/gpio/langwell_gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index d81cc74..a0d0c7b 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -206,7 +206,7 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 		/* clear the edge detect status bit */
 		writel(gedr_v, gedr);
 	}
-	desc->chip->eoi(irq);
+	desc->irq_data.chip->irq_eoi(&desc->irq_data);
 }
 
 static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
-- 
1.7.3.4

