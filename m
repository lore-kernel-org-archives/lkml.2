Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761982Ab2DLDKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 23:10:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47728 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab2DLDKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 23:10:48 -0400
Date: Thu, 12 Apr 2012 13:10:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, tony@bakeyournoodle.com, mmarek@suse.cz,
        lacombar@gmail.com
Subject: Re: [PATCH 0/5] RFC: strip 15,000 lines from a typical autoconf.h
Message-Id: <20120412131037.5371c8b0d9e2dde32e06f8ce@canb.auug.org.au>
In-Reply-To: <CA+55aFx9WXtF7LT9rHv0=e0jqAq+b1cDPcRzSGDKvy7+XjxxtA@mail.gmail.com>
References: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
	<CA+55aFy-CeLXstbceP7+co3AXrEWtifKF+8NWzhC7B-A8xBd-w@mail.gmail.com>
	<CA+55aFx6V_TpbghsG7xqoBree8ALAKWMA+qLeGg-8DNAno+peg@mail.gmail.com>
	<20120411184538.ec21844a.akpm@linux-foundation.org>
	<CA+55aFx9WXtF7LT9rHv0=e0jqAq+b1cDPcRzSGDKvy7+XjxxtA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__12_Apr_2012_13_10_37_+1000_=N4Wa5JBQHw2Pbaw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Apr_2012_13_10_37_+1000_=N4Wa5JBQHw2Pbaw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Wed, 11 Apr 2012 18:55:10 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Wed, Apr 11, 2012 at 6:45 PM, Andrew Morton <akpm@linux-foundation.org=
> wrote:
> >
> > So we shouldn't call it IS_DEFINED() - that would cause confusion with
> > the old version.
>=20
> Yeah. Maybe we should call it "config_enabled()" - the lower-case
> hopefully makes it clear that it acts as a C function, not a
> preprocessor one.
>=20
> Code like "if (config_enabled(IPV6))" looks reasonably readable to me.
>=20
> I asked G+ if they can come up with a better trick. They did well on
> the whole bitmask calculations, maybe somebody can figure out how to
> make the same macro work for both preprocessor and C code...

Can we leave the CONFIG_ part in the caller, so they are still grepable, pl=
ease?

So:

	#define	config_enabled(x)	(__stringify(x)[0] =3D=3D '1')

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__12_Apr_2012_13_10_37_+1000_=N4Wa5JBQHw2Pbaw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPhketAAoJEECxmPOUX5FEllAQAJJPAh7WMBihnfl/YnS9WftZ
cOJlwsi7UVERU8LKuEcwz5/FdHRpr5NKMa2tmRvYq8F9J9K8BpYr4oe7rRM/Pbzg
aOgVEQK/2u7ziC79TwI9mOPYvYYXHdloUNAz/H4M7y2Kq/Wc2FNWoY6MdG3DKe7+
Rpp/5Q4jd2hblD2yqzRc9scVp0Pr1BJzac/6Qd3tm7pmp5B1SgGThjQNFxDU7KN8
KpPOJtKEDjudrrtSfjI8zLLy0dQIn+FUvN0RAo4OuR1tx6jl+gJBJMpWgvzFOIuf
Vh64rRLVm9UP5d+4UVh5K7y5T6fq3VaJRCvh2i2/grQvYtPBsuL9jzZ0cRgJvrko
8w+BNPsxkKmJ6yRFS3FzeiFcKD/S9IKDBcY8fMCPTP+EKMz63SlvXTQ+rUKEZHow
zuA3ZXCMV+csjusm8JU7eaMHCQT1zd0gZnhL2+m76ASJjmTqaiZO6tWgxOHcy8cx
ktE253r4IsUkduuErfo5x2/OnEioVcPGUyzYCObYMqZT/uEhufahiRkcoyhDOyDJ
z+AaCw5rTyWrkyHcteBUfTERgm6Q7psL19cv7U38LTo9lXZRMf79/sc71NqPjC2V
1ACtuovi1GKEzbLwnSYbv/5N5Vv9+nxeOBz9nsa3/H/7NkIQTGg7TRQAS+euU2f8
voQSs4JHAH1IP5hM6rXW
=iJX2
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Apr_2012_13_10_37_+1000_=N4Wa5JBQHw2Pbaw--
