Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab2IMIBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:01:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36350 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab2IMIBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:01:32 -0400
Date: Thu, 13 Sep 2012 18:01:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20120913180121.7ef388cab4e6af2b8c52c93e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Sep_2012_18_01_21_+1000_HrnNuS_bqXRSNYzx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Sep_2012_18_01_21_+1000_HrnNuS_bqXRSNYzx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

mm/internal.h: In function 'swap_cache_hit':
mm/internal.h:377:3: error: implicit declaration of function 'atomic_dec_if=
_positive' [-Werror=3Dimplicit-function-declaration]

Caused by commit "swap: add a simple detector for inappropriate swapin
readahead" from the akmp tree.  atomic_dec_if_positive() appears to only
exist on avr32, microblaze, mips, powerpc and x86 ...

I have reverted that commit (and the following trivial fix commit) for
today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Sep_2012_18_01_21_+1000_HrnNuS_bqXRSNYzx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUZLRAAoJEECxmPOUX5FElZEP/3/C9ZflT2l4QzZx8+7qIawX
wb3M99kDUQ159Pya+1LolEWSk9tjg+S9EG0H0cUUxQv2MlODOb8umBepNhqP177J
wOJs9wa3hOKaHJV+cb061wcotBF8lkFAtKXoriz0RU0gz1GCXQChVbwfyt7wYd/D
n0UKr471Whd1D2foiTbd6D6A4ksx4JmAMD3yP+WRhu3p4ksICxJuUgNHKDK9xtI4
85tHp0E8hdqRcHtpAQb8HPkCWoq8RvCPpBJc38LZL4nmoQV0Nm30i1VK3+qttSkj
bLiM/AICNQR+AMDi0esBSBtqrufoiNxr65SDLhBnIkk91GlSDtdxhRkJyWNMnCa8
cB/40XIurDxhaTnwH9RaMOuprvo/rPeHDQBvhQ0vmcySfLrgsoYdiq/31vibd9m/
w1vzonMq7QSpR9BJjfQTpVOTJyMayEoxMzxm1pPLPhgA6huWmjFMv529zGKm4BX4
E4IuYMRVNJgznzdkScjzEgIoyob1IKxOl1cgeTIJ6VcSbsVsEnKugDioA3WCdpAK
cCQ2tPuRP251Iq3mqtKaMIph76CLquknX0nwLKqzXF1MnpbwJqYwCyx8u3SsI6lV
yj5xaqa1MRlnBF5ry0gjKvXMjndL1uP7I/s867sV300vk7FmC2h7WLmH7S7I+1WV
p0sVhKnmcfUUDzg+2gn/
=BmV9
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Sep_2012_18_01_21_+1000_HrnNuS_bqXRSNYzx--
