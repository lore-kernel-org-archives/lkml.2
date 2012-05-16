Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab2EPGJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:09:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37832 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab2EPGJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:09:22 -0400
Date: Wed, 16 May 2012 16:09:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20120516160906.25825987b7cd731a4b5215e1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_May_2012_16_09_06_+1000_.JtteOF.Awfz+KnG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_May_2012_16_09_06_+1000_.JtteOF.Awfz+KnG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/built-in.o: In function `wm8400_i2c_probe':
wm8400-core.c:(.text+0x100165): undefined reference to `devm_regmap_init_i2=
c'
drivers/built-in.o: In function `wm8400_module_init':
wm8400-core.c:(.init.text+0xb43c): undefined reference to `i2c_register_dri=
ver'
drivers/built-in.o: In function `wm8400_module_exit':
wm8400-core.c:(.exit.text+0x655): undefined reference to `i2c_del_driver'

Probably caused by commit 96cd102ae039 ("mfd: Don't support non-modular
wm8400 build") which was introduced to fix other problems.  In this
build, CONFIG_I2C=3Dm and CONFIG_REGMAP_I2C=3Dm.

I have used the mfd tree from next-20120511 again for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__16_May_2012_16_09_06_+1000_.JtteOF.Awfz+KnG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPs0SCAAoJEECxmPOUX5FEuHgQAITkVs8DPf8QkdfehRwZ1wWH
IZ79eI4+FBlj/TFJ0xBeGz9vMImADgIk5Zu0uhQ7MrCR74dzrNdG5DILgJoUBRaQ
hB2Jiu9znZKNb4ZNJGAdjBd8vlSM8k96xWElrNi9c7/H0TFxI0BrUmaXPbEZW7fX
7YNRiZ3290u4T5+2J4r2sEmN0kY08QI+4P+kYdi+4IR0bX1WfeqwUxtSE8jQ/uRw
rDZBcAMmwHaGVP/PAsRAL2pwC1HLq5gcammMSBZuqqvsLyBdKtgRSYRARMRJQu+l
bfZm5LoaWSGOertoF/wxh+0ZMW6+gBMlI91Kh3ABOLrGTGO69kMGYe3gn7svkXZs
O+g4L9yQzzFkXld/iy+OyxhMuoFSJzNQyY05seB8eK/2zYM5H10pniLOrJeUKelj
5o+QWEl3edurVVhnpcnrEjurG4gReUGXYCBdh2oY5IgUQRmihmlchp67OuriCM/e
LCh3fb5pKRycKk5zBu49HmjGjNKUSjx4zScgpgB5E1zkh1TytBk9dw3WD1P2/1BJ
ZrsM0OwsdX+QM2L7TxsviONbzsHlPF9/N9bsIIdc9hfyisiPZZbsQFBun0sX5xSm
3DX6ADRkdqDAYjBHrMqEBnQCkOnh4Hraj2+tM56wDf2CtjcW4YCE370Br4VkXwR8
EAd3U5DQNC7Lm873zTX8
=zF9I
-----END PGP SIGNATURE-----

--Signature=_Wed__16_May_2012_16_09_06_+1000_.JtteOF.Awfz+KnG--
