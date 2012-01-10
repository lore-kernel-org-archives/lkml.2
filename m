Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab2AJCsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 21:48:11 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:48280 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab2AJCsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 21:48:10 -0500
Date: Tue, 10 Jan 2012 13:47:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: linux-next: manual merge of the rr tree with the nfs tree
Message-Id: <20120110134757.6e1a52401e7b427d4ba4c59b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Jan_2012_13_47_57_+1100_OeksFPPa=jJ0cvMx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jan_2012_13_47_57_+1100_OeksFPPa=jJ0cvMx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in fs/nfs/client.c
between commit 074b1d12fe25 ("NFSv4: Change the default setting of the
nfs4_disable_idmapping parameter") from the nfs tree and commit
5a925e82e106 ("module_param: make bool parameters really bool (drivers &
misc)") from the rr tree.

I fixed it up (see below) and can carry the fix as necessary.

Rusty: shouldn't bools be initialise with true/false instead of 1/0?=20
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/nfs/client.c
index 277dfaf,4a092a0..0000000
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@@ -84,7 -84,7 +84,7 @@@ retry
  /*
   * Turn off NFSv4 uid/gid mapping when using AUTH_SYS
   */
- static int nfs4_disable_idmapping =3D 1;
 -static bool nfs4_disable_idmapping =3D 0;
++static bool nfs4_disable_idmapping =3D 1;
 =20
  /*
   * RPC cruft for NFS

--Signature=_Tue__10_Jan_2012_13_47_57_+1100_OeksFPPa=jJ0cvMx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPC6bdAAoJEECxmPOUX5FE83AP/ikT2gXfEFxbEnCUR0z9Svz+
RCQwSd1BfWbYcImcId6668FG5LV5CW+D5B1ZIMeUDfGxn7CQFL7uVFqyqYsHIiBN
d4su5kPBoIM6aXGdrtRB6Evgzo6MMaKaCcjgio3K3CUAiw24aSvnfCM2lhM/Zx5H
yR368iW/GJLJvBiBdIDHGEtacYBwOOYI/9p2uGF1U0flzQLJnNkHc6ThkVrd1GDX
lC1LD1CnY04uOcUzRtLkftSBAInDMkdPVwPi6AVF3Up5Mr2ZlAf77F/vKJglRyev
oonzHTo4RVCzqXL2Ac7/FSeUZd8G8qKwnHzoG0suFK01284oEt9C4RRHQ86SJr+I
EVOwHmk3PoGinZSVaQmjayB7iwb/vfJQSZlr5NvjjwclQp+Vfugc9jOR0vZCFFDB
Sp+c67ryUfqLdjCiq5/MVeEgm5osiD86LRsmdpCAZXicdZ0L8EzJ6Jfe73EzF6z2
SNr5YBbIToD6JsfgKfYp5XRLI4TmwVbvr60b+7AelAqvFSUh3ayJ7W66Racht6xF
yCU/w878gRd5eTlPsxCOZj75yuk7SzDO24vkeFoUqfj6hkPfbygD3CBZQuhDnSlq
Pp430welVqCx2uPweyhEItArtvcpe86lbAFJDjCo09xRBwB//xnGKHC9Sv5XGLBZ
dcqp2qxXTHQTAPLCrIXg
=m2yz
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jan_2012_13_47_57_+1100_OeksFPPa=jJ0cvMx--
