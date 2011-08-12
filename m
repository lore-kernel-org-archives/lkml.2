Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab1HLCC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:02:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50118 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab1HLCC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:02:58 -0400
Date: Fri, 12 Aug 2011 12:02:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: linux-next: build failure after merge of the net tree
Message-Id: <20110812120248.a23ecc95e9c1111da3a8ef30@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Aug_2011_12_02_48_+1000_Kpg5XxzSaN+kkFmk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Aug_2011_12_02_48_+1000_Kpg5XxzSaN+kkFmk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

Assembler messages:
Fatal error: can't create drivers/net/ethernet/sun/.tmp_sungem_phy.o: No su=
ch file or directory

Presumably caused by commit e689cf4a0427 ("cassini/niu/sun*: Move the Sun
drivers") theough I don't know why.  I tried throwing away my object
directory, but that didn't help.

Ah, ha!  This looks suspicious (change to drivers/net/Makefile):

+obj-$(CONFIG_SPIDER_NET) +=3D spidernet.o ethernet/sun/sungem_phy.o

I have used the net tree from next-20110811 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Aug_2011_12_02_48_+1000_Kpg5XxzSaN+kkFmk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJORInIAAoJEDMEi1NhKgbsAaEH/RPG8rEDQbAZUlDq2I/8WVww
8mTXFHNhlrmeoVfmlogPNHlFF1+WlV5rbEgZgA1ETnnNeV+n1i7lNauGuz6BsGdE
W0QrD7if1cR4/2JxhRBD1TCAeUgpnjGEMDxituxp3TjQ/6gUcmwYH5RLrWDjt4Ei
4COCW52wQ+0yfIHiX+RWr78FoXf6lwaLTCGQuLUBPSrdpxV5dVufyZbu1W8oZWWC
8BY2uM8F9rjO1urqkDgWyBBbvab3gyogQB5vNpnqZ+w/5saVXfpfsxFVEZKoZIb0
YqZWMcWFcQcphC6q886J0BxI+8TBkztmYBadfS1hQiXxKSQalB0/Fq4NNpPgp9o=
=9nQk
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Aug_2011_12_02_48_+1000_Kpg5XxzSaN+kkFmk--
