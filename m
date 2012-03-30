Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888Ab2C3KIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:08:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56525 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755181Ab2C3KIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:08:02 -0400
Date: Fri, 30 Mar 2012 11:07:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Erik Gilling <konkers@google.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        NeilBrown <neilb@suse.de>, gregkh@linuxfoundation.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        myungjoo.ham@gmail.com, John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mike Lockwood <lockwood@android.com>
Subject: Re: [PATCH v6 1/5] Extcon (external connector): import Android's
 switch class and modify.
Message-ID: <20120330100742.GB21950@opensource.wolfsonmicro.com>
References: <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
 <1330344939-18394-2-git-send-email-myungjoo.ham@samsung.com>
 <20120309124119.GV3273@opensource.wolfsonmicro.com>
 <CACSP8ShU5tu=9N53PtYMLyFVFMS9whNRhMvu7nu8rBoPuVCy+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Content-Disposition: inline
In-Reply-To: <CACSP8ShU5tu=9N53PtYMLyFVFMS9whNRhMvu7nu8rBoPuVCy+Q@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 29, 2012 at 03:27:01PM -0700, Erik Gilling wrote:
> On Fri, Mar 9, 2012 at 4:41 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Mon, Feb 27, 2012 at 09:15:35PM +0900, MyungJoo Ham wrote:

> >> +#ifdef CONFIG_ANDROID
> >> + =A0 =A0 =A0 =A0 =A0 =A0 extcon_class =3D class_create(THIS_MODULE, "=
switch");
> >> +#else /* !CONFIG_ANDROID */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 extcon_class =3D class_create(THIS_MODULE, "=
extcon");
> >> +#endif /* CONFIG_ANDROID */

> > This seems somewhat sad - if ANDROID is turned on the standard ABI
> > vanishes. =A0It'd be much nicer to do this with a symlink (or with
> > symlinks within the android directory if the driver core doesn't support
> > that). =A0That way userspace code can be written to the new ABI and will
> > work on Android systems without ifdefery.

> This won't work if userspace code is receiving uevents through netlink
> and comparing based on the device name which it does in android.  Why

That's not really the point here - the point is that the new ABI
vanishes as soon as you turn on the legacy Android ABI.  You're right
that the particular fix I suggested has issues but the overall problem
exists and should be dealt with more sensibly.

> change the name at all?  Extcon is much more specific than "switch."
> A switch can can be used for more than just external connections such
> as availability of HMDI audio (which is only available once a HDMI
> mode is chosen and the interface is enabled.)

I don't know myself, it was called extcon when first proposed for
mainline.  Renaming does have the advantage of indicating to userspace
that this is the mainline, reviewed version and that things might be a
bit different as a result of that review.

Things like the HDMI audio example you cite do seem close enough to the
term to still be useful, they're related to an external connection and
it's state.  If you were really worrying about it you might expect HDMI
audio to be reported via something like the ALSA APIs rather than a
totally unrelated ABI like this.

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPdYW3AAoJEBus8iNuMP3dbW0P/3K5eWThgqG1AI9fW3DjPD7C
9Njol8iu/yGJWGuYSN5gvnqt9fH7NuHgjwOybeGtlGvZw2V3vwygm9payGRvh58W
jyBtSf8VX4246no1KWqwZ2jpzgaEBHJWgBbSe55IaaDEXqlTprESNDM2zK6iyTz4
ydbz9e4y/ObLDYZ+17fC9nzlH9Wlq3DshpXSx75RKAnF6GxKDnupYAoeOlrHkFL2
6KH02Lrp2Jyt4KbPZiCWM02DrLP3e+1Kp5TlOu2VWZnwlTbJAR2S7NzZ3e7dYCzN
QNH/uVCgdhxcgxriJt4ozhpCAHNeYV2uYwr/v6oQGeKWrxdyO5Y9zCINKkRe/CYl
TJU6jakv8PGtIJgQ1QhJzbwFubOGTIqhXTzD7ZfLfsPbsqlXqUH3f0cdwtdtKtv/
6TxR3byFtdsYjSf59QmftrduVcpSMz4/EPhQyJx6rdP6C/u05NljpXbknitkIr3V
0I/OqNY1o+qycP2KghRvY9ZF4ko0unyJEyFki+haPxTnZxB54oywHAbGdV0n51yP
9gcwYJBvIMAzVb4ZPPkRuzPLwpry+C832BFGfSDg/pK9VTNjMJENq50Ltqfy2FaU
Fi7ReOpyKT5auItXC/I+GnOOKo6BWP9tGZXm2wg+AOzIaIUETviQEBALdFEew71R
WlC/jMDLsmuNyQGROc8E
=rqE9
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
