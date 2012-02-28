Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab2B1Cna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:43:30 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44815 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab2B1Cn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:43:29 -0500
Date: Tue, 28 Feb 2012 13:43:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Keniston <jkenisto@us.ibm.com>, Oleg Nesterov <oleg@redhat.com>
Subject: linux-next: manual merge of the uprobes tree with Linus' tree
Message-Id: <20120228134319.033a60df8db2925d91604c18@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__28_Feb_2012_13_43_19_+1100_y+uvz=l=xLyNXO=m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Feb_2012_13_43_19_+1100_y+uvz=l=xLyNXO=m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Srikar,

Today's linux-next merge of the uprobes tree got a conflict in
kernel/fork.c between commit d80e731ecab4 ("epoll: introduce POLLFREE to
flush ->signalfd_wqh before kfree()") from Linus' tree and commit
1f9eb65410a6 ("uprobes/core: handle breakpoint and signal step
exception") from the uprobes tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/fork.c
index 14dac32,df711bb..0000000
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@@ -66,7 -66,7 +66,8 @@@
  #include <linux/user-return-notifier.h>
  #include <linux/oom.h>
  #include <linux/khugepaged.h>
 +#include <linux/signalfd.h>
+ #include <linux/uprobes.h>
 =20
  #include <asm/pgtable.h>
  #include <asm/pgalloc.h>

--Signature=_Tue__28_Feb_2012_13_43_19_+1100_y+uvz=l=xLyNXO=m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTD9HAAoJEECxmPOUX5FEfl8P/iXu9n/bUI3xWldqwiuF/OXs
AKre78G6dRQaMxnmylzFD+hL8cOIVwItHgicnlC/Prrjttn8CfjTAi/6xDpCC6rU
QsadHhiSU076TyP01PHqRt8IPNAsTcvc4hjyIqxWNt1XO6J+NNc/sDxZxR6lpAbK
ANS8Bq4n//ZLCSTerePgHb5y7II+e67HBzdqlOImXJKuYPYlPx+TQbioPYRCFwfz
z7FQeQsXIZAvdnU45kcZxt1MRvTBvMJB9yOaqBG5C/4X8pVi3SABloyH3kEXGrbm
PYdmW89vyLSR+NfxHafGHVc3KTgh9He7XcWSUSWgUCq3diUErlTgDtKX1bYLe3v7
sD3ULFPB0e9v3uBXHlkbFg6w/h/2PovP40c3jXP3Fs//hPsaGoS550KC2B4yrBfv
BjGpUmNOLiyj8QxALfGOugB08dOVCenihQ6zat8bGx0L3pWO42Iy7nc1rErQquD6
Kpd1y84yjeywkDZXZj53qBOQBIXCG03tsnMG8ZilfflfhKVtBDuknkBh1AXRiqj7
pX90qhK9qQNkIHz5VOHLQRdMI7F72XLwMqehI8Y/kiBu1beRYlj8dMLg46u9c57G
OIjBjNVllm5pRUfPijc3ls0zpD7GNOPaPHH5HlX585w6LShP1TCRinHi07JEX3mq
nSp1lCsH45EU5vmVX0RP
=Njhj
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Feb_2012_13_43_19_+1100_y+uvz=l=xLyNXO=m--
