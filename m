Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2AICsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 21:48:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53091 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129Ab2AICsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 21:48:09 -0500
Message-ID: <1326077272.4097.3.camel@deadeye>
Subject: Re: [PATCH 1/2] topology: Check for missing CPU devices
From: Ben Hutchings <ben@decadent.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
        Thorsten Glaser <tg@mirbsd.de>,
        Debian kernel team <debian-kernel@lists.debian.org>,
        linux-m68k@vger.kernel.org, debian-68k@lists.debian.org
Date: Mon, 09 Jan 2012 02:47:52 +0000
In-Reply-To: <CA+55aFwwnJPpVY++Vgr6p3s47YjdYWV3sgLZzvCtiJp6DEu78Q@mail.gmail.com>
References: <1326055714.13595.309.camel@deadeye>
	 <CA+55aFwwnJPpVY++Vgr6p3s47YjdYWV3sgLZzvCtiJp6DEu78Q@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-TZEdBsyi9cHotEWG7C7+"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TZEdBsyi9cHotEWG7C7+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-01-08 at 16:18 -0800, Linus Torvalds wrote:
> Ok, both of the patches look sane to me, but it would really be nice
> to hear from somebody with the actual affected architectures, and get
> a tested-by.
>=20
> Testing it on hacked-up x86 sounds fine, but doesn't quite have the
> same kind of "yes, this fixes the actual problem" feel to it.

Indeed.

> Also, can you clarify: does the second patch make the first patch just
> an "irrelevant safety net", or are there possible callers of
> topology_add_dev() that could cause problems? I'm just wondering
> whether maybe the safety net ends up then possibly hiding some future
> bug where we (once more) don't register a cpu and then never really
> notice?
[...]

driver_init() doesn't check that cpu_dev_init() - or any of the other
functions it calls - is successful.  So in theory at least we could boot
and still have no CPU devices after the first patch.

Ben.

--=20
Ben Hutchings
Life is what happens to you while you're busy making other plans.
                                                               - John Lenno=
n

--=-TZEdBsyi9cHotEWG7C7+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATwpVWOe/yOyVhhEJAQoSgBAApz+yrWNvQlkjXH+cQTJsguLnUl5QNUXP
YPPty+K7THXk4kguZrQP/GMNkCDHzZVijj8ac6oFyLubU4e94VPk6MaQL7hOxBqY
4nSr1PNgvpm0weod3G9dXPpUG7wOzaxGxwQhEjbKxe//DexiC+Raj+uuvVBNagYo
IDWDSeLY85oP0G3AJQaY5Qjwk5odhpnqOG1/ygQ/jI4PdAH9pMQ4aaS5zY6648xD
kiOsvxsDlIdga6gv2zq0CK8j9Tl2eMp4/JYWwm8RNPa1bUtyPOwSmJRVJSG3QT5F
ImVFUFfTlaCIJlpNJNbuikxPijiybV6Hn4xqMJsBkmM6C+lJKzRn5TeYs+/Oh2nZ
s2F+sP3yv04gTAKhQbiZaksGWRlQhm60jYpuAxRo3qAwixADO61ALqnfnqt68KSP
vXPS4G60BjRGVJZ9vaOeWF+OsU8jdeUe28nSGt8xqwQLstAhM0XMcf47deXriVRe
mQQIGau6Js3y9FyKQLjvj3gCnRZTFX3QLDxeb95CEKSr9toVURw6nbV0ZN6HHgfd
yePsI2ENnK4q9zvg5zUbvRaXhP/O2GxEBq9y0yG1edYbbJo8Nqc+wdVUdeaOUmBT
6sfIYadYcZt+6XwnMFk+deIfn4p3bTZbs5aD+GFUgsi+c96leBMQgL7/Q51HJEpq
uK030Alsb0I=
=/7Dh
-----END PGP SIGNATURE-----

--=-TZEdBsyi9cHotEWG7C7+--
