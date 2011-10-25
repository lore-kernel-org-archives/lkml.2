Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab1JYIqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:46:13 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:52159 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab1JYIqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:46:01 -0400
Date: Tue, 25 Oct 2011 19:37:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Moore <pmoore@redhat.com>
Subject: linux-next: manual merge of the moduleh tree with Linus' tree
Message-Id: <20111025193731.c4332cd9ca07b7d833b76914@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_19_37_31_+1100_R5wnl+TvT9Sk3EeB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_19_37_31_+1100_R5wnl+TvT9Sk3EeB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
net/bluetooth/l2cap_sock.c between commit 6230c9b4f895 ("bluetooth:
Properly clone LSM attributes to newly created child connections") from
Linus' tree and commit ac86caa04348 ("net: Add export.h for
EXPORT_SYMBOL/THIS_MODULE to non-modules") from the moduleh tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/bluetooth/l2cap_sock.c
index a4a9d12,fa5e166..0000000
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@@ -26,7 -26,7 +26,8 @@@
 =20
  /* Bluetooth L2CAP sockets. */
 =20
 +#include <linux/security.h>
+ #include <linux/export.h>
 =20
  #include <net/bluetooth/bluetooth.h>
  #include <net/bluetooth/hci_core.h>

--Signature=_Tue__25_Oct_2011_19_37_31_+1100_R5wnl+TvT9Sk3EeB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpnVLAAoJEECxmPOUX5FEFyYP/RrOkB5KTESa3AjUg8DRdCKq
cTo5J3HuaW4pS0g0d4x5ZO1IiJWsQPkyincggRuQmlnVbdnxTIFniF8DzEcez+0u
C2tyTfkDF5BGChvOQhTDy5S2vrLcjIHrFSjVbGKD1YPPIw5rqU0nQapv7ZekVWj8
5cO748vHvoM/qFpFwX1FQUsuP4ItSt9WDGEoOacBdMJscdwU3HwuDbcl+Vz19/2U
236yqHlnnhY5yoU6tMcQtBYFup3lGjykGSKquixaFKZxQKUQhpuoqI0mKYs8Otew
4s7MMAhQkcxnjVB2UrdXI8J9HB9xnoyWF6VeJTkUwUo584LWkqq468YVcsAfeJ2W
TU9Bv6R6XkB5oPhP2HUlbVH3+yyEiezYGfU6KQW6KMTosyqQ++/udO2WK6hru3+P
MaJMGsysPOP1G7o7gdbxWFdTqGsoxv7GRvZvLss7BOr9CmOX9Lr2jRBzm9TQs5ls
GDH8Qxo5duIvL3niCqIelqdZiMedzRRsTpqv/gmGIhBzAMx40Oxmy88kxhLkAUYb
lKe4hZl8Ze5rKLz19JKO+AS+KiMbipeAoxmf+/fPKgsBBcGNkF8z/ZB2F39T8iR0
Ua47QPIUCiGOj1nMSIb2m5uib8YYdPj1AjBY1QX2kb8jcDZpyE/mJC/LKtYeiTsR
WPeJ+oBxuE89DNJqNCze
=4pcM
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_19_37_31_+1100_R5wnl+TvT9Sk3EeB--
