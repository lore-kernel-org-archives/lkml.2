Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab2LBTzR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 14:55:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110Ab2LBTzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 14:55:14 -0500
Date: Mon, 3 Dec 2012 06:54:57 +1100
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chris Ball <cjb@laptop.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] SDIO / PM: Add empty bus-level suspend/resume callbacks
Message-ID: <20121203065457.0bd12fc6@notabene.brown>
In-Reply-To: <2147450.LFoExqrKEF@vostro.rjw.lan>
References: <20120325203849.7a908e32@notabene.brown>
	<201203260029.24826.rjw@sisk.pl>
	<20121202194625.5d66e239@notabene.brown>
	<2147450.LFoExqrKEF@vostro.rjw.lan>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/npdZKBa0_l4gKjTxK3MZwOQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/npdZKBa0_l4gKjTxK3MZwOQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 02 Dec 2012 14:48:50 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday, December 02, 2012 07:46:25 PM NeilBrown wrote:
> > On Mon, 26 Mar 2012 00:29:24 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wr=
ote:
> >=20
> >=20
> > > Thanks for the confirmation.
> > >=20
> > > Below it goes again with a changelog and tags.
> > >=20
> > > I don't really think that SDIO does the right thing here overall, but=
 that's
> > > all I can do to address the problem timely.
> > >=20
> > > Thanks,
> > > Rafael
> >=20
> > Hi Rafael,
> >  I just discovered that this patch has since been reverted - with an 'a=
ck'
> >  from you:
> > ----------
> > commit d8e2ac330f65bcf47e8894fe5331a7e8ee019c06
> > Author: Thierry Reding <thierry.reding@avionic-design.de>
> > Date:   Thu Aug 9 09:32:21 2012 +0000
> >=20
> >     mmc: sdio: Fix PM_SLEEP related build warnings
> >    =20
> >     Power management callbacks defined by SIMPLE_DEV_PM_OPS are only us=
ed if
> >     the PM_SLEEP Kconfig symbol has been defined. If not, the compiler =
will
> >     complain about them being unused. However, since the callback for t=
his
> >     driver doesn't do anything it can just as well be dropped.
> >    =20
> >     Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> >     Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> >     Signed-off-by: Chris Ball <cjb@laptop.org>
> > -----------
> >=20
> > Unsurprisingly the problem which your patch fixed has come back.
> >=20
> > Do you think we could get the patch back in again.  This time maybe we =
should
> > put some comments in there pointing out that having a function which do=
es
> > nothing is very different from not having any function at all?
>=20
> Well, I agree.  I didn't remember that the callback had been added for
> a purpose and hence my "ack" for that patch.
>=20
> What about applying the appended patch (hopefully, the build warnings sho=
uld
> be fixed properly this time)?

Looks good to me - thanks!

NeilBrown

>=20
> Rafael
>=20
>=20
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: SDIO / PM: Add empty bus-level suspend/resume callbacks
>=20
> Suspend methods provided by SDIO drivers are not supposed to be
> called by the PM core.  Instead, when the SDIO core gets to suspend
> a device's ancestor, it calls the device driver's suspend routine.
> However, the PM core executes suspend callback routines directly for
> device drivers whose bus types don't provide suspend callbacks.
> In consequece, because the SDIO bus type doesn't provide a suspend
> callback, the SDIO drivers' suspend routines will be executed by the
> PM core (which shouldn't happen).
>=20
> To prevent this from happening, add empty system suspend/resume
> callbacks for the SDIO bus type.
>=20
> An analogous change had been made already by commit (e841a7c mmc:
> sdio: Use empty system suspend/resume callbacks at the bus level),
> but then it was reverted inadvertently by commit (d8e2ac3 mmc: sdio:
> Fix PM_SLEEP related build warnings) that attempted to fix build
> warnings introduced by commit e841a7c.
>=20
> Reported-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/mmc/core/sdio_bus.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>=20
> Index: linux/drivers/mmc/core/sdio_bus.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/mmc/core/sdio_bus.c
> +++ linux/drivers/mmc/core/sdio_bus.c
> @@ -193,7 +193,21 @@ static int sdio_bus_remove(struct device
>  }
> =20
>  #ifdef CONFIG_PM
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int pm_no_operation(struct device *dev)
> +{
> +	/*
> +	 * Prevent the PM core from calling SDIO device drivers' suspend
> +	 * callback routines, which it is not supposed to do, by using this
> +	 * empty function as the bus type suspend callaback for SDIO.
> +	 */
> +	return 0;
> +}
> +#endif
> +
>  static const struct dev_pm_ops sdio_bus_pm_ops =3D {
> +	SET_SYSTEM_SLEEP_PM_OPS(pm_no_operation, pm_no_operation)
>  	SET_RUNTIME_PM_OPS(
>  		pm_generic_runtime_suspend,
>  		pm_generic_runtime_resume,
>=20
>=20


--Sig_/npdZKBa0_l4gKjTxK3MZwOQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULuyETnsnt1WYoG5AQLY5Q//TI530zPPtHXubF/0HVnmcbOH7Kpqyrzj
oqwjMErbAmeOjEi4kDFqjjnopRYyHhdTo26BrFt0Jtz9BUKsoJoD2/kUX9wURaFW
3x+slSSDSXe8+bTmQPfua2Dpj3yROUJJbWlUHnbDbLSnkXhJRgNCALsM6XErIm+5
cxSrKaahrJSN7cGnPa0c2EtVa7EDyBeyR+Ne9S4FeGXJ3kV/ZSyw8BAEjIQLKzCK
9ZEJxeRkzieb9y1NeDoPA4QmtIIbhba8XnbR6XAQV7Z5/mLyRmtKY0kojBjfQ6Ko
a/BRZoZEG6lLgpn941SYppVcmv7lExHgTfwovt76ik8Exkc4wJwXtty1XBLtcp16
+/EO4o3rAQbtPPSWUofMcCDPpm1YhPSK3GhAjirjE197A6zXqA4kb0SxuikxzyZV
/+K3T0aedj/PA1dAjb8OGFXaMUzVKGd3fSTb/3bIyjI0w6awfIRNNPgv1Epu9+uv
gPeZAhcLvWCeyQSYy07VwEbaveMxgkqT6iHPYAHEAQ6O9lHoHzGwdy4fXefzuwVC
k9qpbuSfnV3D9IbY2x7yqdlZCDDCrwwsKpcQpS9s1xmwJ3/0IaUBJKRkLAf/B0RZ
6YtuKVnLas1mxDz2tIrD04zvimoZ4HC7f+Psr/o/aQleYLLzCXKaNoNLyCSu2N6q
qlu+zOU7920=
=SYzC
-----END PGP SIGNATURE-----

--Sig_/npdZKBa0_l4gKjTxK3MZwOQ--
