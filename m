Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab0IHRAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 13:00:53 -0400
Received: from ns2.cypress.com ([157.95.67.5]:41312 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab0IHRAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 13:00:52 -0400
Reply-To: <david.cross@cypress.com>
From: "David Cross" <david.cross@cypress.com>
To: "'Greg KH'" <greg@kroah.com>
Cc: <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
References: <1283887607.7250.10.camel@odc-laptop> <20100907235800.GD12823@kroah.com>
Subject: RE: [PATCH] gpmc, EXPORT_SYMBOLS, west bridge related
Date: Wed, 8 Sep 2010 10:00:33 -0700
Organization: Cypress Semiconductor
Message-ID: <701AE2655D844F9AAB5F2492AD477066@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: ActO7FZ1Tnp73YSVQkCSDCiytfU9PwAijOUA
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
In-Reply-To: <20100907235800.GD12823@kroah.com>
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Greg KH [mailto:greg@kroah.com] 

> On Tue, Sep 07, 2010 at 12:26:47PM -0700, David Cross wrote:
> > This patch exports some of the gpmc driver functions in OMAP3. The
purpose behind this patch 
> > is to allow device drivers compiled as loadable modules to be interfaced
> to the GPMC. I am
> > hoping that Tony is the correct maintainer and willing to ACK this
change. Please let me know 
> > if there are any issues or concerns with this patch.
> > Thanks,
> > David
> > 
> > Signed-off-by: David Cross <david.cross@cypress.com>
> > 
> > diff -uprN -X linux-next-vanilla/Documentation/dontdiff
linux-next-vanilla/arch/arm/mach-omap2/gpmc.c
linux-next-incl-sdk/arch/arm/mach-omap2/gpmc.c
> > --- linux-next-vanilla/arch/arm/mach-omap2/gpmc.c	2010-08-31
19:32:51.000000000 -0700
> > +++ linux-next-incl-sdk/arch/arm/mach-omap2/gpmc.c	2010-09-01
16:10:21.000000000 -0700
> > @@ -133,6 +133,7 @@ void gpmc_cs_write_reg(int cs, int idx, 
> >  	reg_addr = gpmc_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
> >  	__raw_writel(val, reg_addr);
> >  }
> > +EXPORT_SYMBOL(gpmc_cs_write_reg);

> EXPORT_SYMBOL_GPL() perhaps?

I don't have an issue with that, though I am not sure I understand why we
would want to limit the usage of the function to GPL'd modules. It is
probably Tony's call assuming he is ok with exporting the symbol.

> What about platforms that don't have this symbol, how will the driver
> build properly then?
The driver will require some sort of HAL to build, this is part of the
reason for the Kconfig changes. They require a HAL to be selected before the
driver can be included. A platform which does not have a gpmc specifically
will have some method of configuring the memory interface to talk with an
external chip. In that case, whatever functions are used for memory
interface configuration will be used.

> Shouldn't something like this be in a arch-neutral
> place in the kernel tree?
I don't think so, the inclusion of west bridge is architecture specific
based on the need to configure an external memory interface to talk to it.

Thanks,
david




---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

