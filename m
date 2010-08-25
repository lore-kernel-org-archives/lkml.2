Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab0HYCJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 22:09:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57786 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab0HYCJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 22:09:34 -0400
Date: Wed, 25 Aug 2010 12:09:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasesh Mody <rmody@brocade.com>, Jing Huang <huangj@brocade.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: linux-next: build failure after merge of the final tree (net tree
 related)
Message-Id: <20100825120927.c469ce20.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__25_Aug_2010_12_09_27_+1000_VXcqc1U4AcfVQ=u9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Aug_2010_12_09_27_+1000_VXcqc1U4AcfVQ=u9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/net/built-in.o: In function `bfa_ioc_is_operational':
(.opd+0x1c6c8): multiple definition of `bfa_ioc_is_operational'
drivers/scsi/built-in.o:(.opd+0x1b1b0): first defined here

and many more ...

Caused by commit 8b230ed8ec96c933047dd0625cf95f739e4939a6 ("bna: Brocade
10Gb Ethernet device driver") interacting with commit a whole series of
patches to do with the Brocade BFA FC SCSI driver that are in Linus' tree
stretching back to v2.6.32-rc2.

I have reverted that net tree commit (and commit
f04b4dd2b1f533cef0507e0410ffc6732d21a272 ("bna: Delete get_flags and
set_flags ethtool methods") that depends on it).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__25_Aug_2010_12_09_27_+1000_VXcqc1U4AcfVQ=u9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMdHtXAAoJEDMEi1NhKgbsUBsH/3MT7m0mblXd0ysufeh76U73
AKhiRr7kR1qLcgNBcGoc1LiENvFGIASj0tIgnmBW2Pujw5uxGzbHLdhFJUkemuC0
+XVTfkzkGDFjNz998Em5Cjb/6Le4O0QLUfcR6PxTTrG+sZ5PyiYBXL/ZWFrqsIT2
coQ9if7ZXoYd68P4xhZ/TciO9E24Yx01H4i+NvC9DbnHId4sk06UFK39WjHacyKc
sm9d3Im7+2rGddjpCVW9vvInHvoIAs/ScFyFgkN/Ai3t6ffJZ0e1AuUVXcuUVNAN
qetaJ8MU/7aJA7You0PQWxJhr6vWGUE1i3MLsdspvDMFgbw4ACHreDNeHcMud1E=
=DXlQ
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Aug_2010_12_09_27_+1000_VXcqc1U4AcfVQ=u9--
