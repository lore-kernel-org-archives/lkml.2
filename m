Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965028Ab2EWDCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 23:02:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60697 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964974Ab2EWDCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 23:02:02 -0400
Date: Wed, 23 May 2012 13:01:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: linux-next: manual merge of the mfd tree with Linus' tree
Message-Id: <20120523130154.e5c745258e22a992dcc21723@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_May_2012_13_01_54_+1000_u8Ko1fhpL8ZnI.BN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_May_2012_13_01_54_+1000_u8Ko1fhpL8ZnI.BN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
drivers/mfd/Makefile between commits dece3709b71a ("mfd/db5500-prcmu:
delete DB5500 PRCMU support") and 72fb92200d6c ("mfd/ab5500: delete
AB5500 support") from Linus' tree and commit d28f1db8187d ("mfd: Remove
confusing ab8500-i2c file and merge into ab8500-core") from the mfd tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mfd/Makefile
index 43672b8,afe96b2..0000000
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@@ -87,12 -91,14 +91,11 @@@ obj-$(CONFIG_PCF50633_GPIO)	+=3D pcf50633
  obj-$(CONFIG_ABX500_CORE)	+=3D abx500-core.o
  obj-$(CONFIG_AB3100_CORE)	+=3D ab3100-core.o
  obj-$(CONFIG_AB3100_OTP)	+=3D ab3100-otp.o
  obj-$(CONFIG_AB8500_DEBUG)	+=3D ab8500-debugfs.o
  obj-$(CONFIG_AB8500_GPADC)	+=3D ab8500-gpadc.o
  obj-$(CONFIG_MFD_DB8500_PRCMU)	+=3D db8500-prcmu.o
- # ab8500-i2c need to come after db8500-prcmu (which provides the channel)
- obj-$(CONFIG_AB8500_I2C_CORE)	+=3D ab8500-i2c.o
+ # ab8500-core need to come after db8500-prcmu (which provides the channel)
+ obj-$(CONFIG_AB8500_CORE)	+=3D ab8500-core.o ab8500-sysctrl.o
 -obj-$(CONFIG_MFD_DB5500_PRCMU)	+=3D db5500-prcmu.o
  obj-$(CONFIG_MFD_TIMBERDALE)    +=3D timberdale.o
  obj-$(CONFIG_PMIC_ADP5520)	+=3D adp5520.o
  obj-$(CONFIG_LPC_SCH)		+=3D lpc_sch.o

--Signature=_Wed__23_May_2012_13_01_54_+1000_u8Ko1fhpL8ZnI.BN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPvFMiAAoJEECxmPOUX5FEnLAP/2p9IoEFrrg5PRPznxt1hNdY
oNliveKmrqGxQL7R+Os2j+nyKLwCJrEmirOlnb2DIRjVVvwvQzZBA/k1K8ZJlSxi
M53cx4N6ZnB5uQBLTn1kkdqyFK4/A+d0So9p/0xXmWMrxO9Jt81pyVbUa18byQh9
ULlWslY4wnnOPO539c0ux8VqRbLfhUfQOmcht3waadlvjcoBA9gWkZAF4zRP3hNy
jywlbnud/J9oqK36Aqgj0TstAOYjGRugm0A2z999q2555dV6CeAoVt5zfQiY2+Js
eqp43W7yUTeS6CwNcVZVT41MXd0Kt5mCWu3ba1wXJDvSHK3eVVQlnAZYznpoX3Ej
fsQ+rvm2crKN/f5j1S8m7NKMp7twlAHMRhS71UXkgiLiTyPilPbAbZ5mCeuQg+Sg
6fw8DQnLJr0ejJny3sGv9Z5r+p65ukhLz1DHcrVRpa2QVwPCjc8SdBqMuConxwQK
D7mfO19eQjZVsr3sKhrDFg6mtw3+yiSWYZVIIgyb9MUEYNyropJZ9QwYUjBRs049
aElNs3Hv+e19ZPj04XUBqC3FjsKkzTlPj3WHKCpeYiYtoq/ZFdfsVtxFi/7jmmpE
w+Kz2M0ex9Z2SJ1lYE8moLZ9yJuGdn8rDkb90lfbDVE5B/WLI9WyQ9XIY9J7+HAQ
ZHoOdeSIilV62cYP2SBp
=Rsqs
-----END PGP SIGNATURE-----

--Signature=_Wed__23_May_2012_13_01_54_+1000_u8Ko1fhpL8ZnI.BN--
