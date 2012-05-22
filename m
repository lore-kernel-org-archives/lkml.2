Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751000Ab2EVEK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 00:10:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40523 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2EVEK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 00:10:27 -0400
Date: Tue, 22 May 2012 14:10:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: linux-next: manual merge of the mfd tree with Linus' tree
Message-Id: <20120522141011.353303b12e12cb7469fbeb19@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_14_10_11_+1000_L=TNelhLGkme0MHk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_14_10_11_+1000_L=TNelhLGkme0MHk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
drivers/mfd/da9052-core.c between commit 8614419451d8 ("mfd: da9052: Fix
genirq abuse") from Linus' tree and commit 16e5e204c928 ("mfd: Add ADC
support to the DA9052/53 core") from the mfd tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mfd/da9052-core.c
index 7776aff,5036cf5..0000000
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@@ -663,8 -795,15 +795,14 @@@ int __devinit da9052_device_init(struc
  	if (ret < 0)
  		goto regmap_err;
 =20
 -	desc =3D irq_to_desc(da9052->chip_irq);
 -	da9052->irq_base =3D regmap_irq_chip_get_base(desc->action->dev_id);
 +	da9052->irq_base =3D regmap_irq_chip_get_base(da9052->irq_data);
 =20
+ 	ret =3D request_threaded_irq(DA9052_IRQ_ADC_EOM, NULL, da9052_auxadc_irq,
+ 				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+ 				   "adc irq", da9052);
+ 	if (ret !=3D 0)
+ 		dev_err(da9052->dev, "DA9052 ADC IRQ failed ret=3D%d\n", ret);
+=20
  	ret =3D mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
  			      ARRAY_SIZE(da9052_subdev_info), NULL, 0);
  	if (ret)
@@@ -680,7 -820,9 +819,8 @@@ regmap_err
 =20
  void da9052_device_exit(struct da9052 *da9052)
  {
+ 	free_irq(DA9052_IRQ_ADC_EOM, da9052);
 -	regmap_del_irq_chip(da9052->chip_irq,
 -			    irq_get_irq_data(da9052->irq_base)->chip_data);
 +	regmap_del_irq_chip(da9052->chip_irq, da9052->irq_data);
  	mfd_remove_devices(da9052->dev);
  }
 =20

--Signature=_Tue__22_May_2012_14_10_11_+1000_L=TNelhLGkme0MHk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPuxGjAAoJEECxmPOUX5FEYJkP/3ObuMbNw2232oKGb7zYQMD5
2nHmhCdJQNuQglWqoChn5vAgP1s5zKFfdr/8lvoT1laPekzzlwSFSgfVWFzeaera
ueCGaxjRUAHI5p35fuGsNWG8a2bzMmPoXVFuSXjSGz0fAbF1xYB86FVKAkfTJyFq
ZdAwRCquuuuMrP00b+tM8otj1cATehoDO0kaNLHOfzERKL+/UoXaEfTA3m7/Bd5T
CUedX/iXDSidOTmWCx2NG4V4V23FOtc5pmXPWEZ66myFNrFAGhNeyY/GhuxqypC/
otLTEX5LpuVEPRKYVjQLWnFSCnyGxjmnWI7d0vEh3pGh1PpZb9W9IC9/85W/0bxR
bIaYm8w21hbVGF4bulCagKvMHsnRc9WB/s5xJ8W/2i3ekjFlDXdZr3M/42QWlcFQ
zx9VRYFOc34Oafdw3NFmL+Uo4oPiJKI2sIHdmQWSP87y6fTymRSTx+yokqdwHxHA
Cio/gC/VqD/qQcjoF1I9H5SOIyfjpJmm0pAqBeK9cMZTmQcrQ477y8UwCGRYonZG
4qT3fJI1dgSlo5KiEei5OgpiDiF/RvzmkC7pF9ujvrPSx5QZqCWpb4n92ySUARmC
xYKqFxp6MDv3g+GT4h4ZA/M5WuUq1+2Gh+SsH3+D53rYjNj9IPATIG1KvLhy+e/7
uJZHl0xpuOLanrG4XZRi
=kfGZ
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_14_10_11_+1000_L=TNelhLGkme0MHk--
