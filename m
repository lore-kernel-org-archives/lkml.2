Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab1BQWcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 17:32:10 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57944 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab1BQWcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 17:32:05 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: [regression] build failure with staging driver winbond phy
Date: Thu, 17 Feb 2011 23:31:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-tp42-rtime-00004-g9eb63ce; KDE/4.5.3; i686; ; )
Cc: Greg KH <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart185447526.y2kxyWLQNd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201102172331.59997.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart185447526.y2kxyWLQNd
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi!

linux-2.6 as of ee715087024b91a6ceb85ba2d02f6c35d354a48c.

martin@shambhala:~/Computer/Shambhala/Kernel/2.6.38/linux-2.6> LANG=3DC=20
make-kpkg --append-to-version -tp42 --revision 1 --initrd --rootcmd=20
fakeroot linux_{image,doc,headers,source}
[...]
Root device is (253, 0)
Setup is 13724 bytes (padded to 13824 bytes).
System is 2763 kB
CRC 115d526c
Kernel: arch/x86/boot/bzImage is ready  (#3)
make[1]: Leaving directory=20
`/home/martin/Computer/Shambhala/Kernel/2.6.38/linux-2.6'
/usr/bin/make  EXTRAVERSION=3D-rc5-tp42  ARCH=3Di386 \
                             modules
make[1]: Entering directory=20
`/home/martin/Computer/Shambhala/Kernel/2.6.38/linux-2.6'
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC [M]  drivers/staging/winbond/phy_calibration.o
drivers/staging/winbond/phy_calibration.c: In function=20
'_tx_iq_calibration_winbond':
drivers/staging/winbond/phy_calibration.c:986: error: implicit declaration=
=20
of function 'msleep'
drivers/staging/winbond/phy_calibration.c: In function=20
'adjust_TXVGA_for_iq_mag':
drivers/staging/winbond/phy_calibration.c:1555: error: implicit=20
declaration of function 'udelay'
make[4]: *** [drivers/staging/winbond/phy_calibration.o] Error 1
make[3]: *** [drivers/staging/winbond] Error 2
make[2]: *** [drivers/staging] Error 2
make[1]: *** [drivers] Error 2
make[1]: Leaving directory=20
`/home/martin/Computer/Shambhala/Kernel/2.6.38/linux-2.6'
make: *** [debian/stamp/build/kernel] Error 2

I already disabled CONFIG_IR_WINBOND_CIR, but it doesn't seem to help:

martin@shambhala:~/Computer/Shambhala/Kernel/2.6.38/linux-2.6> grep=20
"WIN.*BOND" .config
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_WINBOND_VLB is not set
# CONFIG_IR_WINBOND_CIR is not set

Any advice on which kernel option to disable in order to build this again?

No problem with 2.6.37, but maybe it didn't have this driver.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart185447526.y2kxyWLQNd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk1dodUACgkQmRvqrKWZhMf8oACfRbEsVlMCoAA8h++Pdy2Jc8A1
gfkAn3qZQFVzSkq6LQyBSyKwMLqJLKOA
=z1UX
-----END PGP SIGNATURE-----

--nextPart185447526.y2kxyWLQNd--
