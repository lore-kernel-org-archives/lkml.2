Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab2GBGkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 02:40:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41130 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2GBGkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 02:40:09 -0400
Date: Mon, 2 Jul 2012 16:39:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20120702163959.71926d13da03536f266a90d2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Jul_2012_16_39_59_+1000_RFG6r0R9TXmKCDpO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Jul_2012_16_39_59_+1000_RFG6r0R9TXmKCDpO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
kernel/printk.c between commit 084681d14e42 ("printk: flush continuation
lines immediately to console") from Linus' tree and commit "printk: add
generic functions to find KERN_<LEVEL> headers" from the akpm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/printk.c
index a6f19ef,f591849..0000000
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@@ -1399,6 -1301,11 +1399,7 @@@ asmlinkage int vprintk_emit(int facilit
  			    const char *fmt, va_list args)
  {
  	static int recursion_bug;
 -	static char cont_buf[LOG_LINE_MAX];
 -	static size_t cont_len;
 -	static int cont_level;
+ 	int kern_level;
 -	static struct task_struct *cont_task;
  	static char textbuf[LOG_LINE_MAX];
  	char *text =3D textbuf;
  	size_t text_len;

--Signature=_Mon__2_Jul_2012_16_39_59_+1000_RFG6r0R9TXmKCDpO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP8UI/AAoJEECxmPOUX5FEm6IP/31tnVN/R+LrerF1VnNfVRHx
F4n+K9sIFun8VBbVeRt5OrezOarFspfiHhh9hOWucERsKnZ0UVlzjwfZX8jaWgNx
W5SJuNL9feYug2FQSFrnCQ/LR0S9dNtk3mBnXotRixK9Lh6Sf/0jNME17K7Qd90V
0U76SqQRL21RFmgK9kqhN+x8nPBUjEK/VdrvwdSBaGr7I36jPvHsR/SQx3hmUErQ
kLDh7sr159YwK3ixZEq1C9FSIDIQc50vSp38+6T0o8r/qGUdikZXRJJZbzEWKPjS
A2w6meo1SgkDqJ8kgTwoo0i4BKui2Tq4y115PbMTeMtxncL4MuauYftTHrHaZXJ2
crHiQKeRciQilHnRu6UZ2no5wRihUGl/2dOOhef7f4nXgLE7zBwpJgms3bBBJSF5
0pBuwf3/Qbz5ezxOzO2j+2dyxp8XuBOnNzUCMil6yTJrXZjzi/HqLxl6RbM3dlhS
sLafJ1NaSAxJufUctSOeZ7P2FhxjzVVk86ALaVbtIMYR0INpfoeJ3d0RFsMKJsYi
75X5w0RoIsq9f8k+TXF/qEA3CUWasxu49vmCh/vPIf8Rug0XbRIeZCHZlTNbzuoL
iH6YejyXBu4wsPZ6Wufb3yIFcEEwsvt8QznNz3oRFs9aEmYmyIUYBgNZRZIDdkYH
9+tfAb4i8l1UaUzpwZAw
=pcbT
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Jul_2012_16_39_59_+1000_RFG6r0R9TXmKCDpO--
