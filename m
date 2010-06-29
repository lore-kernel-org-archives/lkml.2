Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab0F2D3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 23:29:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50522 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab0F2D3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 23:29:13 -0400
Date: Tue, 29 Jun 2010 13:29:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ernst Schwab <eschwab@online.de>
Subject: linux-next: build failure after merge of the spi tree
Message-Id: <20100629132907.f857600d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__29_Jun_2010_13_29_07_+1000_UWWNuSpSSHT8E60Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Jun_2010_13_29_07_+1000_UWWNuSpSSHT8E60Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

After merging the spi tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/mmc/host/mmc_spi.c: In function 'mmc_spi_readbytes':
drivers/mmc/host/mmc_spi.c:185: error: implicit declaration of function 'sp=
i_sync_locked'
drivers/mmc/host/mmc_spi.c: In function 'mmc_spi_request':
drivers/mmc/host/mmc_spi.c:1088: error: implicit declaration of function 's=
pi_bus_lock'
drivers/mmc/host/mmc_spi.c:1101: error: implicit declaration of function 's=
pi_bus_unlock'

Caused by commit f0168ff4069fba07fdd4b05aa19f283171c8d265 ("spi/mmc_spi:
mmc_spi adaptations for SPI bus locking API").  Maybe updates to another
file were missed?

I have used the spi tree from next-20100628 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Jun_2010_13_29_07_+1000_UWWNuSpSSHT8E60Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMKWiDAAoJEDMEi1NhKgbsvBQH/0QitJVZDT6DFLZLD5ahuNfJ
UqzPjrx7SLdw22B8KEb3iXIoM6GBcBmL7y0BdvPmc7Zl6B3E6G1zcrKmLvPbxhlC
enmRuAUhiGu3n8rba8WDWrbpizkDBTh7VuLWF66+crCFJwxaCtIK0fxduR280tV4
nDgXqaDDb4Wig1zMXewXngnl9TPFDF8OxUEzZ9y34PMI6YRU9R0ezuTrH6uJN9Lz
BI08/JU2ZAyTksDjzDXSkJpUPz1iA9HVefBF5BNGW21shJKbbEIgYxXIoJtHwuEx
XVvOVnFBTXXNXLXqty/k6tuW0GuJDC4TkcMv4cCAdNj1Snwyn62Dj05auns3A5Y=
=Jt5g
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Jun_2010_13_29_07_+1000_UWWNuSpSSHT8E60Z--
