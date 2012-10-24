Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab2JXGBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:01:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50240 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2JXGBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:01:52 -0400
Date: Wed, 24 Oct 2012 08:01:38 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kim, Milo" <Milo.Kim@ti.com>, Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] lp855x_bl: use generic PWM functions
Message-ID: <20121024060138.GE9787@avionic-0098.mockup.avionic-design.de>
References: <A874F61F95741C4A9BA573A70FE3998F6417916D@DQHE02.ent.ti.com>
 <20121019082107.GA20659@avionic-0098.mockup.avionic-design.de>
 <A874F61F95741C4A9BA573A70FE3998F641791BB@DQHE02.ent.ti.com>
 <20121022153012.253a6954.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ryJZkp9/svQ58syV"
Content-Disposition: inline
In-Reply-To: <20121022153012.253a6954.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:VvAMuHdcalshlpSTwYBtPQ5MUlhsZWbfmfiPj52Cx8D
 zSZXadfXmlyR4qUG+iHUI09ttDlKqkTFT8rLW+WzP/mPjKiKEL
 7GWqKsyjmj/in06gqUZneQ5f3xaRDUAPlYgDeLbScdqxuWEBAQ
 CtHiu/s/89Oi957u5IkKKvHL8iJis500oGUQ91O05X1k+QTyDb
 AjCLtpNtRK/zKApZ7EZDbq6zb2Y5LV1JJr9qnWCKXv0Vg6Ikzf
 9SXAlwIVd5CdAxIZKnSpf6bSeVqt/3kcf3VlS3oEcRaJ5FgYRe
 A4gKTTaHVvPZnQGG/WshGjTm056rw5Ve4qMiu18dXZMiRaIEi8
 gqtaCDJLpWTG8in0oF76ZIc2lL7XOoI/Wb3uGUTwSI44EsGwKF
 W90dpHzeaulDaaD1BhJD+2BfR4ckCxRULsP2Jw7zhO3xtjd9f4
 RwNqo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ryJZkp9/svQ58syV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 22, 2012 at 03:30:12PM -0700, Andrew Morton wrote:
> On Fri, 19 Oct 2012 08:45:14 +0000
> "Kim, Milo" <Milo.Kim@ti.com> wrote:
>=20
> > > Generally this looks good. Obviously you'll need to update any users =
of
> > > this driver as well. It might make sense to include those changes in
> > > this patch to avoid interim build failures.
> >=20
> > Thanks for your review.
> > So far no usages for this driver in the mainline.
> > I've tested it in my own development environment instead.
> >=20
> > > Other than that I have just one smaller comment below.
> > >=20
> > > > +	pwm_config(lp->pwm, duty, period);
> > > > +	duty =3D=3D 0 ? pwm_disable(lp->pwm) : pwm_enable(lp->pwm);
> > >=20
> > > This is really ugly and should be written explicitly:
> > >=20
> > > 	if (duty =3D=3D 0)
> > > 		pwm_disable(lp->pwm);
> > > 	else
> > > 		pwm_enable(lp->pwm);
> >=20
> > Oh, I prefer using '?' to if-sentence because it looks clear to me.
> > But if it's difficult to read/understand, I'll fix it.
> > I'd like to have others' opinion.
> >=20
>=20
> Hey, it's better than
>=20
> 	(*(duty ? pwm_enable : pwm_disable))(lp->pwm);
>=20
> !

Indeed. Fortunately there don't seem to be overly many of those. Anyway,
thanks for taking these patches.

Thierry

--ryJZkp9/svQ58syV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQh4RCAAoJEN0jrNd/PrOhRiYP/RXJl1gSBQ4DBS8D9RzSGMpz
uFyh88nfXvXqlBieD6UFE1CaYL9u68ByR7XHMRSkxyqfft4QQWrZaj5LQXokxdfM
yilPeCqFbDHVR7mxYG/tIVcP5g8QpiyF7EecboAScjkST0mjh7gFZ+GHC2S2s2qq
PgZQUXWcanKXpv338quekrr3NUTTf9BdIK+fLqdpDn6G7qIp1apN9J4Q2DKZEko5
egiFh2LYnz5Kuy5S2rvd+jUQHKmipYG9anOZuJCYkqFsxOYSOqH5bOT0hRfBJnjK
CmDJixY2ShHlbNxdvOBEW4GbtBfjRV0CO06ZLNW1Gsx3kiYOsq+L1ojBvfBM/zK5
VaqqxSyXIh9N5tITbEJR4z2uPX91gkL2pAZRyKy9dtsCnRjCe3isurNmCyazmb54
fx904ZOphJAWYFq+NT3slsquChZnq47rWeheAR8g0AgaPXeC0jmyA1Y12nXBRriF
/L2GNywW4VQziB/IDqj2ewtKLaj6g0dRuOp9GTXRj0q/jVXDTVTw+q807QcwYs2L
uGkOpGTotpIzFt3AxfmKYHgRU8uSHu5cfEdr9uRGll7E2kVAQ+wzn9UCnkxtS6j5
8OkYmgIlbQ/YUkRxGLNANGtGIRqP/CkdPavklglHOqjZLge5fnKbDsoFxNMLnjeR
k3PD2oc+HET3bSfIR71t
=hfNc
-----END PGP SIGNATURE-----

--ryJZkp9/svQ58syV--
