Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab2DQAol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 20:44:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51477 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab2DQAoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 20:44:39 -0400
Date: Tue, 17 Apr 2012 10:44:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning in Linus' tree
Message-Id: <20120417104430.d1844b17e4c7d5ffb132f816@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Apr_2012_10_44_30_+1000_sP/FiC5lyVPXHy0b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Apr_2012_10_44_30_+1000_sP/FiC5lyVPXHy0b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

Building Linus' tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/block/xen-blkback/xenbus.c: In function 'xen_blkbk_discard':
drivers/block/xen-blkback/xenbus.c:419:4: warning: passing argument 1 of 'd=
ev_warn' makes pointer from integer without a cast [enabled by default]
include/linux/device.h:894:5: note: expected 'const struct device *' but ar=
gument is of type 'long int'

Introduced by commit 3389bb8bf761 ("xen/blkback: Make optional features
be really optional").  Passing "dev-dev" to dev_warn() was hopefully not
intended ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Apr_2012_10_44_30_+1000_sP/FiC5lyVPXHy0b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPjLzuAAoJEECxmPOUX5FEgo0P/1W0Pm9ttDteS9m9dohzQsj/
pKbJbYqec5ntAbDAY24BTOoxTqN48EETXJ5uO/SI2OZ5scw5hZ5qs9he2kaQq/CT
7uEPkYTv4W7M9YIu0Ty/PRSmQJseau9+che2Z6C4ZgnIreWSF/UQ3oiaI8TwYRv0
rsdB4j8JOU6hngkTiWMyeQDk0zgLtiEjgYH/pDy05+rRlJ0/YpfTF/R9G+g98QXJ
Nxk8b6aLewsNp7lcunqVTppPz4V7oKX+FMmgK/VFCF6fzmZofs/c6Z5/Phuf7afj
MyM4YNkK0XzYOmTtyE29hzHfGYTWTTEeoPsAfYelXDW2PzAuH5eJLt+2LHx75c7t
axLo8RLCyN3MHVwKODsdxwgYqgyvAkvXMu14npj2IiieMYNIO2rqO7mloC5ODN+B
DBrHKCPYDbkQ5csYbH/T+Dsu8JUMiMaWUnnBqyIyFs+J1QKplJPUje/ROZ9mL7yY
NGKKWdQdeXYAueXOSOHXE09kno6UbZXAIvCAQgDLMqhRXHX7BKEGPNKB1n7+ZqMX
LpHRbGC/K6jMF0Jt94jNpF3dLirvuVbigM6+mfCrXx5UakKVnNA7VtuePxU5e41B
6wvmA3Bzldt2UWft6VAp+XZhypdnEIpL4S4uLRB7DD/BawrWhuAL0niIYs9M/ubN
cEkBKzapjSADuDCk5Alk
=eAGe
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Apr_2012_10_44_30_+1000_sP/FiC5lyVPXHy0b--
