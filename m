Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab2BOUdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:33:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47243 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab2BOUdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:33:04 -0500
Date: Wed, 15 Feb 2012 13:33:00 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Milton Miller <miltonm@bga.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 00/25] irq_domain generalization and refinement
Message-ID: <20120215203300.GJ25779@ponder.secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
 <20120204221748.GN14129@n2100.arm.linux.org.uk>
 <20120204223125.GO14129@n2100.arm.linux.org.uk>
 <20120205013853.GQ20333@atomide.com>
 <20120205161348.GZ889@n2100.arm.linux.org.uk>
 <20120207152627.GA17825@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207152627.GA17825@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 03:26:27PM +0000, Mark Brown wrote:
> On Sun, Feb 05, 2012 at 04:13:48PM +0000, Russell King - ARM Linux wrote:
> 
> > It's not quite correct, because OMAP4 has issues in this area as well
> > (which does select IRQ_DOMAIN but can be without OF.)  The result is
> > an oops from irq_domain_add() because domain->ops is NULL.
> 
> > The right solution is three fold:
> 
> > 1. Wrap the bits of code in CONFIG_IRQ_DOMAIN
> > 2. Get rid of the #ifdef CONFIG_OF there, so the 'ops' member can be
> >    initialized.
> > 3. Fix the OMAP vp code not to oops when voltdm->pmic is NULL
> 
> > which I have in my combined patch for fixing OMAP so far.
> 
> It'd also help if we supported null ops, I sent patches for that a few
> times over the 3.3 cycle since I was running into it on my systems but
> apparently to /dev/null and further changes in this area have made the
> patches not apply any more.

I've avoided allowing null ops so that the drivers are forced to be explicit
about what they want, and it makes for (IMHO) simpler to follow code in the
core.

Sorry I missed your patches though.

g.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
