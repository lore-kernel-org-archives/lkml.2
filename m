Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab2AQTwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:52:42 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:24934 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab2AQTwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:52:40 -0500
Date: Tue, 17 Jan 2012 14:50:31 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: kay.sievers@vrfy.org, linux@eikelenboom.it
Subject: [GIT PULL] (xen) stable/for-linus-fixes-3.3 bug-fix for rc1.
Message-ID: <20120117195031.GA21666@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F15D184.0088,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

Please pull this branch, which has one fix:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-lin=
us-fixes-3.3

which is a fix to Kay Sievers global "convert sysdev_class -> device/subsys=
tem" patchset
which inadvertly missed the proper subsystem in the balloon code. The negat=
ive effect
of his patch is that the xen tool stack can't now properly balloon the memo=
ry hence
we can't launch the guests.
 =20
The patch is based on 070680218379e15c1901f4bf21b98e3cbf12b527, which
was the "xen-balloon: convert sysdev_class to a regular subsystem"

Konrad Rzeszutek Wilk (1):
      xen/balloon: Move the registration from device to subsystem.

 drivers/xen/xen-balloon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

And the bug-fix:

Thanks!!

diff --git a/drivers/xen/xen-balloon.c b/drivers/xen/xen-balloon.c
index 3832e30..596e6a7 100644
--- a/drivers/xen/xen-balloon.c
+++ b/drivers/xen/xen-balloon.c
@@ -221,7 +221,7 @@ static int register_balloon(struct device *dev)
 {
 	int i, error;
=20
-	error =3D bus_register(&balloon_subsys);
+	error =3D subsys_system_register(&balloon_subsys, NULL);
 	if (error)
 		return error;
=20

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJPFdDZAAoJEFjIrFwIi8fJWYgIALQ5djnoHXsWzaHpJCBpimqI
5R8+f/2BrhHDyFQt2Mtal20p9n4jIBWcdaAeUT+m1aglAdymRwJxU+vfEK01JShT
ZIMT0ys/uPYpEjHpEbJDLQkFTxWnDSUubF/PGz89ojsQrwHkV8nh1qJXllDcsMlZ
Zh1+yd8T4/qqa9nD9o8FuEOCznDO67uM5qHG0AX1WMXaC4s/ZssLzJ6zR9hE+O+p
EZSXcE1WKTUm7ihv4Zb17+2wZ68UJWGdiM+YRD64MQpQe18Y2qU2MiQRU1gF4PR6
qoXlWyJS60r8vkbg3hik6qumzfVuAdtxEdBpXzKMT3hF0Tp66zAkG9sc2oS/Zdg=
=ajWd
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
