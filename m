Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2KZJfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:35:01 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37563 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab2KZJe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:34:59 -0500
Date: Mon, 26 Nov 2012 20:34:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the pinctrl tree
Message-Id: <20121126203449.10d0d757dcddab773b308ee2@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_20_34_49_+1100_Aq/D+ZD5h.Jrp3Dx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_20_34_49_+1100_Aq/D+ZD5h.Jrp3Dx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/Makefile between commit ec6754a7b9e9 ("arm: at91: dt:
at91sam9 add serial pinctrl support") from the pinctrl tree and commit
e8d623986990 ("Merge branch 'next/soc' into for-next") from the arm-soc
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/Makefile
index 204fd3c,cce80e2..0000000
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@@ -1,38 -1,25 +1,41 @@@
  ifeq ($(CONFIG_OF),y)
 =20
 -dtb-$(CONFIG_ARCH_AT91) +=3D aks-cdu.dtb \
 -	at91sam9263ek.dtb \
 -	at91sam9g20ek_2mmc.dtb \
 -	at91sam9g20ek.dtb \
 -	at91sam9g25ek.dtb \
 -	at91sam9m10g45ek.dtb \
 -	at91sam9n12ek.dtb \
 -	ethernut5.dtb \
 -	evk-pro3.dtb \
 -	kizbox.dtb \
 -	tny_a9260.dtb \
 -	tny_a9263.dtb \
 -	tny_a9g20.dtb \
 -	usb_a9260.dtb \
 -	usb_a9263.dtb \
 -	usb_a9g20.dtb
 +# Keep at91 dtb files sorted alphabetically for each SoC
 +# rm9200
 +dtb-$(CONFIG_ARCH_AT91) +=3D at91rm9200ek.dtb
 +# sam9260
 +dtb-$(CONFIG_ARCH_AT91) +=3D animeo_ip.dtb
 +dtb-$(CONFIG_ARCH_AT91) +=3D aks-cdu.dtb
 +dtb-$(CONFIG_ARCH_AT91) +=3D ethernut5.dtb
 +dtb-$(CONFIG_ARCH_AT91) +=3D evk-pro3.dtb
 +dtb-$(CONFIG_ARCH_AT91) +=3D tny_a9260.dtb
 +dtb-$(CONFIG_ARCH_AT91) +=3D usb_a9260.dtb
 +# sam9263
 +dtb-$(CONFIG_ARCH_AT91) +=3D at91sam9263ek.dtb
 +dtb-$(CONFIG_ARCH_AT91) +=3D tny_a9263.dtb
 +dtb-$(CONFIG_ARCH_AT91) +=3D usb_a9263.dtb
 +# sam9g20
 +dtb-$(CONFIG_ARCH_AT91) +=3D at91sam9g20ek.dtb
 +dtb-$(CONFIG_ARCH_AT91) +=3D at91sam9g20ek_2mmc.dtb
 +dtb-$(CONFIG_ARCH_AT91) +=3D kizbox.dtb
 +dtb-$(CONFIG_ARCH_AT91) +=3D tny_a9g20.dtb
 +dtb-$(CONFIG_ARCH_AT91) +=3D usb_a9g20.dtb
 +# sam9g45
 +dtb-$(CONFIG_ARCH_AT91) +=3D at91sam9m10g45ek.dtb
 +dtb-$(CONFIG_ARCH_AT91) +=3D pm9g45.dtb
 +# sam9n12
 +dtb-$(CONFIG_ARCH_AT91) +=3D at91sam9n12ek.dtb
 +# sam9x5
 +dtb-$(CONFIG_ARCH_AT91) +=3D at91sam9g15ek.dtb
 +dtb-$(CONFIG_ARCH_AT91) +=3D at91sam9g25ek.dtb
 +dtb-$(CONFIG_ARCH_AT91) +=3D at91sam9g35ek.dtb
 +dtb-$(CONFIG_ARCH_AT91) +=3D at91sam9x25ek.dtb
 +dtb-$(CONFIG_ARCH_AT91) +=3D at91sam9x35ek.dtb
 +
+ dtb-$(CONFIG_ARCH_BCM) +=3D bcm11351-brt.dtb
  dtb-$(CONFIG_ARCH_BCM2835) +=3D bcm2835-rpi-b.dtb
+ dtb-$(CONFIG_ARCH_DAVINCI) +=3D da850-enbw-cmc.dtb \
+ 	da850-evm.dtb
  dtb-$(CONFIG_ARCH_DOVE) +=3D dove-cm-a510.dtb \
  	dove-cubox.dtb \
  	dove-dove-db.dtb

--Signature=_Mon__26_Nov_2012_20_34_49_+1100_Aq/D+ZD5h.Jrp3Dx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQsze5AAoJEECxmPOUX5FElu4P/i6aDpdNy1IBiGC16Jv8zpRU
INvmkp/dK1xtZdQtnnXVbqQy/WmpIxMNTf/S0E7igRUeiZ2sco9BQkVCZySHGOBc
grLx7AfZYsphnpcRTb7Q+Ikb1QF4tKZir4pQYwEZxSmSzdZqlJC24xs4sdXyjCtk
O3gEiaV09+v6G+grC50dEazLeNUG4TqOdtEdvmzsSyL2fMkiUxMql4Jq9tw8voAd
p6L9qc9FRp6cmqAO+WKxjOjmFz4tayKM5wCxq/ZrVmGyVDQlu2XV75fLw2EvtXsz
wgI1GoA0UbtO7jjtz+b/ziKgt73VeQwqMW3oMIjNLEzmjiihF1CQs96WS3QzjHG+
6oSNvveteAr0Lnht4blU9bc0S07b9e2NvvhPZGug5Xokz0TZdjTghNWLqBp1NBqM
SU80p2l0SiHuoH60kwIpcyRXMNyP4b6fELwzBd4HRr7rMw4rQejnG/HHNNpA3nNg
THPKzD1D5sv07tMaeAqCe6C30hYpN8aKR1WkI5tbMxh6khelXubLYr8GiCvl7MRp
lwqqiOI/mJm5kmq7Ed185YRHDSzHUNmnoH8JTLncQbUw9wzRhOspXYtgenul+FQj
ZUX7MbPvC+/2v7CVU6YbMDzynBAfRyDZ7B75qJFCeqPNQ0EEDmzVOIf64++DDJ8V
9g/dfMrtcRzvfPFUSx+7
=9cyh
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_20_34_49_+1100_Aq/D+ZD5h.Jrp3Dx--
