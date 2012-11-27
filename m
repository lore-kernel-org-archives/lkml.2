Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab2K0Ewa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 23:52:30 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53164 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab2K0Ew3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 23:52:29 -0500
Date: Tue, 27 Nov 2012 15:52:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Lentin <jm@lentin.co.uk>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: linux-next: manual merge of the arm-soc tree with the battery tree
Message-Id: <20121127155223.849e73a08fc1b382d4622ff8@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Nov_2012_15_52_23_+1100_NuwDuMEB4FVtFsP5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Nov_2012_15_52_23_+1100_NuwDuMEB4FVtFsP5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/power/Kconfig between commit bd9e8ab2d58d ("ab8500: Add
devicetree support for btemp") from the battery tree and commit
96ff0f5c7efd ("power: Add simple poweroff-gpio driver") from the arm-soc
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/power/Kconfig
index 263499f,b1d956d..0000000
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@@ -346,6 -329,15 +346,8 @@@ config AB8500_B
  	help
  	  Say Y to include support for AB8500 battery management.
 =20
 -config AB8500_BATTERY_THERM_ON_BATCTRL
 -	bool "Thermistor connected on BATCTRL ADC"
 -	depends on AB8500_BM
 -	help
 -	  Say Y to enable battery temperature measurements using
 -	  thermistor connected on BATCTRL ADC.
 -
+ source "drivers/power/reset/Kconfig"
+=20
  endif # POWER_SUPPLY
 =20
  source "drivers/power/avs/Kconfig"

--Signature=_Tue__27_Nov_2012_15_52_23_+1100_NuwDuMEB4FVtFsP5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtEcHAAoJEECxmPOUX5FEz8AP/jzx0PP6atB5NH9A8jTw74no
tCy22x74z4jfmdhVp0f1tVUmIvdA8WDD/SdnNP9IwhsutkxNUJCQIAG8PyN40Xal
yDH1No28KOeZ+ThMHJBVvMFYx/bGXzq14XdllbRGGvch+pWSK1zOcidtKt1sChJp
zPL3bAd+n80QvB1ZCwV/5f4zN04lzSsaGkFHwp4God6MBLKzfE3KLyeV5UFdgGph
VTiCOF82vDyPG3OzmdaN7QcLtOgpf6mA8E3zv6QCy4ZhFFKC/CVNxIi5Bs5gjBvp
Vrl0Pcec0uonAD7dZloxnJVoU7ttabmHZTI7fT1r6LksMOYE8UmoMRbQQkuH4PwB
whszZN80Ueu574mDr5YBwLzNfDcg0vmsWmFSgMnfYovI/9QkLWouEFVKbiYUPeY2
TBRXsXZmnyRKZVmEsnKvlCXYxqZ6MX4GIgcoJ4tK9+YDudejebgsK6RkK527YNR/
9K/J4Bw4Av5hnUMujbm1nrTFNxvKp2eL/55KozsLOI9Uqb3Ipbnpcn83jzixb46l
q49GdKUe2yFatxjdJwjnF7YGa9KvdeWSoEZX5A099j1W+Cqc3l58XkKtkPzYZbvw
+BLu/Pug0knMu1KPqzAhhgJUsGb6TmRnFrjAt7E3Ne5eAJCrtxTNK+hyTIjbzGmR
pkV+nbANjYocdrIg2iDD
=SIrV
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Nov_2012_15_52_23_+1100_NuwDuMEB4FVtFsP5--
