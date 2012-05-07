Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2EGAT6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 20:19:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59968 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab2EGAT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 20:19:57 -0400
Date: Mon, 7 May 2012 10:19:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pierre Carrier <pierre@spotify.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] lib/vsprintf.c: "%#o",0 becomes '0' instead of '00'
Message-Id: <20120507101949.e18a8f3e222b178eeb699cf6@canb.auug.org.au>
In-Reply-To: <1336228350-31148-1-git-send-email-pierre@spotify.com>
References: <1336228350-31148-1-git-send-email-pierre@spotify.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_May_2012_10_19_49_+1000_ff0jPo9JdsAF.+S="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_May_2012_10_19_49_+1000_ff0jPo9JdsAF.+S=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pierre,

Thanks for doing this.  Comments below.

On Sat,  5 May 2012 16:32:30 +0200 Pierre Carrier <pierre@spotify.com> wrot=
e:
>
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index abbabec..7129383 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -284,6 +284,7 @@ char *number(char *buf, char *end, unsigned long long=
 num,
>  	char locase;
>  	int need_pfx =3D ((spec.flags & SPECIAL) && spec.base !=3D 10);
>  	int i;
> +	bool is_null =3D num =3D=3D 0LL;

"num" is a number not a pointer, so I would call it "is_zero" (or just do
the comparisons explicitly below).

>  	/* locase =3D 0 or 0x20. ORing digits or letters with 'locase'
>  	 * produces same digits or (maybe lowercased) letters */
> @@ -353,9 +354,11 @@ char *number(char *buf, char *end, unsigned long lon=
g num,
>  	}
>  	/* "0x" / "0" prefix */
>  	if (need_pfx) {
> -		if (buf < end)
> -			*buf =3D '0';
> -		++buf;
> +		if (spec.base =3D=3D 16 || !is_null) {
> +			if (buf < end)
> +				*buf =3D '0';
> +			++buf;
> +		}
>  		if (spec.base =3D=3D 16) {
>  			if (buf < end)
>  				*buf =3D ('X' | locase);

There is also another earlier section that tests "need_pfx" that reduces
the field width.  You should fix that up as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_May_2012_10_19_49_+1000_ff0jPo9JdsAF.+S=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPpxUlAAoJEECxmPOUX5FEZKEP/iZs5dFD6W/L6C/XTvDDd6Lg
CLa1BVhyrg9EgZQlGEHi76FqjCfO96rHP0/o+iH/i2FRHT5TuFjal1TkHlbX5KND
L7+iapbr4+G8Lc3EGbkrfya44NBgFgkR9evw4q7KnvNe2ZvrbDIfHUqrVq67AP6y
9k56qMmM3u4FzIBUMi2LQF77UkSSO2eEN1kLKpEzsgZU8ngjPON0wpnIiAcZRSKq
LH7TDNRkilf1YMTIhvDRxcPkwZbmjP53z6bn5Odd8ic9DDae1wzZdh091uKrF5RL
jsEx9Bxa0ub3Y8QYttns0crtlM+eqjS4YrQMHdLsq0ida8u0sx7HI3xCtAF1wOvK
xdQL8zkM9EtZnUnkIOmqkjDX5ra28hv3bL1jNAwOjmrl8YYizn7XxGQFdyszVnJ9
h/YL/6bOiY5S3BUoZOoxFv87B/AQyF1V5LvEty+0W7bujfxzPtag/Vwit450Rh6P
5Sxil0KJMVIIp59fweUfcbv07PMcoqIUgfxRgffnsZET4RkGbpxHbjIEsxy3n4Q5
i7PfWdnxmieDiXfJ2llTn7NFLjalD7D7+gUx0lTKC3II0uBeFBp7mBEtAzcBM6/X
uROxhSiy8xsF7zYpYb9yLeKQiuSyAmG+kbzFIKDKYwbvO95WW6IIwwf9dpmCli4i
IKiyxkxCRKxwVDmwTZ8o
=bd/y
-----END PGP SIGNATURE-----

--Signature=_Mon__7_May_2012_10_19_49_+1000_ff0jPo9JdsAF.+S=--
