Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2FYIwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:52:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53875 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048Ab2FYIwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:52:03 -0400
Date: Mon, 25 Jun 2012 09:51:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: =?utf-8?B?7ZWo66qF7KO8?= <myungjoo.ham@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Extcon: Arizona: Add driver for Wolfson Arizona class
 devices
Message-ID: <20120625085151.GB4037@opensource.wolfsonmicro.com>
References: <14300735.10471340599701741.JavaMail.weblogic@epv6ml01>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kY7Q1I7FwGue0/xS"
Content-Disposition: inline
In-Reply-To: <14300735.10471340599701741.JavaMail.weblogic@epv6ml01>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kY7Q1I7FwGue0/xS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 25, 2012 at 04:48:21AM +0000, =ED=95=A8=EB=AA=85=EC=A3=BC wrote:

> > +	/* Microphone detection can't use idle mode */
> > +	pm_runtime_get(info->dev);

> Is it alright to use asynchronous get here?
> (sync not required?)

Yes, it's OK to do this - we're guaranteed that the device is already
enabled at the time we decide to start the microphone detection (as
we're in the middle of examining the state which needs a runtime
reference).  We're taking an additional reference here so that the
device doesn't get powered off again after the event has been handled.

> > +	ret =3D arizona_request_irq(arizona, ARIZONA_IRQ_JD_RISE,
> > +				  "JACKDET rise", arizona_jackdet, info);

> Is this arizone_request_irq using threaded irq? (it's fine if so)

Yes.

--kY7Q1I7FwGue0/xS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP6CaWAAoJEBus8iNuMP3deUoQAJeWfbcf+7X45nLnBTNavhBI
fklY4odkhnmMpeT2eNnEl6j1dlswnZKcKyAlN7diFJ8z/S+q2gLHvfAeozXqVFWQ
H1nmgggsCcroMBswWy2Bnan+HmIq5thta1kNvmM3VKIBK+rNgSXQonibi4844ZCU
jTnQwY+2CLXC2YwHfZs615dr4kl8OQvX4PEdjMBWHLV1HSAekcowj0o7jgr9E8tw
MRnLWcsuPq3S5PyScYThizVsUDfiIzzFXobbGFWXPeHF+T7iOK930sH8VjJva9cl
e7KeMsSDfAVAz1xVgn0aZzDd/0IQxGhWvtRwLT2NbWismkXPPXovb4W9PIvLAha8
hb5UdpwyqbTprmhB2/ENJdJPWqQ80LWjCx2x5oP6dNjK1YmVlJHO3Y3hSWW+ZH7F
QseZRE1iTr9+6EPLbLXwBL0+BjlY6h7/GhtcG0qx8zXTZiyAn9rycWalHyeW1ikE
+qJ82A2+qC79xgKaWhAvujuObG8V1O+dFCD4Cl0s14K0/3zvvNFDZZfAWTfzhnX8
WysUUeyI47aRDDFHhTcxljvKpQ0MKGLVM11GVXUe0yLe0Xc7kXBdtg3nIUdBXvfm
GNw/BnmpXyZatn8SceYMusX+YtkKURiQmL4MutvKBFVRWKnrm2L18mLWCStSlY+F
R2zASkk6tUKHQ0E26j7Z
=pCGX
-----END PGP SIGNATURE-----

--kY7Q1I7FwGue0/xS--
