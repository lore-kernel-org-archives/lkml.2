Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab2I0Fbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:31:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34784 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab2I0Fba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:31:30 -0400
Date: Thu, 27 Sep 2012 15:31:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Huang Shijie <shijie8@gmail.com>
Subject: linux-next: manual merge of the char-misc tree with the  tree
Message-Id: <20120927153119.d297af74a0dd70eb2e070830@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Sep_2012_15_31_19_+1000_NSJjyFKKLzgj81f_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Sep_2012_15_31_19_+1000_NSJjyFKKLzgj81f_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the char-misc tree got a conflict in
drivers/char/pcmcia/synclink_cs.c between commit f21ec3d2d46e ("serial:
add a new helper function") from the tty tree and commit 221b7b5796b5
("pcmcia: synclink_cs: fix potential tty NULL dereference") from the
char-misc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/char/pcmcia/synclink_cs.c
index 3f57d5de,a6b8dde..0000000
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@@ -1050,7 -1058,7 +1058,7 @@@ static void cts_change(MGSLPC_INFO *inf
  	wake_up_interruptible(&info->status_event_wait_q);
  	wake_up_interruptible(&info->event_wait_q);
 =20
- 	if (tty_port_cts_enabled(&info->port)) {
 -	if (tty && (info->port.flags & ASYNC_CTS_FLOW)) {
++	if (tty && tty_port_cts_enabled(&info->port)) {
  		if (tty->hw_stopped) {
  			if (info->serial_signals & SerialSignal_CTS) {
  				if (debug_level >=3D DEBUG_LEVEL_ISR)

--Signature=_Thu__27_Sep_2012_15_31_19_+1000_NSJjyFKKLzgj81f_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQY+SnAAoJEECxmPOUX5FEx2AP/RUq1fuoim4eRroVUQnxOnT1
L74SxlX7Kc0G6FP5Herq/ZImJF+FbdrbiNgl3EnY7sM/MjPmsWveI8ROHmk+OSmv
GXyeBQjtuIt4YHwqQG/Ew4drGKjhRc/GViNqF7blbtrWHW1o5RgSEB16WJh8dGH2
BXXP5GbhGHN5pliqkQTeQ05X4bh8nlTDY+ODfqsYKPxMBSJKrARiKs/DyI3FRcQa
ZqbkY+bfpj0P5XSeywRp1nzYBnVOQYqp1K/ji5W+02gqHaKXoLuh7pc/P+PL3xTE
OatfXmL54RnJ3+qF81V5LeuAvj7p57G28L6w0lqs90B9Gxd0uD4q4M3UD3gjkWf2
pnw71W+z91UtQMMjdjXvyNXac+Pes3iI+c6950/5WKrhy0F5v1u5dEPxhxxAapzY
fm+hDY2z/T3qDWT52VzwVenRhK3HC4l3KIhbMby80ggnmuPedO6Tt6BKWEIHagwB
b81MJo2RBV/3oNMq8hYBcpw6A+vfjZ3bW7EO1t8Ba03wYzmz0Oc5KZkmTuUeFEte
kRFyHepBX7/LugwmEigLnF7eyZNouNx4DYZ08BZogSZXxhtFP0VyXts3pPOBM5Lm
xK+sHNmwmYnrxb79/80K4rEyRSOMPJ6qKE2aJL3e7kU/qvopn39qV6u6J6Ihp5ju
dss2RR+A+scftUn3LYkW
=C/ht
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Sep_2012_15_31_19_+1000_NSJjyFKKLzgj81f_--
