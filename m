Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab1KUB5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 20:57:30 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:59983 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab1KUB53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 20:57:29 -0500
Date: Mon, 21 Nov 2011 12:57:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alessandro Rubini <rubini@gnudd.com>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20111121125703.fbb955c4fc468ba176086168@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_Nov_2011_12_57_03_+1100_bEZ2OI1nu=QbbkWr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Nov_2011_12_57_03_+1100_bEZ2OI1nu=QbbkWr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/debugfs/file.c: In function 'debugfs_print_regs32':
fs/debugfs/file.c:560:7: error: implicit declaration of function 'readl' [-=
Werror=3Dimplicit-function-declaration]

Caused by commit 1a087c6ad975 ("debugfs: add tools to printk 32-bit
registers"). To use readl(), linux/io.h should be included.

I have used the driver-core tree from next-20111118 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__21_Nov_2011_12_57_03_+1100_bEZ2OI1nu=QbbkWr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOya/vAAoJEECxmPOUX5FEPGcP/0Gn4RlahY10/8x5jRN6YKDq
Zy2kQUCGhAeD58/cOykVQckEDf9hMXSsAJ/gP7wbGl1zc6/ozzEAJaowDsV9CYvo
HI4fZDTu+TuDUC07vLgVIGNoMOrCB3kYXfuGY1ab4pqBc0TL5Sj6XWzIHYxycj0n
hzj3s9DFT+heX/1cdcSvPsV74pyVZA/JmyUjpDqIRgaM9LAV8/hmdrUI3ky/DOOR
v8CiJDQJOd5XIQI20Ucq2WdVYupsPC9NJZuuRlHtadx9yZd9I+LPS+WDYd5WYR9H
UpOqukFdyq/B2id5AcL09fr+eQ+TxAnNl4K3FFoUNxD0/EV7PVzpPUTBCo5WMgqP
bNifUZPL9wPnsrz7LdXIq+HSqAODVWhCobv//Y7A4iTX7okExIceqkSOvr6QlUv/
U+VDDayF90kmuFcPgXMKY3D3BiZnb7csUDfs046aglxPcV6qLa6/wDAsGvIz4n6l
8wAWavQH7B7ptWhKMjmbIb8nZCqE3v6vwSJAbu2P94IbooFCobwsC06yTMVn4Wm/
wbD+IaerL/usJy3rhfHbKXIHJVLk3+PWnLXSXK9A9okZcSMJrjLn/nn5dMT+NDjl
bklLdgV+4U5F6mACNQ+vPEVUic1zClxG+WdSd6pW9jGVDBsajz6u38GAhXEQqLaD
2z7emb0AiYkm+YGla/3U
=AOhA
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Nov_2011_12_57_03_+1100_bEZ2OI1nu=QbbkWr--
