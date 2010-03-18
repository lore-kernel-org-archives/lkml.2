Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab0CREYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 00:24:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36179 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab0CREYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 00:24:05 -0400
Date: Thu, 18 Mar 2010 15:23:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tom Herbert <therbert@google.com>
Subject: linux-next: build failure after merge of the final tree (net tree
 related)
Message-Id: <20100318152351.df9e11a3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__18_Mar_2010_15_23_51_+1100_nmirc.aVGp6rZyRq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Mar_2010_15_23_51_+1100_nmirc.aVGp6rZyRq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

net/core/dev.c: In function 'net_rps_action':
net/core/dev.c:3183: error: implicit declaration of function '__smp_call_fu=
nction_single'

Caused by commit 0a9627f2649a02bea165cfd529d7bcb625c2fcad ("rps: Receive
Packet Steering") from the net tree.   This config does not have
CONFIG_SMP set.  __smp_call_function_single is only available when
CONFIG_SMP is set.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__18_Mar_2010_15_23_51_+1100_nmirc.aVGp6rZyRq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuhqtcACgkQjjKRsyhoI8wNuACfZ+5wMQY1DNF+VrcI+LsBPOp4
10MAn3DzBVoFzF/xJmS2unuvdyUE5kM3
=KEtx
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Mar_2010_15_23_51_+1100_nmirc.aVGp6rZyRq--
