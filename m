Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab0C3GqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:46:07 -0400
Received: from ozlabs.org ([203.10.76.45]:44664 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab0C3GqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:46:05 -0400
Subject: Re: [PATCH 07/31] lmb: Add reserve_lmb/free_lmb
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BB19656.9040803@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
	 <1269830604-26214-8-git-send-email-yinghai@kernel.org>
	 <1269865322.24620.42.camel@concordia>  <4BB0D92C.3010103@kernel.org>
	 <1269901252.2286.11.camel@concordia> <1269905491.7101.40.camel@pasglop>
	 <4BB13FDB.9060006@kernel.org> <1269926794.7101.46.camel@pasglop>
	 <4BB19656.9040803@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vLj7XHQ4TkGgQS9dvZvf"
Date: Tue, 30 Mar 2010 17:46:02 +1100
Message-ID: <1269931562.15854.83.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vLj7XHQ4TkGgQS9dvZvf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-03-29 at 23:12 -0700, Yinghai Lu wrote:
> On 03/29/2010 10:26 PM, Benjamin Herrenschmidt wrote:
> > On Mon, 2010-03-29 at 17:03 -0700, Yinghai Lu wrote:
> >>
> >> in short: It could make us to avoid use the range that we are going to
> >> reserve,
> >>       when we try to get new position new lmb.reserved.region.=20
> >=20
> > I'm not too sure I follow you. For the resizing, I would just basically
> > call a low level variant of alloc (__lmb_alloc ?) that explicitely
> > doesn't honor the total-2 "reserved" entries in the array.
>=20
> 1. you want to reserve rangeA
> 2. before that will check if region array is big enough,
> 3. if region is not big enough, will call lmb_alloc to get new range.
>    lmb_alloc could return rangB that is overlapped with rangeA

So instead you do it the other way.

1. you want to reserve rangeA
2. you reserve rangeA
3. if reserving rangeA consumed a slot in the array then you check if
you have at least two free slots. If not you realloc. You don't need any
special tricks because you have space to lmb_alloc() a new area and move
everything over.

cheers

--=-vLj7XHQ4TkGgQS9dvZvf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuxnikACgkQdSjSd0sB4dJ/PwCgtPRHdf4Kul/aIgvEPig9BZqa
DX4AoLJkuv3QmeakR+FqgMIrGD6tjppv
=LZVB
-----END PGP SIGNATURE-----

--=-vLj7XHQ4TkGgQS9dvZvf--

