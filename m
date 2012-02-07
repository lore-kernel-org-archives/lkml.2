Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab2BGP0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 10:26:35 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53658 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2BGP0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 10:26:34 -0500
Date: Tue, 7 Feb 2012 15:26:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Milton Miller <miltonm@bga.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 00/25] irq_domain generalization and refinement
Message-ID: <20120207152627.GA17825@sirena.org.uk>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
 <20120204221748.GN14129@n2100.arm.linux.org.uk>
 <20120204223125.GO14129@n2100.arm.linux.org.uk>
 <20120205013853.GQ20333@atomide.com>
 <20120205161348.GZ889@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120205161348.GZ889@n2100.arm.linux.org.uk>
X-Cookie: Byte your tongue.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 05, 2012 at 04:13:48PM +0000, Russell King - ARM Linux wrote:

> It's not quite correct, because OMAP4 has issues in this area as well
> (which does select IRQ_DOMAIN but can be without OF.)  The result is
> an oops from irq_domain_add() because domain->ops is NULL.

> The right solution is three fold:

> 1. Wrap the bits of code in CONFIG_IRQ_DOMAIN
> 2. Get rid of the #ifdef CONFIG_OF there, so the 'ops' member can be
>    initialized.
> 3. Fix the OMAP vp code not to oops when voltdm->pmic is NULL

> which I have in my combined patch for fixing OMAP so far.

It'd also help if we supported null ops, I sent patches for that a few
times over the 3.3 cycle since I was running into it on my systems but
apparently to /dev/null and further changes in this area have made the
patches not apply any more.
