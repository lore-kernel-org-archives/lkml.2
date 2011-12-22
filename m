Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1LVCa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 21:30:56 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:34691 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1LVCax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 21:30:53 -0500
Date: Thu, 22 Dec 2011 13:30:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jochen Friedrich <jochen@scram.de>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: manual merge of the mfd tree with the rr tree
Message-Id: <20111222133045.cb50cc6322a87655f8c75d25@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Dec_2011_13_30_45_+1100_tiIX5gaasWXV6Zgu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Dec_2011_13_30_45_+1100_tiIX5gaasWXV6Zgu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
scripts/mod/file2alias.c between commits f5385e2664e7 ("modpost: use a
table rather than a giant if/else statement") and c89845fbf083 ("modpost:
use linker section to generate table") from the rr tree and commit
6837bbf06393 ("ARM: sa11x0: Implement autoloading of codec and codec
pdata for mcp bus") from the mfd tree.

I fixed it up (see below - the rest of the change to this file from the
mfd tree is removed) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc scripts/mod/file2alias.c
index c1057bd,e8c7eb1..0000000
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@@ -821,8 -773,16 +821,18 @@@ static int do_spi_entry(const char *fil
 =20
  	return 1;
  }
 +ADD_TO_DEVTABLE("spi", struct spi_device_id, do_spi_entry);
 =20
+ /* Looks like: mcp:S */
+ static int do_mcp_entry(const char *filename, struct mcp_device_id *id,
+ 			char *alias)
+ {
+ 	sprintf(alias, MCP_MODULE_PREFIX "%s", id->name);
+=20
+ 	return 1;
+ }
++ADD_TO_DEVTABLE("mcp", struct mcp_device_id, do_mcp_entry);
+=20
  static const struct dmifield {
  	const char *prefix;
  	int field;

--Signature=_Thu__22_Dec_2011_13_30_45_+1100_tiIX5gaasWXV6Zgu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8pZVAAoJEECxmPOUX5FEOZMP/1CW8yDHAxCCxNdop00fp+bV
JBqGP2V9cuOFYLGdss6GqV7Su9YQhLpJ/D6JA+oq9s2nBC34GkY6iCT9uJj5XoYW
Y4OR5Cj+det+gOYbNBGENZ5WHYz3aGn1J5gcVwvnFTpYxbQgrBtjLnhKQgWLsSff
OaDOrcMUBrzCY6m/rUJtAzlAS7n71PHzC3fC10Xubgnti14FQmyk/m67+npAGXt5
e6tOrYZwL5ljFExQghaHrD5nG7sw2V7UXwZVrz8w8tz1oqMvBOnpqrG0umdcbTMT
YL3FsJj2b7YJFFkbbRD9EsrD8r2ZfzmBz8TMZe5PbHEcnZRPxH3NE/6uvwiqN2Y8
5PQwHT2O1octD7HIV67mnV6ax4J8F+M0nAEAzS5jz18/ts1SaM72zdvLNgMpMw95
SSSIqt337dBURbbkOEGYeV8+q6tIz3qN57YoUfUy8w7P7PRWAL3cJoWOW5j23ZGe
Uv04BQ2ChIKooDVHH32RugHwfNQnG03Nnen+kylQzwjLljAkvVaQfWAux/IOntqb
7DzxF6JUuF2NNckdENLN2Q3iWm5ZjHRIpitLN002XEMVvChwRdzbXRo+8om0Tyfn
rn5wP2QMdAaTOcGxbGnYpxYAzPj7oaeunlIz/Dx+eCnnFmGbGzRP8ZhDHAJ/BSU0
iaFpaSsxTosAnbTCBAQ6
=0Z4G
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Dec_2011_13_30_45_+1100_tiIX5gaasWXV6Zgu--
