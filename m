Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab0FPDs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 23:48:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50104 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab0FPDsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 23:48:54 -0400
Date: Wed, 16 Jun 2010 13:48:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: linux-next: build warning after merge of the final tree (net tree
 related)
Message-Id: <20100616134848.3edd4a25.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Jun_2010_13_48_48_+1000_6znWOPAIaCPcEy.j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Jun_2010_13_48_48_+1000_6znWOPAIaCPcEy.j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) produced this warning:

net/bridge/br_forward.c: In function '__br_deliver':
net/bridge/br_forward.c:76: warning: passing argument 1 of 'br_netpoll_send=
_skb' discards qualifiers from pointer target type
net/bridge/br_private.h:308: note: expected 'struct net_bridge_port *' but =
argument is of type 'const struct net_bridge_port *'

Introduced by commit 91d2c34a4eed32876ca333b0ca44f3bc56645805 ("bridge:
Fix netpoll support").

By the way, that function (br_netpoll_send_skb) is only used in that one
file, so could be static in there.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__16_Jun_2010_13_48_48_+1000_6znWOPAIaCPcEy.j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwYSaAACgkQjjKRsyhoI8z1EACgjvxDGfxcBf+enX5IIF9T3wa9
7cgAoKXwB0Cs6nyaWDuMh2d2vZEK1C+Q
=mDz+
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Jun_2010_13_48_48_+1000_6znWOPAIaCPcEy.j--
