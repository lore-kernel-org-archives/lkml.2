Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061Ab1KAA7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:59:05 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:33388 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab1KAA7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:59:03 -0400
Date: Tue, 1 Nov 2011 11:58:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the crypto-current tree
Message-Id: <20111101115851.2e37ac680db78bdba0661691@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_11_58_51_+1100_R__G+wW+4zIqxa7J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_11_58_51_+1100_R__G+wW+4zIqxa7J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

After merging the crypto-current tree, today's linux-next build (x86_64
allmodconfig) failed like this:

  GEN     /scratch/sfr/x86_64_allmodconfig/Makefile
scripts/kconfig/conf --allmodconfig Kconfig
net/Kconfig:5:error: recursive dependency detected!
net/Kconfig:5:	symbol NET is selected by CRYPTO_USER
crypto/Kconfig:103:	symbol CRYPTO_USER depends on CRYPTO
crypto/Kconfig:15:	symbol CRYPTO is selected by BT
net/bluetooth/Kconfig:5:	symbol BT depends on NET
warning: (SCSI_CXGB3_ISCSI && SCSI_CXGB4_ISCSI && SCSI_BNX2X_FCOE) selects =
NETDEVICES which has unmet direct dependencies (NET)
warning: (SCSI_CXGB3_ISCSI && SCSI_CXGB4_ISCSI && SCSI_BNX2_ISCSI && SCSI_B=
NX2X_FCOE) selects ETHERNET which has unmet direct dependencies (NETDEVICES=
 && NET)
#
# configuration written to .config
#
WITHOUT_DISTCC:=20
ARCH=3Dx86_64
CCVER=3D4.6
net/Kconfig:5:error: recursive dependency detected!
net/Kconfig:5:	symbol NET is selected by CRYPTO_USER
crypto/Kconfig:103:	symbol CRYPTO_USER depends on CRYPTO
crypto/Kconfig:15:	symbol CRYPTO is selected by BT
net/bluetooth/Kconfig:5:	symbol BT depends on NET
warning: (SCSI_CXGB3_ISCSI && SCSI_CXGB4_ISCSI && SCSI_BNX2X_FCOE) selects =
NETDEVICES which has unmet direct dependencies (NET)
warning: (SCSI_CXGB3_ISCSI && SCSI_CXGB4_ISCSI && SCSI_BNX2_ISCSI && SCSI_B=
NX2X_FCOE) selects ETHERNET which has unmet direct dependencies (NETDEVICES=
 && NET)
*
* Restart config...
*
*
* Security options
*
Enable access key retention support (KEYS) [Y/n/?] y
  TRUSTED KEYS (TRUSTED_KEYS) [M/n/?] m
  ENCRYPTED KEYS (ENCRYPTED_KEYS) [M/n/y/?] m
  Enable the /proc/keys file by which keys may be viewed (KEYS_DEBUG_PROC_K=
EYS) [Y/n/?] y
Restrict unprivileged access to the kernel syslog (SECURITY_DMESG_RESTRICT)=
 [Y/n/?] y
Enable different security models (SECURITY) [N/y/?] (NEW) aborted!

Console input/output is redirected. Run 'make oldconfig' to update configur=
ation.

Presumbly caused by commit ea8bdfcff175 ("crypto: user - Add dependency
on NET").

I have used the crypto-current tree from next-20111025 for today (i.e. that
commit has not been added to linux-next today).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Nov_2011_11_58_51_+1100_R__G+wW+4zIqxa7J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr0RMAAoJEECxmPOUX5FEjgUP/RdMcNJnhvFDI0qWPpYJ2ScK
6cvv524q/+EjRtVdH1X/CsU8ExdykGiSpaE8Wnrpot5s96d1kAQlGS+gMxVbaSC4
SvIm6KsqhOpLSFbpaUyf3VJZt9HOhNOiMeWfh2+5KfOaYJlIFW6IJS2GvkQBx+3p
t0gRvaGaa+IG3a/stIavyLnhpejthBY5E1Fbdn/LOfM0XSvStlgAJOl5/uRVBWz8
UX72JsXNIewULi5qNYI8reeFQhCBnrqhHk76ykQ9OZYrZtTbYW8VeiD6ku/SSE4X
+2jNUdHVS5t4E6acLWCSMr9eJe5/ogS6Ac1Lf5ZUmzW+yBs3PDiIgFpep2XFtjtq
OQCZC3YhdjALkcuH7buVPoTM32w6PRvx7UCMAWncxzt0Jbnko7qhJRPc1zmC8rDE
ieX383myMPIb/Gt4blIFyWj445S+WEQB+HRiPThvr1kdil3ogDkhW3gy1ePAdo4e
q6S8etEuf8pNiWuaErvcWuRpPvDs4ENRyjDjn4lw5XSZXW/aPB08au719hESh1Cy
SpQ6qR9anMbdha4BARW6dRuL4HHYf320EA1fcfBzZ+/cjomDX6+8Aun3ZNP3XMWr
i1tZNUR9O5BxPfWXS66x+l/3+mEun7Ojl/9ygcdiZfMNwzrZjEtMhHoom5mcQFb2
vnIUbZKQx2c+Knc2enSP
=V0R5
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_11_58_51_+1100_R__G+wW+4zIqxa7J--
