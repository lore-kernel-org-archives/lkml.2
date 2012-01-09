Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab2AIC5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 21:57:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53163 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615Ab2AIC5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 21:57:07 -0500
Message-ID: <1326077816.4097.8.camel@deadeye>
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
Date: Mon, 09 Jan 2012 02:56:56 +0000
In-Reply-To: <1326077272.4097.3.camel@deadeye>
References: <1326055714.13595.309.camel@deadeye>
	 <CA+55aFwwnJPpVY++Vgr6p3s47YjdYWV3sgLZzvCtiJp6DEu78Q@mail.gmail.com>
	 <1326077272.4097.3.camel@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+EUPP7btfq7dAMkEb70R"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+EUPP7btfq7dAMkEb70R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-01-09 at 02:47 +0000, Ben Hutchings wrote:
> On Sun, 2012-01-08 at 16:18 -0800, Linus Torvalds wrote:
> > Ok, both of the patches look sane to me, but it would really be nice
> > to hear from somebody with the actual affected architectures, and get
> > a tested-by.
> >=20
> > Testing it on hacked-up x86 sounds fine, but doesn't quite have the
> > same kind of "yes, this fixes the actual problem" feel to it.
>=20
> Indeed.
>=20
> > Also, can you clarify: does the second patch make the first patch just
> > an "irrelevant safety net", or are there possible callers of
> > topology_add_dev() that could cause problems? I'm just wondering
> > whether maybe the safety net ends up then possibly hiding some future
> > bug where we (once more) don't register a cpu and then never really
> > notice?
> [...]
>=20
> driver_init() doesn't check that cpu_dev_init() - or any of the other
> functions it calls - is successful.  So in theory at least we could boot
> and still have no CPU devices after the first patch.

I mean to say that we could have no CPU devices after the *second*
patch.  So the first patch is an extra defence against that.  (Though we
could just as well panic if register_cpu() fails at boot time.)

Ben.

--=20
Ben Hutchings
Life is what happens to you while you're busy making other plans.
                                                               - John Lenno=
n

--=-+EUPP7btfq7dAMkEb70R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATwpXeOe/yOyVhhEJAQqv4hAAmxz39WA7VeE51w9F4/nGB63uYn4aZHMc
GwMczr/JTSE8gL4mmedOY4My7bUEN+l3u+DW6jYqK3FJnNOlSFw7NTHQOkcz/AYW
75sLGGkjRZvwTu/kvOUsuCVRPmyvXkBoLA+r0GYAg3sreauiMOTo+GqygocODi+l
szS/VgMpXyPZIsd8JNXsXKIFUtl+MbF1s/h8YInQmGif9yJ95dBdH7VLawoPjzPE
FH+94hLBPlw9gu0GsmjI5nv+oxqs9qFtK3KPXrqa7DXORK/pMmfg6RfN/Sd59e8S
XcPOr4XS/1+w8Vqo6bEklcH030HnrDl9LyKYDjdL4sGirQMzWgrkB1cWMt/xe8jR
3RnRJA9DKJDz7Q5Bw/nnZwev/fwYHlubmwrfnroQ4Is0ggxpqzXggQPY8WLlsYaa
+36CXjdJN89qGBXej3dm6b3G9QHjIgJUL5bp3n5ZD0iiW/7LiZKUqoIWL7vGgg3U
852yhTojZFPGG0RxJ+cX7ifhz2Gdsymv8hRJXiGRiapWT5tgWcwGbEB/7T2uDu1I
V7jaP8WXGMLO7M6dMmkJ8QrIkqIpKsLpSfF0M6NQ6/vzIqYuqTiX7rBT4heH7/k7
HoY8OMDLZ6wMKlq162d02sWtOY4fEGLM+3SD9hHVAVRsf+H9K3plfKuBA6q/H63H
TBWwomoaQ48=
=olQq
-----END PGP SIGNATURE-----

--=-+EUPP7btfq7dAMkEb70R--
