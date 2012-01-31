Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab2AaNn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:43:26 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:9537
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754355Ab2AaNnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:43:24 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dhc1bhc31hc1ah2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 31 Jan 2012 21:58:22 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: Shawn Guo <shawn.guo@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v3 14/25] irq_domain: Remove irq_domain_add_simple()
Message-ID: <20120131135821.GA24804@S2100-06.ap.freescale.net>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
 <1327700179-17454-15-git-send-email-grant.likely@secretlab.ca>
 <20120131124500.GA28571@S2101-09.ap.freescale.net>
 <4F27E96E.9010204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F27E96E.9010204@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 07:15:26AM -0600, Rob Herring wrote:
...
> >> --- a/arch/arm/mach-mx5/imx51-dt.c
> >> +++ b/arch/arm/mach-mx5/imx51-dt.c
> >> @@ -47,7 +47,7 @@ static const struct of_dev_auxdata imx51_auxdata_lookup[] __initconst = {
> >>  static int __init imx51_tzic_add_irq_domain(struct device_node *np,
> >>  				struct device_node *interrupt_parent)
> >>  {
> >> -	irq_domain_add_simple(np, 0);
> >> +	irq_domain_add_legacy(np, 32, 0, 0, &irq_domain_simple_ops, NULL);
> >>  	return 0;
> >>  }
> >>  
> >> @@ -57,7 +57,7 @@ static int __init imx51_gpio_add_irq_domain(struct device_node *np,
> >>  	static int gpio_irq_base = MXC_GPIO_IRQ_START + ARCH_NR_GPIOS;
> >>  
> >>  	gpio_irq_base -= 32;
> >> -	irq_domain_add_simple(np, gpio_irq_base);
> >> +	irq_domain_add_legacy(np, 32, gpio_irq_base, 0, &irq_domain_simple_ops, NULL);
> > 
> > The tzic on imx5 gets 128 irq lines rather than 32 here.  The current
> > code will make any hwirq that is > 32 hit the WARN_ON below in
> > irq_domain_legacy_revmap().
> 
> But this is the gpio controller code? Really this should be 4 domains,
> but this temp fix is probably fine until you use my generic irq chip
> support.
> 
Sorry.  The comment was put at the wrong place.  It should be against
imx51_tzic_add_irq_domain() just above.

-- 
Regards,
Shawn

