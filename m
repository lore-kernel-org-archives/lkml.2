Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab1K3W0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 17:26:51 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48170 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab1K3W0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 17:26:49 -0500
From: Koen Kooi <koen@dominion.thruhere.net>
Content-Type: multipart/signed; boundary="Apple-Mail=_901D9407-F3F8-4F8B-872B-D43C98A76108"; protocol="application/pgp-signature"; micalg=pgp-sha1
Subject: 3.0.11 backport 11b8fc6ae54bf18a48c94e181c37ca135b858b42 is broken, please revert
Date: Wed, 30 Nov 2011 23:26:41 +0100
Message-Id: <9233627B-1EC9-410E-A618-568A41CF4A59@dominion.thruhere.net>
Cc: lkml <linux-kernel@vger.kernel.org>
To: stable@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1251.1)
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_901D9407-F3F8-4F8B-872B-D43C98A76108
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi,

I noticed that audio stopped working after 3.0.10 which I narrowed down =
to:

11b8fc6ae54bf18a48c94e181c37ca135b858b42 mfd: Fix twl4030 dependencies =
for audio codec

The commit message has this bit:

"In commit 57fe7251f5bfc4332f24479376de48a1e8ca6211
the CONFIG_TWL4030_CODEC was renamed
into CONFIG_MFD_TWL4030_AUDIO, thatswhy the codec
was not detected."

Which is this one: =
http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dco=
mmit;h=3D57fe7251f5bfc4332f24479376de48a1e8ca6211

Note the 4th of July date

=
koen@dominion:/OE/tentacle/build/tmp-angstrom_2010_x-eglibc/work/beagleboa=
rd-angstrom-linux-gnueabi/linux-3.0.12-r113a/git/drivers/mfd$ git log =
--oneline Kconfig
8509e14 mfd: Add Makefile and Kconfig Entries for tps65911 comparator
66c500f mfd: Fix build breakage caused by tps65910 gpio directory move
83545d8 GPIO: TPS65910: Move driver to drivers/gpio/
c01e36d linux-next: build failure after merge of the voltage tree
aec519b linux-next: build failure after merge of the voltage tree
27c6750 MFD: TPS65910: Add new mfd device for TPS65910
c013f0a mfd: Add pm8xxx irq support
cbdb53e mfd: Add Qualcomm PMIC 8921 core driver
1305134 mfd: Group NXP PCF50633* drivers together
37df003 mfd: Group TPSxxxxx power management chips together
8317797 mfd: add DB5500 PRCMU driver
650c2a2 mach-ux500: move the DB8500 PRCMU driver to MFD

Let's look at the top commit:

=
koen@dominion:/OE/tentacle/build/tmp-angstrom_2010_x-eglibc/work/beagleboa=
rd-angstrom-linux-gnueabi/linux-3.0.12-r113a/git/drivers/mfd$ git show =
8509e14
commit 8509e142567d69e170a184ecf27d7a6a3239fd72
Author: Axel Lin <axel.lin@gmail.com>
Date:   Thu Jun 23 10:15:51 2011 +0800

So the commit that is referenced is not actually in 3.0.x! Long story =
short:

git revert 11b8fc6ae54bf18a48c94e181c37ca135b858b42 is broken ; make ; =
scp uImage beagleboard

root@beagleboard:~# cat /proc/asound/cards=20
0 [omap3beagle    ]:  - omap3beagle
                     omap3beagle

So please revert  11b8fc6ae54bf18a48c94e181c37ca135b858b42 for 3.0.13, =
cherrypicking the TWL codec rename is a world of hurt since it needs =
other fixes to get pulled in as well.

regards,

Koen=

--Apple-Mail=_901D9407-F3F8-4F8B-872B-D43C98A76108
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAk7WraMACgkQMkyGM64RGpHxHACgkhdA5YImBL/FvBOJkBOx580W
1OcAnjlsDwjW6ru/neTcInTffKuLUzOW
=+Otb
-----END PGP SIGNATURE-----

--Apple-Mail=_901D9407-F3F8-4F8B-872B-D43C98A76108--
