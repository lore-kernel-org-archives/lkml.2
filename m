Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab1JCRs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 13:48:57 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23604 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1JCRsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 13:48:51 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Od75XJf6Cp2pj8V5gKpUn
Date: Mon, 3 Oct 2011 10:48:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Bjarne Steinsbo <bsteinsbo@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/30] ARM: omap: add missing __devexit_p() annotations
Message-ID: <20111003174844.GQ6324@atomide.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-5-git-send-email-arnd@arndb.de>
 <CAFULf_wevZxWW1RW+r-18R_8=ry2kD6_i5L9NfPd9t8afm5Cog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFULf_wevZxWW1RW+r-18R_8=ry2kD6_i5L9NfPd9t8afm5Cog@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bjarne Steinsbo <bsteinsbo@gmail.com> [111002 08:22]:
> Arnd,
> 
> Ref http://www.spinics.net/lists/linux-omap/msg57274.html
> 
> Don't get me wrong.  This is not about you "stealing" my patch, or
> anything like that.  But look also at thread starting at
> http://www.spinics.net/lists/linux-omap/msg57667.html Also a patch
> that I have posted previously.  Something is not right with the
> workflow when bugs are identified, patches are submitted, then
> ignored, only for someone else to fix the same bug.  Enough said.

Arnd, I suggest using Bjarne's earlier patch here:

Acked-by: Tony Lindgren <tony@atomide.com>
 

> On Sun, Oct 2, 2011 at 4:45 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > Drivers that refer to a __devexit function in an operations
> > structure need to annotate that pointer with __devexit_p so
> > replace it with a NULL pointer when the section gets discarded.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  arch/arm/mach-omap2/smartreflex.c |    2 +-
> >  arch/arm/plat-omap/dma.c          |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
> > index 34c01a7..67bc6ce 100644
> > --- a/arch/arm/mach-omap2/smartreflex.c
> > +++ b/arch/arm/mach-omap2/smartreflex.c
> > @@ -1002,7 +1002,7 @@ static int __devexit omap_sr_remove(struct platform_device *pdev)
> >  }
> >
> >  static struct platform_driver smartreflex_driver = {
> > -       .remove         = omap_sr_remove,
> > +       .remove         = __devexit_p(omap_sr_remove),
> >        .driver         = {
> >                .name   = "smartreflex",
> >        },
> > diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
> > index c22217c..f7150ba 100644
> > --- a/arch/arm/plat-omap/dma.c
> > +++ b/arch/arm/plat-omap/dma.c
> > @@ -2105,7 +2105,7 @@ static int __devexit omap_system_dma_remove(struct platform_device *pdev)
> >
> >  static struct platform_driver omap_system_dma_driver = {
> >        .probe          = omap_system_dma_probe,
> > -       .remove         = omap_system_dma_remove,
> > +       .remove         = __devexit_p(omap_system_dma_remove),
> >        .driver         = {
> >                .name   = "omap_dma_system"
> >        },
> > --
> > 1.7.5.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
