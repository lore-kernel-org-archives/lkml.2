Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab0FPDjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 23:39:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51897 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425Ab0FPDjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 23:39:02 -0400
Date: Wed, 16 Jun 2010 13:38:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ben Hutchings <bhutchings@solarflare.com>
Subject: linux-next: build warnings after merge of the net tree
Message-Id: <20100616133854.1bbbbb37.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Jun_2010_13_38_54_+1000_mlmjYNNFlOR/cK6T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Jun_2010_13_38_54_+1000_mlmjYNNFlOR/cK6T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the net tree, today's linux-next build (x86_64 allmodconfig)
produced these warnings:

In file included from drivers/usb/gadget/ether.c:123:
drivers/usb/gadget/rndis.c: In function 'gen_ndis_query_resp':
drivers/usb/gadget/rndis.c:197: warning: assignment from incompatible point=
er type
In file included from drivers/usb/gadget/multi.c:67:
drivers/usb/gadget/rndis.c: In function 'gen_ndis_query_resp':
drivers/usb/gadget/rndis.c:197: warning: assignment from incompatible point=
er type
In file included from drivers/usb/gadget/g_ffs.c:30:
drivers/usb/gadget/rndis.c: In function 'gen_ndis_query_resp':
drivers/usb/gadget/rndis.c:197: warning: assignment from incompatible point=
er type

Introduced by commit be1f3c2c027cc5ad735df6a45a542ed1db7ec48b ("net:
Enable 64-bit net device statistics on 32-bit architectures").  This is a
call to dev_get_stats() and the return value is being assigned to a
"struct net_device_stats *".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__16_Jun_2010_13_38_54_+1000_mlmjYNNFlOR/cK6T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwYR04ACgkQjjKRsyhoI8wLqACfTy3XaBsmvmBUChhuf1XeTze0
ZKMAoK+heaf5UztEnxGlCaIER9q937RZ
=y7pG
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Jun_2010_13_38_54_+1000_mlmjYNNFlOR/cK6T--
