Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0KXWoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 17:44:11 -0500
Received: from ozlabs.org ([203.10.76.45]:34493 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab0KXWoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 17:44:09 -0500
Subject: Re: How do I choose an arbitrary minor number for my tty device?
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Greg KH <gregkh@suse.de>
Cc: Scott Wood <scottwood@freescale.com>, Timur Tabi <timur@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        devicetree-discuss@vger.kernel.org
In-Reply-To: <20101124182353.GA10589@suse.de>
References: <4CE45A4E.70308@freescale.com> <20101118022434.GA9833@suse.de>
	 <4CE546C5.8060401@freescale.com> <20101118153912.GA1443@suse.de>
	 <4CE54E40.9040503@freescale.com>
	 <20101118112146.3275eb08@udp111988uds.am.freescale.net>
	 <4CE5657D.8060105@freescale.com>
	 <20101118121356.3491da72@udp111988uds.am.freescale.net>
	 <1290594227.4446.12.camel@concordia>
	 <20101124120818.7951bcb4@udp111988uds.am.freescale.net>
	 <20101124182353.GA10589@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Eku0tbkG6JAdlyszpVzr"
Date: Thu, 25 Nov 2010 09:44:07 +1100
Message-ID: <1290638647.14502.10.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Eku0tbkG6JAdlyszpVzr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-11-24 at 10:23 -0800, Greg KH wrote:
> On Wed, Nov 24, 2010 at 12:08:18PM -0600, Scott Wood wrote:
> > On Wed, 24 Nov 2010 21:23:47 +1100
> > Michael Ellerman <michael@ellerman.id.au> wrote:
> >=20
> > > On Thu, 2010-11-18 at 12:13 -0600, Scott Wood wrote:
> > > > Unfortunately, it's not an exact match, and the fact that reg doesn=
't
> > > > translate to a physical address means that AFAICT you'll currently =
get
> > > > something like "byte-channel.nnn", where "nnn" is an arbitrary
> > > > kernel-assigned number.
> > >=20
> > > Can you not use device_rename() ?
> >=20
> > Ah, didn't know about that.  Still, might be nice to add support for
> > "handle" nodes at the infrastructure level rather than in each driver.
>=20
> No, please never use that function, bad things will happen.

Why? The network & wireless code uses it, so presumably it can work? If
not please consider:

commit f470f680dfaad8731f079a033a50440082e20930
Author: Michael Ellerman <michael@ellerman.id.au>
Date:   Thu Nov 25 09:41:28 2010 +1100

    driver core: Document that device_rename() is not to be used
   =20
    Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6ed6454..f1fac19 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1513,6 +1513,8 @@ EXPORT_SYMBOL_GPL(device_destroy);
  * exclusion between two different calls of device_rename
  * on the same device to ensure that new_name is valid and
  * won't conflict with other devices.
+ *
+ * "Never use this function, bad things will happen" - gregkh
  */
 int device_rename(struct device *dev, const char *new_name)
 {


--=-Eku0tbkG6JAdlyszpVzr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkztlTQACgkQdSjSd0sB4dLJOgCgnSMumalbM18SMJhbxfp7vFxq
RUYAoMvwENtZyg4iIIYXP5bGmugqi7Hp
=MgbL
-----END PGP SIGNATURE-----

--=-Eku0tbkG6JAdlyszpVzr--

