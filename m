Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab0EYELH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 00:11:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53425 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab0EYELF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 00:11:05 -0400
Date: Tue, 25 May 2010 14:10:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20100525141046.975afe1f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__25_May_2010_14_10_46_+1000_Wsd_yZi00YjEYOvi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_May_2010_14_10_46_+1000_Wsd_yZi00YjEYOvi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from net/socket.c:97:
include/net/cls_cgroup.h: In function 'task_cls_classid':
include/net/cls_cgroup.h:33: error: request for member 'classid' in somethi=
ng not a structure or union
In file included from net/core/sock.c:126:
include/net/cls_cgroup.h: In function 'task_cls_classid':
include/net/cls_cgroup.h:33: error: request for member 'classid' in somethi=
ng not a structure or union
In file included from net/sched/cls_cgroup.c:23:
include/net/cls_cgroup.h: In function 'task_cls_classid':
include/net/cls_cgroup.h:33: error: request for member 'classid' in somethi=
ng not a structure or union

CONFIG_CGROUPS=3Dy, CONFIG_NET_CLS_CGROUP=3Dy

Caused by commit f845172531fb7410c7fb7780b1a6e51ee6df7d52 ("cls_cgroup:
Store classid in struct sock") from the net-current tree.

I have reverted that commit for today (and commit
8286274284e15b11b0f531b6ceeef21fbe00a8dd "tun: Update classid on packet
injection" that depends on it).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_May_2010_14_10_46_+1000_Wsd_yZi00YjEYOvi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv7TcYACgkQjjKRsyhoI8zUmgCeMCg+SZSDDaXdnG6V/mm5c2bt
AJUAni7pzMR/16ME6zt4pM+VJ1UMZbDp
=wNtP
-----END PGP SIGNATURE-----

--Signature=_Tue__25_May_2010_14_10_46_+1000_Wsd_yZi00YjEYOvi--
