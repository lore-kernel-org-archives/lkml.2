Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab2AJKrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:47:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62087 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2AJKra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:47:30 -0500
Date: Tue, 10 Jan 2012 11:44:35 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jamie Iles <jamie@jamieiles.com>
Cc: devicetree-discuss@lists.ozlabs.org, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        "open list:ARM/ATMEL AT91RM9..." 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:ARM/QUALCOMM MSM..." <linux-arm-msm@vger.kernel.org>,
        "open list:OMAP SUPPORT" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2] irqdomain: Initialize number of IRQs for simple
 domains
Message-ID: <20120110104435.GA10617@avionic-0098.mockup.avionic-design.de>
References: <1326191059-26411-1-git-send-email-thierry.reding@avionic-design.de>
 <20120110103905.GC3226@page>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <20120110103905.GC3226@page>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:tNEAvsTBankzfty5OPNmf6ccgkDR+Ywr34YvOhbtHHN
 7W4g1vTR3LfKLJFV4BWDYUlklJKibPXjFxF68pWArFLBm9FZh9
 cdzCg5lb2Al+Ul6kK+oaNCjhbGD8pqGTfAyN4b4srmuZnBiRXC
 4dQ4/pRewx9Qb1yVKRbRwWHUyaUsJgkpFSQcyh0fmfiWosH6rd
 U7R0Cu768E1ejx7cDoHa7rOOK6rmWEA+9EKfMhXKgjl+PeU93x
 4r9ppGtpmrVzvylYQz2azSYBwpvchKN0PFz4VZflxm9iPK8BuD
 NrN6dm9M6SXzUJDLVjlEL/ty4VrvY88fN4Aqa0k2p90HuzkZ0i
 D/QQvEXWHCv+RbOyr+1+J/fOXaBALL8HggQZDepE4K+cTRg1b9
 T32wM3g2RPdthh0wTl5dpHXtUUeh5oOPb9hmChbqhLY1sLXjxL
 3eU7z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Jamie Iles wrote:
> Hi Thierry,
>=20
> On Tue, Jan 10, 2012 at 11:24:11AM +0100, Thierry Reding wrote:
> > The irq_domain_add() function needs the number of interrupts in the
> > domain to properly initialize them. In addition the allocated domain
> > is now returned by the irq_domain_{add,generate}_simple() helpers.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Acked-by: David Brown <davidb@codeaurora.org>
> > ---
> > Note: This patch should not be applied yet. There is a conflict with a
> >       pending patch[0] by Benoit Cousson that will obsolete the OMAP2
> >       hunk in this patch.
> >=20
> >       [0]: http://www.spinics.net/lists/linux-omap/msg62124.html
>=20
> I also have a patch in Russell's tracker to remove one of the calls for=
=20
> versatile (for the VIC) that is no longer needed.

Okay, I'll take a note. I guess it is okay for this patch to go in only aft=
er
the conflicting patches have all been applied. I'm assuming that sooner or
later those patches will land in linux-next and I can rebase this patch on
top, right?

> > diff --git a/arch/arm/mach-imx/imx51-dt.c b/arch/arm/mach-imx/imx51-dt.c
> > index e6bad17..811ce88 100644
> > --- a/arch/arm/mach-imx/imx51-dt.c
> > +++ b/arch/arm/mach-imx/imx51-dt.c
> > @@ -47,7 +47,12 @@ static const struct of_dev_auxdata imx51_auxdata_loo=
kup[] __initconst =3D {
> >  static int __init imx51_tzic_add_irq_domain(struct device_node *np,
> >  				struct device_node *interrupt_parent)
> >  {
> > -	irq_domain_add_simple(np, 0);
> > +	struct irq_domain *domain;
> > +
> > +	domain =3D irq_domain_add_simple(np, 0, TZIC_NUM_IRQS);
> > +	if (!domain)
> > +		return -ENOMEM;
> > +
> >  	return 0;
> >  }
>=20
> A real nit, but could this be written as:
>=20
> 	return irq_domain_add_simple(np, 0, TZIC_NUM_IRQS) ? 0 : -ENOMEM;
>=20
> to make it a little more concise (and the same for the others)?  Not a=20
> big deal though, so either way:
>=20
> Reviewed-by: Jamie Iles <jamie@jamieiles.com>

Yes, I can do that.

Thanks,
Thierry

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8MFpMACgkQZ+BJyKLjJp/WdQCfdRvbIK29QwAps9EH7L0QFHKx
tLYAoJlM7Q1QyLrTQu5eNnwFfHhEdlfB
=IFCD
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
