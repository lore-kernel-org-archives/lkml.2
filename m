Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab1JYIMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:12:31 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:42605 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab1JYIM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:12:29 -0400
Date: Tue, 25 Oct 2011 19:12:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: linux-next: manual merge of the tty tree with Linus' tree
Message-Id: <20111025191217.31638338379ac498fda051fb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_19_12_17_+1100_V4K=Ef97Abn0aQgr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_19_12_17_+1100_V4K=Ef97Abn0aQgr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/serial/8250_pci.c between commit dacacc3e794c
("serial/8250_pci: delete duplicate data definition") from Linus' tree
and commit 64d91cfaade2 ("8250_pci: Fix kernel panic when pch_uart is
disabled") from the tty tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/serial/8250_pci.c
index 3abeca2,1b449b7..0000000
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@@ -1598,7 -1639,14 +1639,8 @@@ static struct pci_serial_quirk pci_seri
  		.vendor         =3D 0x10DB,
  		.device         =3D 0x800D,
  		.init		=3D pci_eg20t_init,
+ 		.setup		=3D pci_default_setup,
  	},
 -	{
 -		.vendor         =3D 0x10DB,
 -		.device         =3D 0x800D,
 -		.init		=3D pci_eg20t_init,
 -		.setup		=3D pci_default_setup,
 -	},
  	/*
  	 * Cronyx Omega PCI (PLX-chip based)
  	 */

--Signature=_Tue__25_Oct_2011_19_12_17_+1100_V4K=Ef97Abn0aQgr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpm9hAAoJEECxmPOUX5FEEbkP/28YQyjlU/7fbvXg7jCK6XaN
6qPNij3GW0maN9rtbKZmwGqwuLPEnwoSkp5P/WG4BncGP8uw+BLTHEIAolXD/7og
l8u+tqkBDldV/Lcrwa4RGgdQF3y6YBp/eF55PZXqMeY0IwFzp4A6mzQ/4j4dCXy7
7/xWdkDRlVlI20PBLg0d1BFHC1+TWdYxIA+qlBKSAX55k6z4MYxNJwMM68Z9eWR9
9mGVNXXJf8n8qC6CGZKOB+mkE7u2tk8BKToVzBaogruS3EYohOg3ntgzpPnc4K/q
7gqvDmMPL9eIBedbUQ5Do7dplwFNHb9E0wDg/SOlIDDp1a+YExT6kSgP0f+fkf0l
prZB7Q8ZI6oEXqyLBop1wvVY0oqaoh7KibpPKBm7Ip4F1hHUkd8TLNvXhk9M9iNb
7aTnPBzOFCofAffMwkECQkUd8mQolNqChwb9E8dIekBE01wMSu+TRV+M7K4uOS2J
u1HneXuwAxqg8+OBBAYhjAbOBg6sgaj33mHMqFY0cQ7G4aa0FNRK7Bbg3gESADpL
+l5NByk8Hrii6rgtPC6rNwHH7Q6JQNnxbAuudkEiAzEzbUHYp6rsfUNM1VHGTToq
rS3gWPVvtLBzwSXrpGZvvBbIADJOoeEtmVVE5I9Avnq2hXrlO5riQKkQHKwjLcr9
EbVdNwrRJeKn098cs8dH
=58OA
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_19_12_17_+1100_V4K=Ef97Abn0aQgr--
