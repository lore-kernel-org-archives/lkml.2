Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab2KMDuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:50:55 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58391 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2KMDux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:50:53 -0500
Date: Tue, 13 Nov 2012 14:50:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Patil, Rachna" <rachna@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: linux-next: manual merge of the staging tree with the mfd tree
Message-Id: <20121113145043.031831301647d5e0a68807f0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Nov_2012_14_50_43_+1100_y+SOWDuOguSv=y7r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Nov_2012_14_50_43_+1100_y+SOWDuOguSv=y7r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got conflicts in
drivers/iio/adc/Kconfig and drivers/iio/adc/Makefile between commit
5e53a69b44e8 ("IIO : ADC: tiadc: Add support of TI's ADC driver") from
the mfd tree and commit 168c9d95a940 ("iio:adc:max1363 move from
staging") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/iio/adc/Kconfig
index 1401ed1,ef5200a..0000000
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@@ -60,11 -73,22 +73,29 @@@ config LP8788_AD
  	help
  	  Say yes here to build support for TI LP8788 ADC.
 =20
+ config MAX1363
+ 	tristate "Maxim max1363 ADC driver"
+ 	depends on I2C
+ 	select IIO_TRIGGER
+ 	select MAX1363_RING_BUFFER
+ 	select IIO_BUFFER
+ 	select IIO_KFIFO_BUF
+ 	help
+ 	  Say yes here to build support for many Maxim i2c analog to digital
+ 	  converters (ADC). (max1361, max1362, max1363, max1364, max1036,
+ 	  max1037, max1038, max1039, max1136, max1136, max1137, max1138,
+ 	  max1139, max1236, max1237, max11238, max1239, max11600, max11601,
+ 	  max11602, max11603, max11604, max11605, max11606, max11607,
+ 	  max11608, max11609, max11610, max11611, max11612, max11613,
+ 	  max11614, max11615, max11616, max11617, max11644, max11645,
+ 	  max11646, max11647) Provides direct access via sysfs and buffered
+ 	  data via the iio dev interface.
+=20
 +config TI_AM335X_ADC
 +	tristate "TI's ADC driver"
 +	depends on MFD_TI_AM335X_TSCADC
 +	help
 +	  Say yes here to build support for Texas Instruments ADC
 +	  driver which is also a MFD client.
 +
  endmenu
diff --cc drivers/iio/adc/Makefile
index 4410a90,54ac7bb..0000000
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@@ -6,6 -6,7 +6,8 @@@ obj-$(CONFIG_AD_SIGMA_DELTA) +=3D ad_sigm
  obj-$(CONFIG_AD7266) +=3D ad7266.o
  obj-$(CONFIG_AD7476) +=3D ad7476.o
  obj-$(CONFIG_AD7791) +=3D ad7791.o
+ obj-$(CONFIG_AD7887) +=3D ad7887.o
  obj-$(CONFIG_AT91_ADC) +=3D at91_adc.o
  obj-$(CONFIG_LP8788_ADC) +=3D lp8788_adc.o
+ obj-$(CONFIG_MAX1363) +=3D max1363.o
 +obj-$(CONFIG_TI_AM335X_ADC) +=3D ti_am335x_adc.o

--Signature=_Tue__13_Nov_2012_14_50_43_+1100_y+SOWDuOguSv=y7r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQocOTAAoJEECxmPOUX5FEUasP/jSKR7hp3xVhFTtVouJYjPgm
r8mutpxxR1iIbPEuMOqjeMzgncxZJE7MQOkDHRBJeeGNEnMjys/BganVAAlYeEyz
+zX8pIIOd2Ks+1/4D3yfYv8RoHy3OFtdRv69bunAuOROIxjLP/N9Rey7uHucmQEq
POvzmyUsmXuE7ZJUgQyYFXLOO8GsdDArfPJwg6Ee7rZN6PKTGz+yP9j3SOFL4oin
oouQ/7AJJApxsqnQlNYtDDVUSarJCwhmTQT1wqjvyu3qn4wxjQ5VcdnX3Cpvy5t+
7+E/NPcyd1V5h3pvOgEKZGuf4InKJLRtZAep9k4aYIDF8vXIr74oV+2HGadWPneU
fIdgM0nSa3jmjHEsJ9WaV8KTTPUli3I4KWIWbRejLcbVaUGVDxcHhw5+iM7Np+Hw
9zUBcpQ4psFfxgC1nnMAgdD/M3Ej/1kDlBr1zzmQgUuMbY9h15yCYYhr54ndXuf7
3C1aDz9FdQYpzaJofgmNTuCtaqoe25VyghXVMFIgv3JP44hLuAYKPbq/TnGzyhaj
pr/6QaHTsVc6cmKPN2z3T9HZUhi4NRUGazg2cvMXQPXA1Z32JyiZj9wltCubTeon
FlwlxzgCLT0Bm2VL0OAEW9kF98k6DvMijn89slFUSVjCHOl4loHK5we3uz534mPV
G0uv8hW/99Vm9iN2Mze3
=6RWP
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Nov_2012_14_50_43_+1100_y+SOWDuOguSv=y7r--
