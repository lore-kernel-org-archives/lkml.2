Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1D1V2C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 17:28:02 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:48733 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab1D1V2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 17:28:00 -0400
X-Spam-ASN: 
Date: Fri, 29 Apr 2011 01:27:48 +0400
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: James Nuss <jamesnuss@nanometrics.ca>,
        Rodolfo Giometti <rodolfo.giometti@enneenne.com>,
        linuxpps@ml.enneenne.com, linux-kernel@vger.kernel.org
Subject: Re: [LinuxPPS] [PATCH 2/2] pps: new client driver using IRQs
Message-ID: <20110429012748.704a39a6@apollo.gnet>
In-Reply-To: <20110429005524.67600139@apollo.gnet>
References: <1303928054-14662-3-git-send-email-jamesnuss@nanometrics.ca>
	<20110428152222.0271163f@apollo.gnet>
	<BANLkTimG0vL3Ky=ARa+7XyW4PSFdg064YQ@mail.gmail.com>
	<20110429005524.67600139@apollo.gnet>
Organization: LVK
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/AT_Ji3ikFQ1e9ReOAiPK8wz"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/AT_Ji3ikFQ1e9ReOAiPK8wz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Fri, 29 Apr 2011 00:55:24 +0400
Alexander Gordeev <lasaine@lvk.cs.msu.su> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> =D0=92 Thu, 28 Apr 2011 16:03:59 -0400
> James Nuss <jamesnuss@nanometrics.ca> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>=20
> > Hi Alexander,
> >=20
> > Thanks for reviewing the code.
> >=20
> > On Thu, Apr 28, 2011 at 7:22 AM, Alexander Gordeev
> > <lasaine@lvk.cs.msu.su> wrote:
> > > Hi James,
> > >
> > > =D0=92 Wed, 27 Apr 2011 14:14:14 -0400
> > > James Nuss <jamesnuss@nanometrics.ca> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > >
> > >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> > >> + =C2=A0 =C2=A0 }
> > >> +
> > >> + =C2=A0 =C2=A0 res =3D platform_get_resource(pdev, IORESOURCE_IRQ, =
0);
> > >> + =C2=A0 =C2=A0 if (res =3D=3D NULL) {
> > >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_err(PPS_IRQ_NAME ": n=
o IRQ resource was given");
> > >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> > >> + =C2=A0 =C2=A0 }
> > >> +
> > >> + =C2=A0 =C2=A0 if (!(res->flags & (IRQF_TRIGGER_RISING | IRQF_TRIGG=
ER_FALLING))) {
> > >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_err(PPS_IRQ_NAME ": g=
iven IRQ resource must be edge triggered");
> > >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> > >> + =C2=A0 =C2=A0 }
> > >
> > > I think it doesn't actually expect that both flags are set because it
> > > always treats it as assert in the irq handler. What does your signal
> > > look like?
> >=20
> > The conditional logic is that one of either IRQF_TRIGGER_RISING or
> > IRQF_TRIGGER_FALLING must be set. It doesn't make much sense to have
> > neither set for PPS signals.
> > My intention is that the driver is generic enough so you can register
> > an IRQ resource with either IRQF_TRIGGER_RISING or
> > IRQF_TRIGGER_FALLING and you will get and assert event for that edge.
> > Clear events are not generated as you suggest but I believe this is
> > OK.
> > My signal is a simple low-to-high transition indicating the PPS. But I
> > believe you could register a device using this driver referencing the
> > other edge if required.
>=20
> Ok, but is there a way one can register an IRQ resource with both flags
> set? If yes, then it would be nice to have a stricter check here to
> prevent two situations:
> 1. none flag is set (it is already in place)
> 2. both flags are set
>=20
> The latter will definitely mess things up, right?

I mean, one surely can register an IRQ resource with both flags set. And
if the underlying hardware works as it is described (i.e. raises an irq
on both edges) then it will be a problem.

--=20
  Alexander

--Sig_/AT_Ji3ikFQ1e9ReOAiPK8wz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBCAAGBQJNudvUAAoJEElrwznyooJbg3wH/RXjCYkGOQKMB4aKdwfmRwMP
xOPmJsSxTs8DAKN/cp/jHY5KLHfYoSB7LqvEpCp3XJHtaleEEYT3/YsdHnrwsRmd
5bZHLE9qV3jS6mBAHNRj6R3W+OfQpf3f86NkVCNFsXXovFoo7rL+CqAr7V+e9+3e
9zkHmy/hC9BwS7ilixeUuo0uf/TSCELWJruN2bSuXoAhQdIx1+Fss74O6fRLzp9G
HG04/qL4lG7k0zasnyrN5O1Ok3dKuanlNzyGYVSSqCX4Ym3/iucBWAowQwqdfMr0
dPK64+Ia7rWtSF8+TE0CF3SI49ICEeGAZeJ7v4KqWvn+de3BpyWCK+mU7YkuoOE=
=rKdE
-----END PGP SIGNATURE-----

--Sig_/AT_Ji3ikFQ1e9ReOAiPK8wz--
