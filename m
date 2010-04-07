Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab0DGC6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 22:58:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52303 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab0DGC6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 22:58:25 -0400
Date: Wed, 7 Apr 2010 12:58:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dimitris Michailidis <dm@chelsio.com>, Jiri Pirko <jpirko@redhat.com>
Subject: linux-next: build failure after merge of the net tree
Message-Id: <20100407125817.e8e1d174.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_Apr_2010_12_58_17_+1000_4K7F55LMPdeEflYY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Apr_2010_12_58_17_+1000_4K7F55LMPdeEflYY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the wireless tree, today's linux-next build (x86_64 allmodcon=
fig)
failed like this:

drivers/net/cxgb4/cxgb4_main.c: In function 'set_addr_filters':
drivers/net/cxgb4/cxgb4_main.c:264: error: dereferencing pointer to incompl=
ete type
drivers/net/cxgb4/cxgb4_main.c:265: error: dereferencing pointer to incompl=
ete type

Caused by commit b8ff05a9c3237f694a1c3bf8ceec3bf6c3c14b15 ("cxgb4: Add
main driver file and driver Makefile") from Linus' tree interacting with
commit 22bedad3ce112d5ca1eaf043d4990fa2ed698c87 ("net: convert multicast
list to list_head").  The latter removed struct dev_addr_list.

I have reverted commit b8ff05a9c3237f694a1c3bf8ceec3bf6c3c14b15 (and
43e9da8d782b8a40d5127fcc59ac2e543cf16d7d ("net: Hook up cxgb4 to Kconfig
and Makefile") that depended on it) for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_Apr_2010_12_58_17_+1000_4K7F55LMPdeEflYY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku79MkACgkQjjKRsyhoI8wsIACfQ3NMx87Igru+yKuNBsvrisEQ
ROwAoKcBypm+GE6W6JVNfG4u6FL6kITF
=jxnJ
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Apr_2010_12_58_17_+1000_4K7F55LMPdeEflYY--
