Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab2JVIE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:04:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58833 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2JVIEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:04:23 -0400
Date: Mon, 22 Oct 2012 10:04:14 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] PWM: vt8500: Update vt8500 PWM driver support
Message-ID: <20121022080414.GB4931@avionic-0098.mockup.avionic-design.de>
References: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz>
 <1350643135-13197-2-git-send-email-linux@prisktech.co.nz>
 <20121022063423.GA17181@avionic-0098.mockup.avionic-design.de>
 <1350888712.3592.11.camel@gitbox>
 <1350889747.3592.17.camel@gitbox>
 <20121022072448.GB30026@avionic-0098.mockup.avionic-design.de>
 <1350891382.3592.22.camel@gitbox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
In-Reply-To: <1350891382.3592.22.camel@gitbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:S8j75BOo1MZW1RJLn+41whRRgYMeVqqP2dylYUfC/Wz
 hsgG744olqxJFWxqsD3vB49ERJer3yxJaxCxdRXAFi1sRry2Jw
 6vdfxIgbi2+SrfShizchTpXdEu/goE+36k4AYVMyNEvwG4EhSE
 GtlCNLSkMB3MfVUzfnpWOwUi4hw0Gjn/gtKmtLRI6Rau+S1o+u
 G/qbDv2R+oKYau9yPgR4Jk0Bdk5A4RTuSU8cSJt3xRUJwXOUNC
 MyEYcA3OhDm63fENsYfRGg0wgZ6DYaDHD6W/yXWs0Jpo1H7670
 Phfq/CakxrdhfbIzo2vsCr3PcFIokRidhqMT6p4HUpTIorL6kR
 C6DvrRH9VEymf1oYcpqPdU1KImUp2B7t6aMz2sEmxcewuDsQVc
 082X7j2c69ZQQk3tvaeSH9Us5TlYCy5HiOEAAPTMv6MD3HNqbH
 nDQyV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 22, 2012 at 08:36:22PM +1300, Tony Prisk wrote:
> On Mon, 2012-10-22 at 09:24 +0200, Thierry Reding wrote:
> > On Mon, Oct 22, 2012 at 08:09:07PM +1300, Tony Prisk wrote:
> > > On Mon, 2012-10-22 at 19:51 +1300, Tony Prisk wrote:
> > > > >=20
> > > > > >  	chip =3D devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
> > > > > >  	if (chip =3D=3D NULL) {
> > > > > >  		dev_err(&pdev->dev, "failed to allocate memory\n");
> > > > > > @@ -123,26 +144,32 @@ static int __devinit pwm_probe(struct pla=
tform_device *pdev)
> > > > > >  	chip->chip.ops =3D &vt8500_pwm_ops;
> > > > > >  	chip->chip.base =3D -1;
> > > > > >  	chip->chip.npwm =3D VT8500_NR_PWMS;
> > > > > > +	chip->clk =3D of_clk_get(np, 0);
> > > > >=20
> > > > > I thought this was supposed to work transparently across OF and !=
OF
> > > > > configurations by using just clk_get() or devm_clk_get()? I guess=
 that
> > > > > if the driver depends on OF, then this would be moot, but we shou=
ld
> > > > > probably stick to the standard usage anyway.
> > > > >=20
> > > > > Furthermore, of_clk_get() doesn't seem to be managed, so you'd ne=
ed to
> > > > > add explicit clk_put() in the error cleanup paths. One more argum=
ent in
> > > > > favour of using devm_clk_get() instead.
> > > >=20
> > > > Hmm good point. I stuck with of_ functions because its an OF only d=
river
> > > > and it seemed 'backward' to mix old code with new. It does pose the
> > > > question of 'why have of_clk_get() if existing functions work bette=
r'.
> > >=20
> > > Was about to fix this but noticed why it wasn't like this to start
> > > with :)
> > >=20
> > > struct clk *devm_clk_get(struct device *dev, const char *id);
> > > struct clk *of_clk_get(struct device_node *np, int index);
> > >=20
> > > devm_clk_get requires me to 'get' the clock by name. arch-vt8500 (and=
 I
> > > believe a lot of other arch's) don't enforce names for clocks defined=
 in
> > > devicetree, therefore there is no way for me to know what name the clk
> > > has unless I include in the binding that the clock must be named 'xxx=
'.
> >=20
> > I thought clk_get() was supposed to return the first clock specified in
> > DT if you pass NULL as the consumer name. I haven't tested this though.
> > And I haven't looked at the code.
> >=20
> > > of_clk_get retrieves it by the dt-node + index, so it doesn't care as
> > > long as its the 1st clock listed.
> >=20
> > So the usual way to do this, I believe, is:
> >=20
> > 	clocks =3D <&clk_foo>;
> > 	clock-names =3D "foo";
> >=20
> > Then use:
> >=20
> > 	clk =3D devm_clk_get(&pdev->dev, "foo");
> >=20
> > And as I said above, I was under the impression that the default would
> > be to use the first clock if NULL was specified instead of "foo".
> >=20
> > Thierry
>=20
> clock-names is an optional property (as defined in
> bindings/clock/clock-bindings.txt) so relying on it is .. well,
> unreliable.
>=20
> What you say makes sense, but it means the binding document has to make
> an optional property into a required property simply to use an 'old'
> function when a new function would 'work' (granted not as well, as you
> pointed out) without requiring the optional property.

Okay, I've just checked the core clock code, and indeed if you run
clk_get() with con_id set to NULL, you'll eventually call of_clk_get()
with index =3D=3D 0. That's exactly what you want, right? The only setup
where this won't work out is if you need to handle multiple clocks, in
which case I think it would make sense to make the clock-names property
mandatory. But for this driver that won't be necessary, since it will
never use a second clock, right?

> Your subsystem - your rules. Let me know if I've managed to sway you or
> not :)

I'd rather persuade you than force the issue. =3D)

Thierry

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhP3+AAoJEN0jrNd/PrOhh1sP/1fGl2iciTf4Anwizp7Ky8HO
nm+zgL3pvMjVlQE1lDEZx3sQwuSzBITcytKQbgThoJTfBMGJjKo9BM6ANWN+pWik
njAKOHhhawWz2mFtruVYHh3HRXHIc+awqEzZBSU0t4vus+pWuC/cVFzErfzq0ZNW
N4E9TIlHSY0nmo9WEa7nGgj6Z2sW0A5gxCZBvjiobp6PncPhe0GUM/8XHJst0vgw
fhU+bbowkEAu7muI3pvDCAkPc+yhJEFYFFD6QWExrxmFGm3+ng9MfZY36uXphTyC
kyBltX96Z47tlewP1bcImw27Rprl+SVOVe1UjTxOOVpL3nylmbDj63s5AjiMHm86
yJ2k7IxysVACEP2Pik+2dCl/glQOrRUq2oMqcwUzxxaKhQaN7Y0O+pfx+Q392UrH
xAoIpcF0e7AUOqhSA51U3C0a8bq9pyDlYm3HDBO5ISqnlBNYwsPoqwUOqf2I8rBF
Ihx0jvWVrUh/lXVYQReFqsw5QLn+M0yC5BDqz26IDlfPFVzjXTJQg5+YoD9djNky
eBWJbSYHD1kubVj5/d5iyHbgzVIPkzRY64vRwe4MDEm/xxNWhhc74Bd5y3l8gJVT
TUnCCHqfyhFdJasnc0Hq9NMkakAThM3m1Dau0XZB+gjk5fbJ3Z1glP+xEo4onaUF
Avlq0kdrD8OenyBBv5L0
=1esU
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
