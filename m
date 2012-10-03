Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab2JCEaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 00:30:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38526 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2JCEaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 00:30:05 -0400
Date: Wed, 3 Oct 2012 14:29:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, "Jett.Zhou" <jtzhou@marvell.com>
Subject: linux-next: manual merge of the battery tree with the  tree
Message-Id: <20121003142956.468af73c411020b163f53e7b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Oct_2012_14_29_56_+1000_N7uvZ8NT60QZl_Qg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Oct_2012_14_29_56_+1000_N7uvZ8NT60QZl_Qg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

Today's linux-next merge of the battery tree got a conflict in
include/linux/mfd/88pm860x.h between commit 2e57d56747e6 ("mfd: 88pm860x:
Device tree support") from the mfd tree and commit a830d28b48bf
("power_supply: Enable battery-charger for 88pm860x") from the battery
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/mfd/88pm860x.h
index ef3e6b7,b7c5a3c..0000000
--- a/include/linux/mfd/88pm860x.h
+++ b/include/linux/mfd/88pm860x.h
@@@ -359,24 -460,10 +440,25 @@@ struct pm860x_platform_data=20
  	struct pm860x_rtc_pdata		*rtc;
  	struct pm860x_touch_pdata	*touch;
  	struct pm860x_power_pdata	*power;
+ 	struct charger_desc		*chg_desc;
 -	struct regulator_init_data	*regulator;
 -
 -	unsigned short	companion_addr;	/* I2C address of companion chip */
 +	struct regulator_init_data	*buck1;
 +	struct regulator_init_data	*buck2;
 +	struct regulator_init_data	*buck3;
 +	struct regulator_init_data	*ldo1;
 +	struct regulator_init_data	*ldo2;
 +	struct regulator_init_data	*ldo3;
 +	struct regulator_init_data	*ldo4;
 +	struct regulator_init_data	*ldo5;
 +	struct regulator_init_data	*ldo6;
 +	struct regulator_init_data	*ldo7;
 +	struct regulator_init_data	*ldo8;
 +	struct regulator_init_data	*ldo9;
 +	struct regulator_init_data	*ldo10;
 +	struct regulator_init_data	*ldo12;
 +	struct regulator_init_data	*ldo_vibrator;
 +	struct regulator_init_data	*ldo14;
 +
 +	int 		companion_addr;	/* I2C address of companion chip */
  	int		i2c_port;	/* Controlled by GI2C or PI2C */
  	int		irq_mode;	/* Clear interrupt by read/write(0/1) */
  	int		irq_base;	/* IRQ base number of 88pm860x */

--Signature=_Wed__3_Oct_2012_14_29_56_+1000_N7uvZ8NT60QZl_Qg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQa79EAAoJEECxmPOUX5FE7bUP/AyKYqMmsBMMoSAIVHKAWXhD
CkGFS9xn9/gTibFodOX3J9aYj1iPrE2F8ykk37QdY4j/tPrOwt25GM9LUI5oeNbR
X0vyyv7olghiIpU4odMXw0AvmQYNfrZF/XDTt6azfP5Is+o4YRomo5o+mASjUjf+
S4Yz00zSkPidvMdFOda19XELh9bmlU8nguN3BySfx/b7YOgAuxjUjtmcd8V2RlUD
xus1VBc4lXPgKmMJ4ZABRdU83tS/tsnLhhk0g0w4Ps5X0KHaC0NB+z3l2YI/DbgJ
MXrZpwWczN5h1lYVBSn/sIk+KvkXSSKH/AjHsxMP3eAIGNXt6pxFaFros54cvqNW
fzQI5VvB0IR+WgRxyTKrndmfuDGOqcd6s2WpFGSs1bnQgrwuAknRWmiRqvktNxXy
57shYYgIu/07M9Z7UgV4QYpv0E1ZW/OnZILkuxoIz7Tvo5LCG9Hn2Fm71WvZ/Cia
xDbunQEpXjUDYdZUvW1MX0l9/jaodRtkBfmHnjTPt52OVHfSFBgML4oejkLdySfC
dLENEb/s3cA62dvvZN2lSrn9jpdZ7GdPuZB49GUVEjiz/Ej9D4agwbV+O8DYn6Ds
quqCLnZCCsnWaPvatlTt3+2pHthOYy84zcuIbSN02CEp8Ql1NNZq2LM3jARvIlHg
M1xNB+H49lyP1yRfEHHV
=Vlcr
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Oct_2012_14_29_56_+1000_N7uvZ8NT60QZl_Qg--
