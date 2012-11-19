Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab2KSBGv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 20:06:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab2KSBGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 20:06:50 -0500
Date: Mon, 19 Nov 2012 12:06:32 +1100
From: NeilBrown <neilb@suse.de>
To: Dan Williams <djbw@fb.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
Message-ID: <20121119120632.1c97e306@notabene.brown>
In-Reply-To: <201211081220.55281.b.zolnierkie@samsung.com>
References: <201211081106.29980.b.zolnierkie@samsung.com>
	<20121108111526.40c705a0@pyramind.ukuu.org.uk>
	<201211081220.55281.b.zolnierkie@samsung.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CGEjut4vitKwCKGwiQXBBsp"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CGEjut4vitKwCKGwiQXBBsp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Dan,
 could you comment on this please?  Would it make sense to arrange for erro=
rs
 to propagate up?  Or should we arrange to do a software-fallback in the dma
 engine is a problem?  What sort of things can cause error here anyway?

Thanks,
NeilBrown



On Thu, 08 Nov 2012 12:20:55 +0100 Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:

> On Thursday 08 November 2012 12:15:26 Alan Cox wrote:
> > On Thu, 08 Nov 2012 11:06:29 +0100
> > Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
> >=20
> > > From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > Subject: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
> > >=20
> > > There is not much we can do on dma_wait_for_async_tx() error
> > > so just panic() for now.
> > >=20
> > > Cc: Neil Brown <neilb@suse.de>
> > > Cc: Vinod Koul <vinod.koul@intel.com>
> > > Cc: Dan Williams <djbw@fb.com>
> > > Cc: Tomasz Figa <t.figa@samsung.com>
> > > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > ---
> > >  drivers/md/raid5.c |    4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >=20
> > > Index: b/drivers/md/raid5.c
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > --- a/drivers/md/raid5.c	2012-11-07 16:25:19.480876012 +0100
> > > +++ b/drivers/md/raid5.c	2012-11-07 16:27:46.244875992 +0100
> > > @@ -3223,7 +3223,9 @@ static void handle_stripe_expansion(stru
> > >  	/* done submitting copies, wait for them to complete */
> > >  	if (tx) {
> > >  		async_tx_ack(tx);
> > > -		dma_wait_for_async_tx(tx);
> > > +		if (dma_wait_for_async_tx(tx) !=3D DMA_SUCCESS)
> > > +			panic("%s: DMA error waiting for transaction\n",
> > > +			      __func__);
> >=20
> > Thats a really horrible place to panic.
>=20
> Still it seems better thing to do than silently ignoring errors
> and trying to continue operations with inconsistent data.
>=20
> Unfortunately higher-layers don't support error conditions and
> fixing them seems to be non-trivial task.
>=20
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung Poland R&D Center
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/CGEjut4vitKwCKGwiQXBBsp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKmGGDnsnt1WYoG5AQKUAhAAkhDfnRaMJKye6ycN7dCrAfc/punNkGhM
Lo7GdUr7fBr96YGYVoqW3/v1lTP00kQICPl9LI8soCfIwWyObPrNMmo27KsP1d2F
CFgLRs5JCObYtZNxrzm0lH7RRRyQYar03TSPW8HSv+Sz7SA+n0dng1X17XLHZnck
quP9bvUTQ/fAo1ZYCjEVVvpis2Gmlk0MDvACM2GQBLUHdOYleyVbmIz9zZJb08Q5
uQA2/YQwDp/WY1zpdZmPy+9yJ0tCO6CATnGmLFNjsOogpPlI0eecZstMobJgRy/K
p9+OE2Fb999f4Vb4kUUImC5+36Su3H7vDhoz1nRwmfNI6Ekd4i1L7NdW1w1RgvMh
E1SlNePCyXXktkwyNaYyPKUOe43TPw3gKc0GXcKjQDE5autQMnR0DJpewC3GwfBc
gV41p4SxqMfGTgHeq607qk97KlohOdAS6w8edl7UuN5FqUzMizBJKWr3tCMyR6nI
aS4Yqy7SbuGKPq2rZERrffxZ6ZQMklEWg0YpZjT+++qX1Q/WLsEgjgPU8fUk1E+w
zWP3N9Ns9EURA6uIyXTYaEVvOLSxaCMYwxJu7O9as+IQcxhxStIlJoeWzLfpjOos
m8QBMVNmNliYvypj4T0oJcWWfQVdvXS7PpsEBwRa7rz3Dczwh0Yu79DvBjWi199M
l2h18z1AZpc=
=934d
-----END PGP SIGNATURE-----

--Sig_/CGEjut4vitKwCKGwiQXBBsp--
