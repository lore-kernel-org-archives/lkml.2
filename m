Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab0CVA1K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 20:27:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53660 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab0CVA1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 20:27:07 -0400
Date: Mon, 22 Mar 2010 11:26:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the nfs tree
Message-Id: <20100322112655.0f23c1fb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Mar_2010_11_26_55_+1100_FroTA+.8R0ktTiyb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Mar_2010_11_26_55_+1100_FroTA+.8R0ktTiyb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

After merging the nfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/sunrpc/xprt.c: In function 'xprt_release':
net/sunrpc/xprt.c:1045: error: implicit declaration of function 'xprt_free_=
bc_request'

Caused by commit 0d28e05a53109bb52f254d5eac25dac6e3768b04 ("SUNRPC: Fix a
use after free bug with the NFSv4.1 backchannel").  xprt_free_bc_request()
is only declared for CONFIG_NFS_V4_1 ...

I have used the nfs tree from next-20100319 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Mar_2010_11_26_55_+1100_FroTA+.8R0ktTiyb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkumuU8ACgkQjjKRsyhoI8y2ZACdFBTZMdkM9yR9mpj+W3bZAMmE
AGkAnjpdLG4fxmNizRAlvwwZX+rgQD2s
=FgFQ
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Mar_2010_11_26_55_+1100_FroTA+.8R0ktTiyb--
