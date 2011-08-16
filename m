Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1HPFWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 01:22:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50142 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab1HPFWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 01:22:52 -0400
Date: Tue, 16 Aug 2011 15:22:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: linux-next: build warning after merge of the final tree
Message-Id: <20110816152234.26afbea89bfe896d95177ad7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__16_Aug_2011_15_22_34_+1000_p/D=GZqC64AuWWwc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Aug_2011_15_22_34_+1000_p/D=GZqC64AuWWwc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) produced this warning:

In file included from security/integrity/ima/../integrity.h:16:0,
                 from security/integrity/ima/ima.h:27,
                 from security/integrity/ima/ima_policy.c:20:
include/crypto/sha.h:86:10: warning: 'struct shash_desc' declared inside pa=
rameter list
include/crypto/sha.h:86:10: warning: its scope is only this definition or d=
eclaration, which is probably not what you want

Introduced by commit 7c390170b493 ("crypto: sha1 - export sha1_update for
reuse").  I guess you need to include crypto/hash.h in crypto/sha.h.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__16_Aug_2011_15_22_34_+1000_p/D=GZqC64AuWWwc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOSf6aAAoJEDMEi1NhKgbsVJoH/0CeGHixP3jZ8vG8X67Qhx8I
nxpO9wcEqKVbd8SvWnjM0zWM3dCdwxY468p2/Y0rSm7wJh4xRpCTp2UIgNYqQwF8
gGnOBXTo0/1wmwiq8PFahThB45DQAYNmx5msoox35FBnRmu06G05BRaGyu4XImDB
nmeKVGAkTb5PEcDPGh2mebqmazTi3AAgPGm/I2CAh64nYMT4ll3bcaR5BP++LP9/
mc4dOwoMj8HF56SM6EypKqsxng+1rKKbYn4EV8Wpbl9eFdIQyBO+7jrjHq1RtK3i
gFqQUhhcUm6En+wgXH9aGGeJpNqmEPYOGNiWi00fSOFkBPb3kZlNxU8IB1PtnYE=
=VVPn
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Aug_2011_15_22_34_+1000_p/D=GZqC64AuWWwc--
