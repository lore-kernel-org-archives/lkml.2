Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256Ab2DZUuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 16:50:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759063Ab2DZUuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 16:50:50 -0400
Date: Fri, 27 Apr 2012 06:50:40 +1000
From: NeilBrown <neilb@suse.de>
To: Kevin Hilman <khilman@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: omap2+: set IRQCHIP_SKIP_SET_WAKE for INTC
 interrupts.
Message-ID: <20120427065040.3ba0fce2@notabene.brown>
In-Reply-To: <878vhi9qj8.fsf@ti.com>
References: <20120425025637.7832.14013.stgit@notabene.brown>
	<20120425030524.7832.52047.stgit@notabene.brown>
	<878vhi9qj8.fsf@ti.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gNxY65g8Q2c.gsf1zpd1eTy"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gNxY65g8Q2c.gsf1zpd1eTy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Apr 2012 13:39:07 -0700 Kevin Hilman <khilman@ti.com> wrote:

> NeilBrown <neilb@suse.de> writes:
>=20
> > All interrupts can wake-from-sleep (I think) so it should be
> > permissible to call enable_irq_wake().  Setting this flag allows that.
> >
> > It is needed because without this, an interrupt which is delivered
> > during late suspend will get ignored but will not cause suspend to
> > abort.
> > If enable_irq_wake() is called and succeeds, check_wakuep_irqs()
> > will abort the suspend if the interrupt has fired.
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> The name of this flag and the effect of setting it are somewhat
> confusing (e.g. why does skipping set_wake suddenly make wakeups work.)
> So I tried to make it clearer with a reworking of the changelog (below.)
>=20
> If I understood this correctly, and if you're OK with the updated
> changelog, I'll queue this up for v3.5.
>=20

I'm very OK with your updated changelog - thanks.  Filling in various bits
that I didn't know and clarifies the rest :-)

Thanks,
NeilBrown



> Thanks,
>=20
> Kevin
>=20
> >From 644742ddae59731bc10aacde94645d7c49ca5ecd Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Wed, 25 Apr 2012 13:05:24 +1000
> Subject: [PATCH] ARM: omap2+: set IRQCHIP_SKIP_SET_WAKE for INTC interrup=
ts.
>=20
> Without an ->irq_set_wake() method in an irq_chip, calls to
> enable_irq_wake() will fail.  This also causes these interrupts to not
> be able to abort suspend (via check_wakeup_irqs() in late suspend.)
>=20
> Currently, we don't implement ->irq_set_wake() for INTC interrupts
> because they default to be wakeup enabled by setting the GRPSEL bits
> in PM init.  Even though there is no ->irq_set_wake(), we want
> enable_irq_wake() to succeed so these interrupts can abort suspend
> when necessary.
>=20
> To fix, set IRQCHIP_SKIP_SET_WAKE flag for all the INTC
> interrupts which avoids trying to check irq_chip->irq_set_wake()
> and failing when it doesn't exist.
>=20
> Longer term, we need to implement ->irq_set_wake() for the INTC
> which can manage the appropriate GRPSEL bits.
>=20
> Signed-off-by: NeilBrown <neilb@suse.de>
> [khilman@ti.com: rework changelog]
> Signed-off-by: Kevin Hilman <khilman@ti.com>
> ---
>  arch/arm/mach-omap2/irq.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
> index 65f0d257..b0790a9 100644
> --- a/arch/arm/mach-omap2/irq.c
> +++ b/arch/arm/mach-omap2/irq.c
> @@ -148,6 +148,7 @@ omap_alloc_gc(void __iomem *base, unsigned int irq_st=
art, unsigned int num)
>  	ct->chip.irq_ack =3D omap_mask_ack_irq;
>  	ct->chip.irq_mask =3D irq_gc_mask_disable_reg;
>  	ct->chip.irq_unmask =3D irq_gc_unmask_enable_reg;
> +	ct->chip.flags |=3D IRQCHIP_SKIP_SET_WAKE;
> =20
>  	ct->regs.ack =3D INTC_CONTROL;
>  	ct->regs.enable =3D INTC_MIR_CLEAR0;


--Sig_/gNxY65g8Q2c.gsf1zpd1eTy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5m1IDnsnt1WYoG5AQIPOQ/+L+JNkEAJox4Mm6qb0/0OpHHry98AMa2v
57Qr+Fn38JSdpmkdSEI5NMQ5f3kMVmyJmgdTlao5AEQB4Z/AFGVCiFbWfjJyGkRg
RMpWx7gvkX0aYbiQktt6xXnCALVqOXT3z7VLGf3/ExIAUD6w7LfxA3OMqcO/AcSh
bO4PsHLNvasl5A5hQLi4Vid0Z3SRNieYmVSDY0uV9kxZhBOD1raiLf/leS05p6+u
xa8+qXGqVatpbSlR2F+9JZRVHLbJsBxlgKlSTadlQQHh/2aDTFpNZBOc67VRTkvs
lay98YL8lp2c+GlkzV/iwh8Qys/8Kg8dUIETsXoVNQYj6szxDvf9cx4jJdonYsik
f3xBO4iq10oVMIzONNT9wFGr2kwRzYu9oX+htnFtKLWFlMpsg8iXTMIxMQcsOrKS
saTsW7pzJhJonQyxDhKv+hjFprxaJ1266Iq0F+xitSdJnbaHjl4Qa8ttQaWKGKq8
E7KOfb0gcvXGqyHCH53AWlBiaKPgC+f5n0G2mIcInqeDAv2VsA9Qx0LXzpuuIx5q
56to4Z0RnaDsgL/EKTvqizI5NrM2v3hT9oxSspho6jyArWAkF1ytUzZhhiyrgn2s
edgdznmvjQvHg5L6f2Ij7rNxFIn6YaG1AnjeOKI5UjKw54eUgEmrkKrdk1AYI3as
1CJBHReYvwk=
=P0nd
-----END PGP SIGNATURE-----

--Sig_/gNxY65g8Q2c.gsf1zpd1eTy--
