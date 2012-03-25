Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab2CYJjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 05:39:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab2CYJjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 05:39:13 -0400
Date: Sun, 25 Mar 2012 20:38:49 +1100
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Subject: Recent "Run the driver callback directly" patch breaks libertas
 suspend
Message-ID: <20120325203849.7a908e32@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yGZl.8mQ06pciTWinzyRmM7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/yGZl.8mQ06pciTWinzyRmM7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Rafael,

 Your recent patch:
   commit 35cd133c
   PM: Run the driver callback directly if the subsystem one is not there

 breaks suspend for my libertas wifi and probably other SDIO devices.

 SDIO (and possible MMC in general) has a protocol where the suspend
 method can return -ENOSYS and this means "There is no point in suspending,
 just turn me off".

 The device itself "mmc1:0001" (I think) doesn't have any bus etc 'suspend'
 function so the new code call the device's suspend function which returns
 ENOSYS and the suspend fails.

 The previous code ignores the device as there is no bus suspend, and when =
it
 gets to suspend the ancestor - which for me is omap_hsmmc.1, it calls the
 device suspend function catches the ENOSYS, and turns it off.

 I suspect just reverting it isn't the right long term solution, however I
 can confirm that it works for me for now.

 I'm happy to try any alternate fixes you would like to suggest (but I cann=
ot
 promise how quickly I will get the testing done).

 (I'm testing with 3.3)

Thanks,
NeilBrown

--Sig_/yGZl.8mQ06pciTWinzyRmM7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT27nsDnsnt1WYoG5AQInaw/9ESXA5685gASikhN/BwoBTBng3FAOxdQQ
wDfTRoXRCnlbsy96Zx8F/BnOQ5w9BodCvF0nAKzrDzAteBR3InKdxIFayaZ9fWnz
H0WmvNxVaNyeeQo1I2nr2iY/cZr1bsvXkEVveoi0EMtv1HbNiRAvmZ9JD+VQB24D
ZWZh9lbSOsfNCEOGDdSneqgCP18iuzVqmg0BMoRBTqEucx+7J+Vl2FxiA/qujS2P
SzbHLJ0//7tcHJcb8lnD2HCMn0SLv5Wg/Eg/uB1ZxJ+8JG3ecovv/h34DcUub7I/
6GLfVTxA2xRjzcnnf/gWgMR17fNS915PNogsga11/MFgCOywcqc479zReNIaCYlz
G7M4wBCbDUbwCYMBF4HwzZpgBFKCIozEoWVyBUt0jBeG4ZG/FahHzOWMtdTo6OT9
etfYTubLoVs4w8mzs8847v5jev5Z2j5OZK4BpijXhCozIc8D/IPz+nysVOJQ9KRa
/qkRYtywuhgIVqCpmg1FOvB0zdROK299qIr03nO9NHE/jhB3DmU9Xg1H19G1f/g5
gfFgKUrErTT/yRpArbZ9/oxGmvo0dUH2qM/3d2oRXaP4QIZ4JUB/l+gf3EyoCVgA
G7RpK85A68uxRBai6zJx0kdcJBzHP4xcUic79hFuUqCoUAP2aEMRyqqSX2NNTrN5
mtg/7GqpHIU=
=7QOd
-----END PGP SIGNATURE-----

--Sig_/yGZl.8mQ06pciTWinzyRmM7--
