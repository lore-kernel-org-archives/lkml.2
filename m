Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab2HUM0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:26:22 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:47606 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755853Ab2HUM0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:26:17 -0400
Date: Tue, 21 Aug 2012 15:22:18 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Poddar, Sourav" <sourav.poddar@ti.com>
Cc: balbi@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [RFC/PATCH 4/4] gpio: smscece: Add support for gpio IO expander
 feature
Message-ID: <20120821122217.GF10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
 <1345545940-2232-5-git-send-email-sourav.poddar@ti.com>
 <20120821105333.GW10347@arwen.pp.htv.fi>
 <CAKdam56DiFpnoQwrHe1tjQWLMy5vP9ynstNj_n=OyMxkJJAUOA@mail.gmail.com>
 <20120821120052.GD10347@arwen.pp.htv.fi>
 <CAKdam55SqXiCGv766yxoY1GdDjxNCYNaDdNZPaeLTAXc+3+c6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tmZL0FsH2xLo8uCy"
Content-Disposition: inline
In-Reply-To: <CAKdam55SqXiCGv766yxoY1GdDjxNCYNaDdNZPaeLTAXc+3+c6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tmZL0FsH2xLo8uCy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 05:50:28PM +0530, Poddar, Sourav wrote:
> Hi,
>=20
> On Tue, Aug 21, 2012 at 5:30 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Tue, Aug 21, 2012 at 05:17:37PM +0530, Poddar, Sourav wrote:
> >> >> +     if (type & IRQ_TYPE_LEVEL_HIGH)
> >> >> +             sg->int_lvl[bank] |=3D bit;
> >> >> +     else if (type & IRQ_TYPE_LEVEL_LOW)
> >> >> +             sg->int_lvl[bank] &=3D ~bit;
> >> >> +     else
> >> >> +             return -EINVAL;
> >> >
> >> > this looks wrong. You could have a user who wants to trigger on both
> >> > HIGH and LOW levels, no ?
> >> >
> >> Yes, I think there can be a scenario where gpio_keys are attached
> >> to this driver and signals a "key press" at low and "key release" at
> >> high. ?
> >>  Will figure out a way to add support to check for case where
> >> both High and low levels are used.
> >
> > could probably be done on a separate patch, maybe... Just now I saw that
> > HIGH and LOW levels use the same bit.
> >
> If I am understanding correctly, if they both uses the same bit we cannot
> use both for a particular user. ?

we can, it's just a bit more complex. If a user request both LOW and
HIGH, then you start with HIGH, once it triggers, before calling the
nested IRQ handler, you need to change it LOW. When low triggers, before
calling the nested IRQ handler, you need to change it to HIGH again. And
so on. I'm just not sure if that's valid on linux IRQ subsystem.

Anyone ?

--=20
balbi

--tmZL0FsH2xLo8uCy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM315AAoJEIaOsuA1yqREck8QALBp1no2U4fGFZTcIQjV0S7d
5WMkiwkq+nRbL44uRITXFQM/+5LCrsFwbqG72LOy+LKOWP6s9IXgBNwyhc00adxu
8Ig11wwUIbyRDGcCBfy6g1itqvsN2/ZhUfKP4Z4cYa4/g5MeECcR+jjDt2KKIjQO
2WYFRP8nyScq2DDQVTUEWzPlEoaKeFIP1zE1KUmrdnZ3B7reNApxCvx1B8foffNV
x/S6Wc9Jv5Z1EySNH1dOCFNG/nQ97bxE09SGuXlpTmAhXiqmjmDomvCj0Wsl82Lu
IPw+BXScVGxPss6LjsqPHhZvXyg7Q6/plciksbBkUzW9o5Ko9mLXfLkKldIXndpB
s4gwvvcl/PEIKIZj7519G+tX7K1lsmHtqU29MDRimaoEzeU1mKV2NWPB3QckVqMI
mpJP2TAIuOZBNe3epLXWoyvYs7V/I3nAyOsSiFBGW/MR/szy/tC2ttBBfcsVOzyI
Z+sbZr99rSq2ShLJ3R/SAn4371p9d0Oyh1TwGxOK45M4hKePZC+f7UyK6pPLFE4f
5iBveAA0zAXI+vddlhZGDYe7QicFv+p6ohRXZPOKJfUOKdXIozkHGwnP4HW8FVXY
9lgd9W14RURGQ1V5r+s3b/qIaGOW84ywFcSD/vetEaWAhbJBRtDoazDNaMlyLXGB
JTBxpJ/mVonkuD8ODY+1
=I3Jp
-----END PGP SIGNATURE-----

--tmZL0FsH2xLo8uCy--
