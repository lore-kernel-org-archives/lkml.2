Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1LTDLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 22:11:48 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:46894 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab1LTDLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 22:11:46 -0500
Date: Tue, 20 Dec 2011 14:11:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@st.com>
Subject: linux-next: build warning after merge of the mfd tree
Message-Id: <20111220141138.570e2e3a756e14809c0a3c5f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Dec_2011_14_11_38_+1100_ZcdS4cx3d_aKzV2O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Dec_2011_14_11_38_+1100_ZcdS4cx3d_aKzV2O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64_allmodconfig)
produced this warning:

drivers/mfd/stmpe.c:114:1: warning: data definition has no type or storage =
class [enabled by default]
drivers/mfd/stmpe.c:114:1: warning: type defaults to 'int' in declaration o=
f 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]

(and several more similar).

Caused by commit b25a31a3b4d3 ("mfd: Separate out STMPE controller and
interface specific code").  This file needs to include <linux/export.h>
since module.h has been removed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__20_Dec_2011_14_11_38_+1100_ZcdS4cx3d_aKzV2O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7/zqAAoJEECxmPOUX5FEvkYP/3lmfIzWgxmAvxlCJjhdak5y
PpjVtMg0RrNqabdma3DXcGV3ZjdCgdN878OkD0g59g/I6Z3JCucLm7kPgldd2/hq
C325IlW1J8wOgADLiclZwODy4G6P016aNG/bCyVAJTUiN0m/yaOv8tX1RYQ5nJTU
DuFzfEj+p4lnWNoALWhuYX32naId5vh+QVnk7Koty+rCOQ3viZAQQx+RH059gfkr
IDJOrPJUbXwKoJTD35YIWr+/qeum9ZnyUpAQjq2Wlv0gd4qZSuK9PoqCnHs2bfcO
UEFXofm+/9CICN+O8ldKU+k1Uwd7uxawEKZDQeJkAPeRBZoNR5NUcW99NZ4/c9gq
xreXjnScdwFNtBSAWA+i4qNWQz18j9cDYFU/HEUe9h6D1b1y8WMWbWJlTyB5CgvF
K5do/Ivneca81vlZGIv4w9DLd7RErExkpyeXPxB01UV7k6Gj6qn4KU10fpwEj9HU
3aQBgzjEe0+ADAPuqQaJCq9lfDilQwFa9HJNd9KIUDxVt/i9Ie1aKdPVrtnRg6vF
Kj5/WJm3qLTzwg7GNRYjYHwTTUEdydh7GNunJVPGZHgGluhXgzulNX5tJUVU34Xu
zGzbux5z/gmracxHAbwbVf6QDVN0IWSohqJU4YM2Tg4B5LyvN2FAwigX+JPcwwX8
6GQ/wLGumG00y+3l7aTd
=Qqo/
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Dec_2011_14_11_38_+1100_ZcdS4cx3d_aKzV2O--
