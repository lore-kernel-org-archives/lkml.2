Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab0GYDHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 23:07:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48811 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab0GYDHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 23:07:32 -0400
Date: Sun, 25 Jul 2010 13:07:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] of: Provide default of_node_to_nid() when CONFIG_NUMA
 is not set
Message-Id: <20100725130723.a5192793.sfr@canb.auug.org.au>
In-Reply-To: <20100724154331.22701.3409.stgit@angua>
References: <20100724154331.22701.3409.stgit@angua>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__25_Jul_2010_13_07_23_+1000_RD.pz8Eexz.QQVh="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__25_Jul_2010_13_07_23_+1000_RD.pz8Eexz.QQVh=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Sat, 24 Jul 2010 09:43:31 -0600 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> of_node_to_nid() is only relevant for NUMA.  Don't force architectures to
> implement it if CONFIG_NUMA is not set.

Why not just do:

#ifndef of_node_to_nid
static inline int of_node_to_nid(struct device_node *device) { return 0; }
#define of_node_to_nid	of_node_to_nid
#endif

in include/linux/of.h

and then add:

#define of_node_to_nid	of_node_to_nid

Where it is declared/defined for each arch ...
(it would be nice if all the archs were consistent in where it was
declared).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__25_Jul_2010_13_07_23_+1000_RD.pz8Eexz.QQVh=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMS6prAAoJEDMEi1NhKgbshFMH/i8Aj76EKx/9C5bPwVVHExHD
pYd2B3ivu0HASm+xvMsZE+8AAsRmRrfHczhyLgQDw0SbxsvWmZKAP6bJg8KscMSF
s73yV3tvEzCZpgTtCks/PxjVjkt/MHdSgyzaD+vcW62ZKyuNFXnGOEBbnC8d/v5G
G7aQ5gFrLMLUbdoGL+C1aSRr283ur2Wdukfe5ooVgoao3EayDvZOhlxr5aF2r4nq
WsZf5is1JQqwzcDiM2PykD8ReTtE+ZG/IUBzaOUi1OsxYhOMCEJsOm+egr93++lW
HKqd/qgvyKwL2tlTAnYttTsgtQCWtA2zX16ef/Ea9kLgVeOd935Plk2pcfG6XXA=
=FG69
-----END PGP SIGNATURE-----

--Signature=_Sun__25_Jul_2010_13_07_23_+1000_RD.pz8Eexz.QQVh=--
