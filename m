Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab2IQRXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:23:54 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:17364 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756042Ab2IQRXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:23:51 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19MQ+AD1Mv+8O2wM2KN+gQo
Date: Mon, 17 Sep 2012 10:23:44 -0700
From: Tony Lindgren <tony@atomide.com>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (arm-soc tree related)
Message-ID: <20120917172344.GO4521@atomide.com>
References: <20120917212615.91bc134d237dcd5968f9f549@canb.auug.org.au>
 <20120917141119.GA18715@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917141119.GA18715@quad.lixom.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Olof Johansson <olof@lixom.net> [120917 07:12]:
> Hi,
> 
> On Mon, Sep 17, 2012 at 09:26:15PM +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> > 
> > drivers/mfd/twl-core.c:49:22: fatal error: plat/cpu.h: No such file or directory
> > 
> > Caused by commit 7d7e1eba7e92 ("ARM: OMAP2+: Prepare for irqs.h removal").
> > 
> > I have added the following patch to restrict this driver to ARM until it
> > is fixed:
> > 
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Mon, 17 Sep 2012 21:18:21 +1000
> > Subject: [PATCH] ARM: retrict TWL4030_CORE to ARM while it is broken
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  drivers/mfd/Kconfig |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index df850c4..af5e5b7 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -257,6 +257,7 @@ config MENELAUS
> >  config TWL4030_CORE
> >  	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
> >  	depends on I2C=y && GENERIC_HARDIRQS
> > +	depends on ARM
> >  	select IRQ_DOMAIN
> >  	help
> >  	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
> 
> Gack. This will break on non-OMAP ARM platforms now too, so it needs to be
> depends on ARCH_OMAP instead of ARM.
> 
> Tony, can I get an Acked-by so I can apply this to next/cleanup? Sam, if
> you prefer to apply it yourself, let me know.

Sorry about this, this driver should work with other SoCs too, not just
ARM. I'll post a better fix until the cpu_is_omap usage is removed.

Regards,

Tony
