Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2FTGbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 02:31:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35417 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab2FTGbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 02:31:39 -0400
Date: Wed, 20 Jun 2012 16:31:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlNqdXIgQnLDpm5kZWxhbmQi?= 
	<sjur.brandeland@stericsson.com>
Subject: linux-next: manual merge of the remoteproc tree with Linus' tree
Message-Id: <20120620163130.b7bbb33fbed65837bf386f59@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Jun_2012_16_31_30_+1000_t=ge0t/aTxgrWLxX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jun_2012_16_31_30_+1000_t=ge0t/aTxgrWLxX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ohad,

Today's linux-next merge of the remoteproc tree got conflicts in
drivers/remoteproc/remoteproc_core.c between commits e981f6d41acd
("remoteproc: fix print format warnings") and 30338cf09f82 ("remoteproc:
fix missing fault indication in error-path") from Linus' tree and commits
7826bf782364 ("remoteproc: Pass struct fw to load_segments and
find_rsc_table"), a933c9f8ef8a ("remoteproc: Add function
rproc_get_boot_addr") and 32d46fe7f468 ("remoteproc: Move Elf related
functions to separate file") from the remoteproc tree.

I fixed them up (see below) and can carry the fixes as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/remoteproc/remoteproc_core.c
index 66324ee,6779c2a..0000000
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@@ -1018,9 -789,7 +789,7 @@@ static int rproc_fw_boot(struct rproc *
  	if (ret)
  		return ret;
 =20
- 	ehdr =3D (struct elf32_hdr *)fw->data;
-=20
 -	dev_info(dev, "Booting fw image %s, size %d\n", name, fw->size);
 +	dev_info(dev, "Booting fw image %s, size %zd\n", name, fw->size);
 =20
  	/*
  	 * if enabling an IOMMU isn't relevant for this rproc, this is
@@@ -1032,19 -801,12 +801,14 @@@
  		return ret;
  	}
 =20
- 	/*
- 	 * The ELF entry point is the rproc's boot addr (though this is not
- 	 * a configurable property of all remote processors: some will always
- 	 * boot at a specific hardcoded address).
- 	 */
- 	rproc->bootaddr =3D ehdr->e_entry;
+ 	rproc->bootaddr =3D rproc_get_boot_addr(rproc, fw);
 =20
  	/* look for the resource table */
- 	table =3D rproc_find_rsc_table(rproc, fw->data, fw->size, &tablesz);
+ 	table =3D rproc_find_rsc_table(rproc, fw, &tablesz);
 -	if (!table)
 +	if (!table) {
 +		ret =3D -EINVAL;
  		goto clean_up;
 +	}
 =20
  	/* handle fw resources which are required to boot rproc */
  	ret =3D rproc_handle_boot_rsc(rproc, table, tablesz);

--Signature=_Wed__20_Jun_2012_16_31_30_+1000_t=ge0t/aTxgrWLxX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4W5CAAoJEECxmPOUX5FEJOMP/R08REUYORsCIWwuwLXJxfzI
641tpnlieZ8BzhkhxsNCe1JoiW/mlbTOFOxrNbNI+BAm/2bA1k6aA6Re9jKjSXtG
CK7xl/olX48XPv5B7K0KVfCJKT7KdmtKsRzdoeX/FMqhHDyYxpOjxBYn7x0KIlR6
2w/6IBXPXbPzhZjZAQhK+Q+SJwY6aqURheEiDMUOHeZp2LrsvYroh+mARUmSYWsj
7T2tBa0UT2g9kviF+4B+/HoeKxBqHCs752pMmPgfUBVRFJjGzCRf0KNvw5/B/6yl
HgBN6Xk2BNMwbaMJbPvDNT+26j08yjvholwCRa+sGw9L7izpMOzPZaknTuOt/a/c
rNw344IL8qx8+iaLHtbedToRBnYf6VQTX4ZGpjs2AZb5PouwbOF6Q6qfwO2kZ/DM
DIG64iWWZRPtQ6R8Xg5tUy6fDrfqpo5DN3XOdvBxte4GLVj4tfbBwUzAq/vGL9ZS
n1XLZ5V/4TppaSZ74SwS11zM6ZS1QCnpCTPAD/g7ybAERvton95a45ea1HfsZF/l
E9IuVU9Aj6RyBtRRCh1UZx4Y/07CuK7lLWOvTs9xN0P3waAccFWmR1q/P0hx19GJ
BdN5VxfXgwfWDmrAEdBMSN8Iu3Ut+lc9GFPUZNUnfKlF0T71KRQSZk2SXr5WQyxd
Ubt+WnU8F9i4OGLB3XOr
=PdjK
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jun_2012_16_31_30_+1000_t=ge0t/aTxgrWLxX--
