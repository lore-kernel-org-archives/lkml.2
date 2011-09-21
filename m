Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab1IUR4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 13:56:07 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36664 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab1IUR4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 13:56:05 -0400
Message-ID: <4E7A252F.2000402@gmail.com>
Date: Wed, 21 Sep 2011 12:55:59 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110918 Thunderbird/7.0
MIME-Version: 1.0
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "dave.martin@linaro.org" <dave.martin@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/3] ARM: gic: add OF based initialization
References: <1316550244-3655-1-git-send-email-robherring2@gmail.com> <1316550244-3655-4-git-send-email-robherring2@gmail.com> <4E7A1BCA.1090006@ti.com>
In-Reply-To: <4E7A1BCA.1090006@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit,

On 09/21/2011 12:15 PM, Cousson, Benoit wrote:
> Hi Rob,
> 
> I'm testing that series with OMAP4 but have some issues for the moment :-(
> 
> [    0.000000] WARNING: at kernel/irq/irqdomain.c:34 gic_of_init+0x10c/0x180()
> [    0.000000] error: irq_desc already assigned to a domain
> [    0.000000] Modules linked in:
> [    0.000000] [<c001b284>] (unwind_backtrace+0x0/0xf0) from [<c0051c34>] (warn_slowpath_common+0x4c/0x64)
> [    0.000000] [<c0051c34>] (warn_slowpath_common+0x4c/0x64) from [<c0051ce0>] (warn_slowpath_fmt+0x30/0x40)
> [    0.000000] [<c0051ce0>] (warn_slowpath_fmt+0x30/0x40) from [<c05f6874>] (gic_of_init+0x10c/0x180)
> [    0.000000] [<c05f6874>] (gic_of_init+0x10c/0x180) from [<c05fa2e0>] (omap_gic_of_init+0x8/0x28)
> [    0.000000] [<c05fa2e0>] (omap_gic_of_init+0x8/0x28) from [<c0616b44>] (of_irq_init+0x148/0x28c)
> [    0.000000] [<c0616b44>] (of_irq_init+0x148/0x28c) from [<c05f3074>] (init_IRQ+0x14/0x1c)
> [    0.000000] [<c05f3074>] (init_IRQ+0x14/0x1c) from [<c05f0650>] (start_kernel+0x184/0x2fc)
> [    0.000000] [<c05f0650>] (start_kernel+0x184/0x2fc) from [<80008040>] (0x80008040)
>  
> I'm not super familiar with all the irq stuff but I'm wondering if there is not something wrong with the test that print that message:
> 
> void irq_domain_add(struct irq_domain *domain)
> {
> 	struct irq_data *d;
> 	int hwirq;
> 
> 	/*
> 	 * This assumes that the irq_domain owner has already allocated
> 	 * the irq_descs.  This block will be removed when support for dynamic
> 	 * allocation of irq_descs is added to irq_domain.
> 	 */
> 	for (hwirq = 0; hwirq < domain->nr_irq; hwirq++) {
> 		d = irq_get_irq_data(irq_domain_to_irq(domain, hwirq));
> 		if (d || d->domain) {
> 			/* things are broken; just report, don't clean up */
> 			WARN(1, "error: irq_desc already assigned to a domain");
> 			return;
> 		}
> [...]
> 
> Is the (d || d->domain) correct? Shouldn't it be (d && d->domain)?
> 
> But since that used to work properly, I have some doubt. Moreover the driver will not even get the proper interrupt later...
> 
> Do you have any clue?

I fixed that in the prior series and tglx picked it up, so I did not
repost. It should hit mainline for 3.1, but I haven't verified if it is
in yet. Sorry for the confusion, I should have mentioned that.

Rob

