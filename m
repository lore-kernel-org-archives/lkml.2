Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab2CNGG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 02:06:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45831 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab2CNGG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 02:06:56 -0400
Date: Wed, 14 Mar 2012 17:06:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the arm-soc tree with the sound-asoc
 tree
Message-Id: <20120314170628.4b0b5688441624a7a080d7cd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Mar_2012_17_06_28_+1100_/ahAiuvDZHceXEW8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Mar_2012_17_06_28_+1100_/ahAiuvDZHceXEW8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-imx/mach-imx27_visstrim_m10.c between commit 5ec65ee589fd
("ASoC: mx27vis-aic32x4: Convert it to platform driver") from the
sound-asoc tree and commit f52f5a5503b5 ("i.MX27: visstrim_m10: Add video
support") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/mach-imx27_visstrim_m10.c
index 428459f,0a1643c..0000000
--- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
+++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
@@@ -263,7 -393,10 +393,11 @@@ static void __init visstrim_m10_board_i
  	imx27_add_fec(NULL);
  	imx_add_gpio_keys(&visstrim_gpio_keys_platform_data);
  	platform_add_devices(platform_devices, ARRAY_SIZE(platform_devices));
+ 	platform_device_register_resndata(NULL, "soc-camera-pdrv", 0, NULL, 0,
+ 				      &iclink_tvp5150, sizeof(iclink_tvp5150));
+ 	gpio_led_register_device(0, &visstrim_m10_led_data);
+ 	visstrim_camera_init();
 +	imx_add_platform_device("mx27vis", 0, NULL, 0, NULL, 0);
  }
 =20
  static void __init visstrim_m10_timer_init(void)

--Signature=_Wed__14_Mar_2012_17_06_28_+1100_/ahAiuvDZHceXEW8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYDVkAAoJEECxmPOUX5FEvF0P/0bpOC1/spoAUfIFoU8nVo80
1J54VhhQMOeUcQQePiw39avtAHzcEmamORkZe80EhW0yXnPDxIffvOKHN9zRvI6E
pElcksa4lW7DgPLC6fkRzLOsQza8SMsviIQ8Rk6VROJBq0e9qRK/+YzrIjEhNIpE
cG8DdzEviX5x4nU3GONYcrQOQnY0TF0UcftI6IvJx8r19N513KVDQv58X4hi2jCV
USpbDx3WufjikdPUxCGvBJ8j/pR/VY+wCE7dOT3EOSEDGZ1SYRu/06nCdiIP6RBq
0YNShY2SThh7/n1rmlFJaE7ub3wFhaeop7puCcLLf/2tgXtT/sYw+l7gO9EGs2qG
mJDqR2otLCKGiW/H376NCITRkWLhu8NwxgPPgYN5WHnlY3YWx5nctZ6uPDq1gkXw
CsfcIQcQKpjufKelear5g3f0pXOZu8efIUixCptuN8mX3q/EvexVRpGS0cCW3mY8
t/SMtR2JuQXLhEy2SaNbgL6Wtog1O0cAY6JpRdle4OTmYU9XPrvJ5VynxUvMIdBD
vlATdzNeXZ2o6s06chS/oeU3WXZ7lzAbSpIak2FF4xB91ZLJiDlhZ3PWcGZoNR2w
hW3OS0MLNpliidp0tXY01Z8SCM72IlT56G9GCedwwSEB6W9lO+gCx9+r9AerSRE5
fI1k02h8XzWfZ0Cd9mFE
=5dty
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Mar_2012_17_06_28_+1100_/ahAiuvDZHceXEW8--
