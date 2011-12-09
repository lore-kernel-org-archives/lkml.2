Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1LIB1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 20:27:50 -0500
Received: from ozlabs.org ([203.10.76.45]:57926 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598Ab1LIB1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 20:27:48 -0500
Date: Fri, 9 Dec 2011 12:27:46 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: linux-next bad Kconfig for drivers/hid
Message-ID: <20111209012746.GC20353@thor.bakeyournoodle.com>
Mail-Followup-To: Jeremy Fitzhardinge <jeremy@goop.org>,
	Jiri Kosina <jkosina@suse.cz>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
	Linux Kernel ML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="11Y7aswkeuHtSBEs"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--11Y7aswkeuHtSBEs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Commit 4f5ca836bef3 (HID: hid-input: add support for HID devices
reporting Battery Strength) went into linux-next on Dec 1st since then a
ppc6xx_defconfig has been failing with:

---
drivers/built-in.o: In function `hidinput_cleanup_battery':
/scratch/tony/working/drivers/hid/hid-input.c:351: undefined reference to `=
power_supply_unregister'
drivers/built-in.o: In function `hidinput_setup_battery':
/scratch/tony/working/drivers/hid/hid-input.c:338: undefined reference to `=
power_supply_register'
make[1]: *** [.tmp_vmlinux1] Error 1
---

http://kisskb.ellerman.id.au/kisskb/buildresult/5012563/
vs
http://kisskb.ellerman.id.au/kisskb/buildresult/5017366/

The defconfig in question doens't mention either option
(CONFIG_POWER_SUPPLY or CONFIG_HID_BATTERY_STRENGTH) and kbuild is
genertaing
CONFIG_HID_BATTERY_STRENGTH=3Dy
CONFIG_POWER_SUPPLY=3Dm
which clearly isn't going to work.

The following change to HID_BATTERY_STRENGTH Kconfig "works" but seems a
little gross.

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 5ed64f6..d2a94e6 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -33,7 +33,7 @@ config HID
=20
 config HID_BATTERY_STRENGTH
        bool
-       depends on POWER_SUPPLY
+       depends on POWER_SUPPLY=3Dy
        default y
=20
 config HIDRAW

Any chance we can get a fix into linux-next?

Yours Tony

--11Y7aswkeuHtSBEs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO4WQSAAoJEEsCiJRY75GKshAQAIAjfQkgRa/aelAyilCJ9SUv
Q+w+ASOD5RsZO6oMPx1PNnlX3IumO1ShRRU6WEpGh/4bzu9Ldf6Jpb04/Jo1xAg4
OQbsx0qT4PFCPg2ijysfqrmT3UfESrALq28/WGoVBdxNS2YvrytkLks93ZJ4oGHi
VoimNzvozR01iwGKPFVg8i4ram6UYG1Hmoi1BQZR8J/7S0Fb0t6kV3YaQfdaeUJS
LSyJMPwOi7DhIba5Q3HID+SWzfLGsrfUro2iv8ur9YETYVCA5eJgcZy9LawZy2it
MJDB0haVnna3QG8t8F9k0Rv+9WYdjSrwefq9VppdYXBEga53a59t2wCLjUrbaKrv
jjxdiydqsd4zzN45LIFoMkj9yD0GcymHHi/giHpPBx+pcKHxU19IWSejNIg6twuP
d4p+yP+JsT1quYsXpmNOYUIzi5eDz6GcgAVCiVeB4jOvpj91OEHxsA8rwxFqjyq2
VemRuD3kjjMkfx8TvjEb2mkdV08djrf0BbeZbJrhYYhe1xM38rvW932ppb3Pmab7
UZhY47SG2Kk637X5K9eQfqtEd7mfODakiIQVoQfOxCkWD2WxlHYPnDnBqMAqy5SK
XZl+NNJbpHt7quTi+6/y1bcm4SY+R3zNMvH7yTyohfeKxotoYIkc9XqpD+kcRN8W
CT3NTEGR+b+M0OTbVm7K
=ZJZv
-----END PGP SIGNATURE-----

--11Y7aswkeuHtSBEs--
