Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab1HLAhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 20:37:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35528 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab1HLAhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 20:37:52 -0400
Date: Fri, 12 Aug 2011 10:37:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20110812103740.3eb586424c1355448e8cedc3@canb.auug.org.au>
In-Reply-To: <20110811035552.GB15906@opensource.wolfsonmicro.com>
References: <20110811131129.f0d6226079d86e8f4a5ae920@canb.auug.org.au>
	<20110811035552.GB15906@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Aug_2011_10_37_40_+1000_vn62IbOyUTxzfmqN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Aug_2011_10_37_40_+1000_vn62IbOyUTxzfmqN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Thu, 11 Aug 2011 13:06:23 +0900 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> On Thu, Aug 11, 2011 at 01:11:29PM +1000, Stephen Rothwell wrote:
>=20
> > Caused by commit 40045a85df0e ("ASoC: Fix SPI driver binding for WM8987=
").
>=20
> No it wasn't, it was there already.  Anyway, should be fixed now.

Thanks.

> Do you have any idea what you're doing to turn on this detection?  It
> really shouldn't be something that's specific to the x86 build but
> there's nothing obvious I can see that does it.

My x86_64 allmodconfig build is (effectively) done like this (I am using
gcc v4.5.2):

echo CONFIG_PROFILE_ALL_BRANCHES=3Dn >../x86_64_allmodconfig.except
echo CONFIG_DEBUG_INFO=3Dn >>../x86_64_allmodconfig.except
echo CONFIG_X86_DECODER_SELFTEST=3Dn >>../x86_64_allmodconfig.except
KCONFIG_ALLCONFIG=3D../x86_64_allmodconfig.except \
        make O=3D../x86_64_allmodconfig allmodconfig
make O=3D../x86_64_allmodconfig -j48 -s

> Out of interest you used to carry reverts for commits when you'd
> identified them but that seems not to happen any more?

It depends on when I find a problem.  If I find a build problem
immediately after mergeing a particular tree, I reset linux-next and use
the previous version of the tree instead.  If I do not find the problem
until after I have completely merged all the trees, I may revert a
problem commit, or add a patch (is there is an interaction between two
trees).  In the latter case I will carry the revert or patch as long as
needed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Aug_2011_10_37_40_+1000_vn62IbOyUTxzfmqN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJORHXUAAoJEDMEi1NhKgbscRQH/RRqIXxqox89T/50O+5l2pz8
cPELYq2QdLJLeAX6EkLN/rBd8xyfyOkuvDfgAyg7u7N75MR3bvlG6yYYMTL3LB5x
3HAj4xdfras0P88OV75rfcqDzCxlGe6uGBQRbSSffiiAl76qLtLX8jjxfXXWKhLI
211KZlil7RcmkaBtunrQp74pd4fD/jeMoNPMHJvVS8bIsMJLsUHLiulX8235VP/P
sFY/lldXGCMz7VpHdgRWYDf6Y34lCYjT4A3eRGNVHjQ/ahqRmq+Touu7zn2OEwew
FGIn1J964lzvw3ANwFXSvM3dF1TGsl6Z2ZS/Hcq37Cb0+iZWC9fnCJh74DMTI30=
=i1ut
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Aug_2011_10_37_40_+1000_vn62IbOyUTxzfmqN--
