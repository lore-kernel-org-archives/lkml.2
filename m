Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889Ab1IONrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:47:19 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:57731
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933789Ab1IONrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:47:17 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 15 Sep 2011 21:53:12 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 0/5] GIC OF bindings
Message-ID: <20110915135310.GA25690@S2100-06.ap.freescale.net>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 11:31:35AM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> This series introduces of_irq_init to scan the device tree for interrupt
> controller nodes and call their init functions in proper order. The GIC
> init function is then called from this function. The platform code then
> looks something like this:
> 
> const static struct of_device_id irq_match[] = {
> 	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
> 	{}
> };
> 
> static void __init highbank_init_irq(void)
> {
> 	of_irq_init(irq_match);
> }
> 
> The binding for GIC PPIs is now done with a 3rd interrupt cell to specify
> a cpu mask for which cpu the PPI is connected to. This was discussed at LPC
> and suggested by Grant.
> 
> I dropped the public intc_desc struct. The the interrupt controller's node
> and the interrupt parent's node are passed in directly to the controller's
> init function. The linux irq assignment is now done dynamically using
> irq_alloc_descs.
> 
> The first 2 patches are minor fixes to irqdomains.
> 
> Rob
> 
> Rob Herring (5):
>   irq: add declaration of irq_domain_simple_ops to irqdomain.h
>   irq: fix existing domain check in irq_domain_add
>   of/irq: introduce of_irq_init
>   ARM: gic: allow irq_start to be 0
>   ARM: gic: add OF based initialization
> 
>  Documentation/devicetree/bindings/arm/gic.txt |   53 ++++++++++++++
>  arch/arm/common/gic.c                         |   57 +++++++++++++--
>  arch/arm/include/asm/hardware/gic.h           |   10 +++
>  drivers/of/irq.c                              |   96 +++++++++++++++++++++++++
>  include/linux/irqdomain.h                     |    1 +
>  include/linux/of_irq.h                        |    1 +
>  kernel/irq/irqdomain.c                        |    2 +-
>  7 files changed, 214 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/gic.txt

On imx6q:

Tested-by: Shawn Guo <shawn.guo@linaro.org>

-- 
Regards,
Shawn

