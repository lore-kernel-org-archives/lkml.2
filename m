Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0DGXfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:35:11 -0400
Received: from ozlabs.org ([203.10.76.45]:38680 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab0DGXfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:35:09 -0400
Subject: Re: [PATCH 06/33] lmb: Add lmb_reserve_area/lmb_free_area
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1270001838-15857-7-git-send-email-yinghai@kernel.org>
References: <1270001838-15857-1-git-send-email-yinghai@kernel.org>
	 <1270001838-15857-7-git-send-email-yinghai@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-RO9zwjSQmvvr/gzyWkoB"
Date: Thu, 08 Apr 2010 09:35:08 +1000
Message-ID: <1270683308.9521.7.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RO9zwjSQmvvr/gzyWkoB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-03-30 at 19:16 -0700, Yinghai Lu wrote:
> They will check if the region array is big enough.
>=20
> __check_and_double_region_array will try to double the region array if th=
at
> array spare slots is not big enough.  Old array will be copied to new arr=
ay.
>=20

> diff --git a/include/linux/lmb.h b/include/linux/lmb.h
> index 4cf2f3b..598662f 100644
> --- a/include/linux/lmb.h
> +++ b/include/linux/lmb.h
> @@ -83,6 +84,9 @@ lmb_end_pfn(struct lmb_region *type, unsigned long regi=
on_nr)
>  	       lmb_size_pages(type, region_nr);
>  }
> =20
> +void lmb_reserve_area(u64 start, u64 end, char *name);
> +void lmb_free_area(u64 start, u64 end);
> +void lmb_add_memory(u64 start, u64 end);

vs

extern long lmb_reserve(u64 base, u64 size);
extern long lmb_free(u64 base, u64 size);  =20
extern long lmb_add(u64 base, u64 size);                                   =
=20
                        =20

Can you tell which ones handle dynamically expanding the region array?

You're _still_ adding a new API, which I still think is stupid.

cheers

--=-RO9zwjSQmvvr/gzyWkoB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAku9FqgACgkQdSjSd0sB4dLgfACgjIbZTKa2rEnCBtE8kYwia5xW
I2kAoMAErefZjHF4gscrTBT3ckVtYS95
=VMrI
-----END PGP SIGNATURE-----

--=-RO9zwjSQmvvr/gzyWkoB--

