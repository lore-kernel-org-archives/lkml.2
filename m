Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab1KUCRX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 21:17:23 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:42771 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab1KUCRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 21:17:22 -0500
Date: Mon, 21 Nov 2011 13:17:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: linux-next: build warning after merge of the Linus' tree
Message-Id: <20111121131701.44b49fc7da28170c9ee6b524@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_Nov_2011_13_17_01_+1100_EjYAxwxitb7niML6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Nov_2011_13_17_01_+1100_EjYAxwxitb7niML6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Building Linus' tree today linux-next (x86_64_allmodconfig)
produced quite a few of these warnings:

include/media/soc_camera.h: In function 'soc_camera_i2c_to_vdev':
include/media/soc_camera.h:257:34: warning: cast to pointer from integer of=
 different size [-Wint-to-pointer-cast]

This was introduced by commit 2f0babb7e432 ("[media] V4L: soc-camera:
make (almost) all client drivers re-usable outside of the framework").

This warning is caused by the "grp_id" member of "struct v4l2_subdev" -
which is a u32 - being cast to a pointer.  That pointer is dereferenced,
so I have no idea how that is supposed to work on any 64 bit platform.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__21_Nov_2011_13_17_01_+1100_EjYAxwxitb7niML6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOybSdAAoJEECxmPOUX5FEgJQP/1CtTBXGty19o/NUpXOsPgPN
lnxPuaqsfE1WvESV7fn1sr0D2zBCq0tgbkSk9bUz1xIyNMTW/i/TXHLCYwph3oH/
LjVm6YZWIztEbhnsr1yUoZTPOz8BoR69hHnhZ4j9fcspDRdOkon0sj8ryJtH4Dhc
ip/9ljJi2LZ16YzwO3ObogirKRRJs7snTIhiXBD48xFV6oUHL4IkCdT8XR5dOwv7
NSQXTAR6/3mV0GY9Fy2xHyWjBce9yAJUSKsTHHvFdJ0ZCWU0BN6g/6gu/mhXCZAt
zEgHUDohgeFxRsCjXzEkb0o1R3Dvg+aI180X4BQ57NPZwoFAnbCBehxwiibA/9Ry
yPBxomhh44iPaYjhCwl/GQIsiELaTH9kIY7CxfYSyGCwyGM67KdF5KE9XC3rQraA
b0INznmC521mA2teCTYzY22wEM9YLi4DnHKGtHEwIWwsiBG5X97qCBxKo6nbLOIN
hSV49ITw3hPGK1Z/1C5vht5rWw9iMN+ALisQRKrAOH813n0QfNQQroCV3pfI84N2
xOpORQ48AI2Z8hlPF6FNWdm8ba2barfRpT4e0dQijEAloJd+KpF2Sr/Sd42hIPDW
lC87CB5g/L0gD7aZU85TALAN5vcytkL+tvC2YdzcGLeuHRK1ctF7WCH7psD8Ognm
N+vy1FfJw+mq8w1+g+Op
=uT6r
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Nov_2011_13_17_01_+1100_EjYAxwxitb7niML6--
