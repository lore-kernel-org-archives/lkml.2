Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0HPPOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 11:14:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab0HPPOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:14:02 -0400
Subject: Re: [Intel-gfx] Intel graphics CPU usage - SDVO detect bogosity?
From: Adam Jackson <ajax@redhat.com>
To: Andy Lutomirski <luto@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
In-Reply-To: <4C694ABF.6020505@mit.edu>
References: <AANLkTi=NFpeyo7Q31yMfqKSP2c-2OS2ccqa=Q9CQ8bpk@mail.gmail.com>
	 <4C68B92B.3080406@myrealbox.com>
	 <AANLkTinfYBC0=DOzWaGD0DrGH8+M_rFRtuzHrM4yjRxx@mail.gmail.com>
	 <4C694ABF.6020505@mit.edu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ow1TJpG4i8vYcyQ0dZPW"
Date: Mon, 16 Aug 2010 11:13:51 -0400
Message-ID: <1281971631.17843.12721.camel@atropine>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ow1TJpG4i8vYcyQ0dZPW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-08-16 at 10:27 -0400, Andy Lutomirski wrote:

> But that's really the problem, because intel_sdvo_dvi_init contains:
>=20
>          connector->polled =3D DRM_CONNECTOR_POLL_CONNECT | DRM_CONNECTOR=
_POLL_DISCONNECT;
>=20
> I don't know if SDVO is supposed to send hotplug interrupts because
> that section of the docs is incomplete.

SDVO can generate interrupts, although a particular SDVO output type
might not.  (The G45 docs are missing this section, but the 965 docs are
applicable.)  We don't have that turned on, of course, because that
would be entirely too sensible.

You'd probably need to uncomment the #if 0'd intel_sdvo_set_hotplug() in
intel_sdvo.c, and call that from the appropriate bit of
intel_sdvo_init().  For pre-gen4 you'd probably also need to set
SDVO_INTERRUPT_ENABLE in the appropriate SDVOx register, but in gen4+
that bit is used for bpc selection.

Having done that you'd then need to wait the inevitable six months to
find out which SDVO devices actually have functioning hotplug and which
ones are just plain lying about it.

- ajax

--=-Ow1TJpG4i8vYcyQ0dZPW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkxpVa8ACgkQW4otUKDs0NNXSACfRw7Psb6LQ4r8FA20NnGYS7wN
2JwAoKHbz+uuUPUx5Lg2uwUheVOuysrW
=2wLb
-----END PGP SIGNATURE-----

--=-Ow1TJpG4i8vYcyQ0dZPW--

