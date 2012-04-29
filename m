Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2D2Xeh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 19:34:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab2D2Xee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 19:34:34 -0400
Date: Mon, 30 Apr 2012 09:34:30 +1000
From: NeilBrown <neilb@suse.de>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 3/6] twl4030_charger: allow charging whenever VBUS is
 present.
Message-ID: <20120430093430.17efed8a@notabene.brown>
In-Reply-To: <CANOLnOO2kkyPUrRJiF-EX6NddG746gWvJ_fZrZPr0TC6DkbH9g@mail.gmail.com>
References: <20120425072931.20124.56635.stgit@notabene.brown>
	<20120425073310.20124.15112.stgit@notabene.brown>
	<CANOLnOO2kkyPUrRJiF-EX6NddG746gWvJ_fZrZPr0TC6DkbH9g@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IgZlEJprE52JgbA66Ex.pb0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/IgZlEJprE52JgbA66Ex.pb0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Apr 2012 14:33:25 +0300 Grazvydas Ignotas <notasas@gmail.com>
wrote:

> On Wed, Apr 25, 2012 at 10:33 AM, NeilBrown <neilb@suse.de> wrote:
> > We currently refuse to charge if the USB ID pin is grounded, even
> > though VBUS might be present.
> > However some chargers do pull the ID pin low through a resistor which
> > might be as low as 47Kohm (openmoko charger).
> >
> > The documentation is unclear but some experimental evidence suggests
> > that when the charge pump provides VBUS that doesn't get reflected in
> > HW_CONDITIONS, so we should be safe to ignore the ID pin.
>=20
> On pandora I see the opposite, STS_VBUS is set regardless of who
> drives it, so this will break pandora..

OK... I guess this needs more thought.
I'll withdraw this patch and 6/6 for now.
The rest should be good to go.  Maybe I'll resend them an include Anton
Vorontsov..

Thanks,
NeilBrown

>=20
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >
> > =C2=A0drivers/power/twl4030_charger.c | =C2=A0 =C2=A06 +-----
> > =C2=A01 file changed, 1 insertion(+), 5 deletions(-)
> >
> > diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_ch=
arger.c
> > index 0511610..684662a 100644
> > --- a/drivers/power/twl4030_charger.c
> > +++ b/drivers/power/twl4030_charger.c
> > @@ -155,11 +155,7 @@ static int twl4030_bci_have_vbus(struct twl4030_bc=
i *bci)
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_dbg(bci->dev, "check_vbus: HW_CONDITIONS=
 %02x\n", hwsts);
> >
> > - =C2=A0 =C2=A0 =C2=A0 /* in case we also have STS_USB_ID, VBUS is driv=
en by TWL itself */
> > - =C2=A0 =C2=A0 =C2=A0 if ((hwsts & TWL4030_STS_VBUS) && !(hwsts & TWL4=
030_STS_USB_ID))
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;
> > -
> > - =C2=A0 =C2=A0 =C2=A0 return 0;
> > + =C2=A0 =C2=A0 =C2=A0 return (hwsts & TWL4030_STS_VBUS);
> > =C2=A0}
> >
> > =C2=A0/*
> >
> >
>=20
>=20


--Sig_/IgZlEJprE52JgbA66Ex.pb0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT53QBjnsnt1WYoG5AQJIMhAAnujJM2yR8TpVVDkyKYA4Q2vkXM7wDVv8
nR2vuAUxLDQ4URBwylFbvniYnzLEPn/NJ9hI1eBOakVr+sCuoJFpoJsw040ln5+2
lk+QWEPp05kh9inEp0+/Du15eJ7IUrYmhdqbXHqeSmzz7VgihY2j+JDvhX1tR8W+
e0zYJHZ+CWauCW1RnLUrBpCNu1JFBeXJTTk7ivxb87CocDjMbiJMdiqJqhwUj7gj
gt+thlk7NxV4wJ/5WiqFiw7EMV4gCqsxTXqhBZsrWhklbuOjbh9YwvifDLjqWgYY
gGLZy+ib6SZugb95BaDezLdj/7ThRtvTjeOVlad0YxphGm+0eFiRyxTzHwuAK4s8
QlVeY1yjxaa+tSGxSmbRo0LKfBDwEl4IAEfCoIoz9oO+NPt6bKftKoZI1Pcty+qt
0Xj2NxQ52hja0ksu06hGnwza0SdDer/O8ILq84g80hVpWcOAhuV7cDWH01Hgg0EV
za9tkhwtPn5cXKUyUiVOH1sPsyJ5iVhDV8Lp4uPIhi6d9bEvblAoLQHU4cg5bMSg
P8G8iitIPtJazSBzrJWVXK7qe4cu8/RKIb+yQpD32QNC8ekXoxtpoYmNxDK6844/
1Jt70125lKXsQxrxi/3nmo+i6l8uczDMPtO470Tf5ikIDolQkYgNpSbuELrF3KVB
bkM0GB4LQoA=
=VsrG
-----END PGP SIGNATURE-----

--Sig_/IgZlEJprE52JgbA66Ex.pb0--
