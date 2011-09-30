Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1I3BiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:38:17 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:47958 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab1I3BiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:38:15 -0400
Date: Fri, 30 Sep 2011 11:38:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20110930113811.c2fa2d532dfa799a49c146f4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Sep_2011_11_38_11_+1000_UsyJvIcijIPvUi6P"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Sep_2011_11_38_11_+1000_UsyJvIcijIPvUi6P
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, the next-20110929 build (various sh configs)
failed like this:

drivers/net/ethernet/renesas/sh_eth.c:601: error: 'THIS_MODULE' undeclared =
here (not in a function)
drivers/net/ethernet/renesas/sh_eth.c:1970: error: expected declaration spe=
cifiers or '...' before string constant
drivers/net/ethernet/renesas/sh_eth.c:1970: warning: data definition has no=
 type or storage class
drivers/net/ethernet/renesas/sh_eth.c:1970: warning: type defaults to 'int'=
 in declaration of 'MODULE_AUTHOR'
drivers/net/ethernet/renesas/sh_eth.c:1970: warning: function declaration i=
sn't a prototype
drivers/net/ethernet/renesas/sh_eth.c:1971: error: expected declaration spe=
cifiers or '...' before string constant
drivers/net/ethernet/renesas/sh_eth.c:1971: warning: data definition has no=
 type or storage class
drivers/net/ethernet/renesas/sh_eth.c:1971: warning: type defaults to 'int'=
 in declaration of 'MODULE_DESCRIPTION'
drivers/net/ethernet/renesas/sh_eth.c:1971: warning: function declaration i=
sn't a prototype
drivers/net/ethernet/renesas/sh_eth.c:1972: error: expected declaration spe=
cifiers or '...' before string constant
drivers/net/ethernet/renesas/sh_eth.c:1972: warning: data definition has no=
 type or storage class
drivers/net/ethernet/renesas/sh_eth.c:1972: warning: type defaults to 'int'=
 in declaration of 'MODULE_LICENSE'
drivers/net/ethernet/renesas/sh_eth.c:1972: warning: function declaration i=
sn't a prototype

Presumbly revealed by the module.h split up.  This file needs to include mo=
dule.h.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__30_Sep_2011_11_38_11_+1000_UsyJvIcijIPvUi6P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOhR2DAAoJEDMEi1NhKgbsY0IH/jPjbwV1cuPkvgvx2H5wtmV+
BS3F3QzQD50AVS6Adit7AtKzPQD/bpqRZ7+QMB/0rDN9iMcld3RCBu6vbRnUApcu
vDOkKEbt0LGrTIxMAfGF5NXgW90uhAn25rXorVkwyxv3DcVue8D/ZTYBg/1B0pUB
6Y9l332vht17a5T+c2SihqVxk29D+XjHPIKfeuIu7pRUukmi4VaIRu58QOFv1uel
ko4rEasLzWgx/QXu1BQ5t7I7CZRAy7ekNxyKAUXvVAmTitG2MPKF6d/DUzimWTol
FqrLEnbZedf2jS32h43p0k7CQXJlpvVN7VG4EipwFKUJjox+abN9ujBzWz7LKxg=
=ry9l
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Sep_2011_11_38_11_+1000_UsyJvIcijIPvUi6P--
