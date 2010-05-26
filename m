Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab0EZBnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:43:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47673 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258Ab0EZBnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:43:12 -0400
Date: Wed, 26 May 2010 11:43:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus <torvalds@linux-foundation.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: linux-next: build warning in Linus' tree
Message-Id: <20100526114306.5fa6fa0e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__26_May_2010_11_43_06_+1000_4JtEDsVOodOMmm_U"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_May_2010_11_43_06_+1000_4JtEDsVOodOMmm_U
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

net/core/sock.c: In function 'sock_update_classid':
include/net/cls_cgroup.h:42: warning: 'classid' may be used uninitialized i=
n this function
include/net/cls_cgroup.h:42: note: 'classid' was declared here

In the case that rcu_dereference() returns a value < 0, classid will not
be assigned in task_cls_classid().  I don't know if this is possible - if
not, then why is the test there?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__26_May_2010_11_43_06_+1000_4JtEDsVOodOMmm_U
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv8fKoACgkQjjKRsyhoI8x8rACeNVbg5cEjY1XSSM3/tpBf/hCI
+98AnjFWamliWHa17+7nkP0ZOeO8G1Jg
=4Brt
-----END PGP SIGNATURE-----

--Signature=_Wed__26_May_2010_11_43_06_+1000_4JtEDsVOodOMmm_U--
