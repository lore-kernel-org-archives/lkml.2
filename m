Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab2BQFVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 00:21:17 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49447 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2BQFVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 00:21:15 -0500
Date: Fri, 17 Feb 2012 16:21:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120217162100.8a19122e8b566322f47af9fe@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Feb_2012_16_21_00_+1100_kcjAl+Yj1fL1yUdA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Feb_2012_16_21_00_+1100_kcjAl+Yj1fL1yUdA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from /scratch/sfr/next/include/linux/stat.h:60:0,
                 from /scratch/sfr/next/include/linux/module.h:10,
                 from /scratch/sfr/next/init/do_mounts.c:1:
/scratch/sfr/next/include/linux/time.h: In function '__FD_ZERO':
/scratch/sfr/next/include/linux/time.h:279:2: error: implicit declaration o=
f function 'memset' [-Werror=3Dimplicit-function-declaration]

... and many similar.

Caused by commit 5607ffd42bae ("posix_types: remove fd_set macros").

I have reverted that commit (and the following checkpatch fix commit) for
today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Feb_2012_16_21_00_+1100_kcjAl+Yj1fL1yUdA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPPeO8AAoJEECxmPOUX5FE+mYP/A0yWXJ7UIybxckWY+veZnPs
V+rbWnhmuECq0l7jB+tqvVpe+Vv7sSB2RKOq5qROLSLXCCA++sG/5+1JuNzVR5eb
zVaXRg8W74i4RmY+NwLseOaRZyjXxqJFHVbydh9cYnSHppcZgZH3LGYU3zNU2vf+
CEkyM7aTDH8vvapkKWkzJX0TdzSQw5EF+8oyt7WD8hH/pneB+ONcIqybEGbBK/t/
N/NLTKvwGhuP3g01BuYe9EuwhYVKzRoeYbX1Iahh/G9qUj7SlCUPYAbi8UJSStwH
Di6IYqU1wS0ATR9rKsAs3iGXJDvdEOTaxppbCQ3p8S7z58c5il7nmu46YXVn305i
ER7JhVuw7zRDYuazmWn3EPv4JkUp4fA3UvIBcMAbLkLe8n/NgJM3vwPgWhQ67Z9v
qDqkHGQke5wfHJzsrxDskVnTOEUK19LfPRI+hyksxr169tMib5tRzzUTTuzo5YDJ
Gg7Qg1V6KebiANjh/MfJ4s1r666eaNQDRQvrcn3N7baxp5LphfLmSWuu/5GRZgXO
TEmVf06ihCuQ37E084TwDlqGBwWu15LNATTJzenL3ju5mhCuO4U6gvXZdj1DmgQq
WQxRreQ+z7thart0Spgt/TroepVtlTLCVUruOy43Vn2rSMyge7uV2qcRsFR+Nbi7
UVPlYHX19RAo9hS0yWqB
=lVPa
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Feb_2012_16_21_00_+1100_kcjAl+Yj1fL1yUdA--
