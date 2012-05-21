Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2EUGW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:22:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33921 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab2EUGW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:22:26 -0400
Date: Mon, 21 May 2012 16:22:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: linux-next: build failure after merge of the usb tree
Message-Id: <20120521162216.ca7c437235a2cc1aa54cacc9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_16_22_16_+1000_8/RY8ryUdneWJHXN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_May_2012_16_22_16_+1000_8/RY8ryUdneWJHXN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/usb/core/hub.c: In function 'usb_disable_lpm':
drivers/usb/core/hub.c:3394:2: error: implicit declaration of function 'usb=
_enable_lpm' [-Werror=3Dimplicit-function-declaration]
drivers/usb/core/hub.c: At top level:
drivers/usb/core/hub.c:3424:6: warning: conflicting types for 'usb_enable_l=
pm' [enabled by default]
drivers/usb/core/hub.c:3394:2: note: previous implicit declaration of 'usb_=
enable_lpm' was here
drivers/usb/core/driver.c: In function 'usb_probe_interface':
drivers/usb/core/driver.c:339:2: error: implicit declaration of function 'u=
sb_unlocked_disable_lpm' [-Werror=3Dimplicit-function-declaration]
drivers/usb/core/driver.c:364:3: error: implicit declaration of function 'u=
sb_unlocked_enable_lpm' [-Werror=3Dimplicit-function-declaration]
drivers/usb/core/message.c: In function 'usb_set_interface':
drivers/usb/core/message.c:1314:2: error: implicit declaration of function =
'usb_disable_lpm' [-Werror=3Dimplicit-function-declaration]
drivers/usb/core/message.c:1323:3: error: implicit declaration of function =
'usb_enable_lpm' [-Werror=3Dimplicit-function-declaration]
drivers/usb/core/message.c:1368:2: error: implicit declaration of function =
'usb_unlocked_enable_lpm' [-Werror=3Dimplicit-function-declaration]

Caused by commit 8306095fd2c1 ("USB: Disable USB 3.0 LPM in critical
sections").

I have used the usb tree from next-20120518 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__21_May_2012_16_22_16_+1000_8/RY8ryUdneWJHXN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPud8YAAoJEECxmPOUX5FEbuwP/1TnmzxS2opxpCdCceVS9xlY
VEPKmZuqlxZCUckQFgYBymZkP45xOI5HpCkylOmm/sWmIUM+Co/JI6A29m2H63aH
lml+JuNbadgZBQ829S1CzBcZs8wcCb1oxZCl2uzl2gHi7TN0C6L8/1eOFH+nk/61
hCWowAqtCZ+8Rchy9gZCSt/13BfgDp3xI/wSgFx8NR5Qb4C210OprSYSTnxFerDn
b0x/3ZyGMIy9L2xhKn7Mcwlk6gBkbXTQV8rTrgU0Udyc2+QIwVN2mXvCXMQqhsOz
ISxzrV27OA41+zdWofaX4sWGI+Idl7GDAHKiT8hFVILb23cMBXq4ir9e1q6kwnjq
r/Gu9SpyCDtaKPaFvgqYAFhY0omNYgW9Qwc01leB+HHSgk2wS2N2J4iir1GzrdQv
vO2t0hQmfv5AxuXhlRMcdG/BEqs3hsz4wNATB2+tSRKxqMc16+GZYs91XOsNqO49
K/EKUcAN35IpTMHcWhPSGf2r2R068qAIZ+srSBRIHQXysk34kaaFzdaQQ+acsvnK
Q3NsdTvRZglh1Bv7d22QMBajXbAIcRTbLWUe8QzECVElthMZaZ1c8Lz2EneHE2nB
u0aNKt4xbcSkKtz0f0p23ROySdZfCGemwwnYRuzsatSNw2Ar5gD5PQvxnC2FhKVK
NFFnggZcv4wXx5GKQc0N
=W3dJ
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_16_22_16_+1000_8/RY8ryUdneWJHXN--
