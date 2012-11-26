Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab2KZKjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:39:00 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51540 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab2KZKi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:38:59 -0500
Date: Mon, 26 Nov 2012 21:38:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Venkatraman S <svenkatr@ti.com>, Chris Ball <cjb@laptop.org>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the arm-soc tree with the mmc tree
Message-Id: <20121126213853.ccceb25dc3b3c5a24911abef@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_21_38_53_+1100_xbsxXPDkd2hePazM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_21_38_53_+1100_xbsxXPDkd2hePazM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
include/linux/platform_data/mmc-omap.h between commit 69bc0b677e6c ("mmc:
omap_hsmmc: Enable HSPE bit for high speed cards") from the  tree and
commit 53db20d123f7 ("mmc: omap: Remove cpu_is_omap usage from the
driver") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/platform_data/mmc-omap.h
index 346af5b,2bf6ea8..0000000
--- a/include/linux/platform_data/mmc-omap.h
+++ b/include/linux/platform_data/mmc-omap.h
@@@ -126,7 -107,9 +107,10 @@@ struct omap_mmc_platform_data=20
  		/* we can put the features above into this variable */
  #define HSMMC_HAS_PBIAS		(1 << 0)
  #define HSMMC_HAS_UPDATED_RESET	(1 << 1)
 -#define MMC_OMAP7XX		(1 << 2)
 -#define MMC_OMAP15XX		(1 << 3)
 -#define MMC_OMAP16XX		(1 << 4)
 +#define HSMMC_HAS_HSPE_SUPPORT	(1 << 2)
++#define MMC_OMAP7XX		(1 << 3)
++#define MMC_OMAP15XX		(1 << 4)
++#define MMC_OMAP16XX		(1 << 5)
  		unsigned features;
 =20
  		int switch_pin;			/* gpio (card detect) */

--Signature=_Mon__26_Nov_2012_21_38_53_+1100_xbsxXPDkd2hePazM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQs0a9AAoJEECxmPOUX5FE/YUP/2tfuS2NAz7/MivPC7y9ZO43
j+8RSE46t4vNqqezzbsHBKPwv9Uw9yyo5p0C+ZB9PqM16DpFHvn7xc6xMeAcVIKi
G7MX9EqeFHGTzIcNSMEE4bcgMVK18qn0d8xT6+826LC7k/kPvL98d9noxvRUZhKS
t4tceUlLgZGUOqAIgh6c5EHNv6VqDrSC8K6zo+h9oE4kqnnP8iZIEntjJxSl9Rwm
eOuccsf+UwbG0xNzpO799diUNHveswn4PLCj+wgNpbPgZqMm0B49C/2ut3843yk5
gXuJ07pWVgT0ayuKXbhF3IKezjFrcYji7HvD1SZfpPLV+trhQC1F4ETGQV72Ee3L
KSAzWIgbCY9PR5yQmBYABx41zQ3V856ruAJtGDk8qGv5b8RxRLuTfTge29HerLDi
pJ0QleGx7VmYnXSOu8RzzTuy5V50zXTsV9QB9K5ZQFEs9QLs6T1rGte8/gdz01p0
epqHw5fAgHcDTvUJGhqT6nUD1zJune0VUFOPAfSDEkADOmlk1JtqQpGNHfTyU9+c
GQQbNezRF2jk+fx60U55umvHEMOpd3sdFCQZxt+aV+hxbgB/zm4AFgWjbws6b8FO
U8UdwiN5oJKOkjtyM4+yhfWhMxHDzfSaELKSvysCa32/XjWxeVq7vp9Q/HXlC1xB
3l+rttlKVfwEzGegHWiJ
=eitm
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_21_38_53_+1100_xbsxXPDkd2hePazM--
