Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab1KDEjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 00:39:23 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:51585 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1KDEjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 00:39:21 -0400
Date: Fri, 4 Nov 2011 15:39:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: linux-next: manual merge of the moduleh tree with the v4l-dvb tree
Message-Id: <20111104153911.9e0c0650581af106b33aaf41@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__4_Nov_2011_15_39_11_+1100_vMTQqldO9jjLzmjh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Nov_2011_15_39_11_+1100_vMTQqldO9jjLzmjh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got conflicts in
drivers/media/video/mt9m111.c and drivers/media/video/ov6650.c between
commit 95d20109ad64 ("[media] V4L: replace soc-camera specific
soc_mediabus.h with v4l2-mediabus.h") from the v4l-dvb tree and commit
7a707b89202f ("drivers/media: Add module.h to all files using it
implicitly") from the moduleh tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/media/video/mt9m111.c
index f023cc0,66e3c3c..0000000
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@@ -13,12 -13,11 +13,13 @@@
  #include <linux/log2.h>
  #include <linux/gpio.h>
  #include <linux/delay.h>
 +#include <linux/v4l2-mediabus.h>
+ #include <linux/module.h>
 =20
 +#include <media/soc_camera.h>
  #include <media/v4l2-common.h>
 +#include <media/v4l2-ctrls.h>
  #include <media/v4l2-chip-ident.h>
 -#include <media/soc_camera.h>
 =20
  /*
   * MT9M111, MT9M112 and MT9M131:
diff --cc drivers/media/video/ov6650.c
index d5b0572,2e16806..0000000
--- a/drivers/media/video/ov6650.c
+++ b/drivers/media/video/ov6650.c
@@@ -28,7 -28,7 +28,8 @@@
  #include <linux/delay.h>
  #include <linux/i2c.h>
  #include <linux/slab.h>
 +#include <linux/v4l2-mediabus.h>
+ #include <linux/module.h>
 =20
  #include <media/soc_camera.h>
  #include <media/v4l2-chip-ident.h>

--Signature=_Fri__4_Nov_2011_15_39_11_+1100_vMTQqldO9jjLzmjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOs2xvAAoJEECxmPOUX5FEPd4P/R7cNEhfTYJWa+8zGdXwJHhO
0Nqpaz9ZJ8Xrm1d4dV9fXL2NOAeGV/w9S0iRmHKsFk41GQzLBb2mq8j/ihgIjV7r
XupW082bJugKeD+p9D5s37qBCpXce0KBxEt/nfp5Jkol9AjkA8hlcFo6L9OsL/aS
dZ1qg3xYNEzcZLvNBDOkSZImWR2f0af6I/NwgkBDAoGsRTGxWDkE8ysUv2P58vf9
+x2UplR2ecG1ky2xllMDy0vYG5Fs1uxBhl7H9wg/Lziie4QVWr0stWjBFArfjQPE
jHVI9gfVZHDiwelAKljpw/GsfpUhHQc+z5TQOeU5PHSpdK8VCfrxfOiBqoc3GZTf
gppQEFNJ8/u8g8By0GL+zXF6RvClCN8+1c2uBSKWbSQLUKLKaHOjDVqNLrTYorJr
UAm/MsmF5ebNVVmgR4mWw87JX1JcaGfnOuKfh8xcxb70N12LbcrZokzlWfSI7uDw
2GQPrXEZygRZGQ0WfaQ8Rf03wYtxioAgYJFZwXj5uSe8Ktk8evVfwOy+L/8oPpEc
xRZhjsga9A3zHj7uWFX7dXmsEiHBWIZLImiW4RAOkFUlQu4Frz7RxdNXL9n3hjhX
5bxWnHM6ZVyANuZ1VqU7dye+mnTMJZ+8PKGDKpiZRXVkzHfKv5IQURd/oeSbXCT5
LuazTFekD29At39NQ4nT
=ScdL
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Nov_2011_15_39_11_+1100_vMTQqldO9jjLzmjh--
