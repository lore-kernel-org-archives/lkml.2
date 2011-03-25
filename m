Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab1CYFZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 01:25:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46561 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab1CYFZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 01:25:49 -0400
Date: Fri, 25 Mar 2011 16:25:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the block tree
Message-Id: <20110325162536.368d5160.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTimZb9x7-5maMU-jibxLdq1pW=CVE4ABXsX6jJRN@mail.gmail.com>
References: <20110325143049.2e65091f.sfr@canb.auug.org.au>
	<AANLkTimZb9x7-5maMU-jibxLdq1pW=CVE4ABXsX6jJRN@mail.gmail.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__25_Mar_2011_16_25_36_+1100_EPu6g6G/V9PezDfc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Mar_2011_16_25_36_+1100_EPu6g6G/V9PezDfc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 25 Mar 2011 13:08:51 +0900 Akinobu Mita <akinobu.mita@gmail.com> wr=
ote:
>
> Please remove "#include <asm-generic/bitops/le.h>" from this file.

Indeed that is required, or in some circumstances you get these errors
(from a powerpc allyesonfig build):

In file included from drivers/block/drbd/drbd_bitmap.c:32:
include/asm-generic/bitops/le.h:45: error: conflicting types for 'test_bit_=
le'
arch/powerpc/include/asm/bitops.h:284: note: previous definition of 'test_b=
it_le' was here
include/asm-generic/bitops/le.h:50: error: redefinition of '__set_bit_le'
arch/powerpc/include/asm/bitops.h:291: note: previous definition of '__set_=
bit_le' was here
include/asm-generic/bitops/le.h:55: error: redefinition of '__clear_bit_le'
arch/powerpc/include/asm/bitops.h:296: note: previous definition of '__clea=
r_bit_le' was here
include/asm-generic/bitops/le.h:60: error: redefinition of 'test_and_set_bi=
t_le'
arch/powerpc/include/asm/bitops.h:301: note: previous definition of 'test_a=
nd_set_bit_le' was here
include/asm-generic/bitops/le.h:65: error: redefinition of 'test_and_clear_=
bit_le'
arch/powerpc/include/asm/bitops.h:306: note: previous definition of 'test_a=
nd_clear_bit_le' was here
include/asm-generic/bitops/le.h:70: error: redefinition of '__test_and_set_=
bit_le'
arch/powerpc/include/asm/bitops.h:311: note: previous definition of '__test=
_and_set_bit_le' was here
include/asm-generic/bitops/le.h:75: error: redefinition of '__test_and_clea=
r_bit_le'
arch/powerpc/include/asm/bitops.h:316: note: previous definition of '__test=
_and_clear_bit_le' was here

This is fixed by reverting commit f0ff1357ce39 ("drbd: need include for
bitops functions declarations").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Mar_2011_16_25_36_+1100_EPu6g6G/V9PezDfc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNjCdQAAoJEDMEi1NhKgbslQIH/RQZNNtcTKaVrST6/jETXB7a
Y48SFBZF/UDXCTqPWH6l1kP8e/erF+tm88rbMmcHq5//9+1EXboqrFQW/wVxSM2u
FeT/vZWMnauuJ/yGETxUAjIaaTafHX76+X1Qybq40/WLDm0VvnjXegTeLiG8lXd1
wo3nVTktmN2is7r/MlJeRZWMD14dylXvGng8+S8xTuHz7gSDA3YVa5t9dGYpzEcL
W3KgBJGzM406Z9aBmWkTAVavV98tIAIdKZ9M98LW76SUDLong4jHBKpwysL0UlP/
xAd4Mqb+aZuFS2qO6g0GnhCAf1vL/cPlX/irMpKqkXGZ267I/p0nRAg18jkiffM=
=+eaN
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Mar_2011_16_25_36_+1100_EPu6g6G/V9PezDfc--
