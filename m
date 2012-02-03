Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2BCDvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 22:51:23 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48319 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2BCDvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 22:51:21 -0500
Date: Fri, 3 Feb 2012 14:51:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>
Subject: linux-next: manual merge of the driver-core tree with the
 driver-core.current tree
Message-Id: <20120203145106.3c166564b7081d94ee2e79cd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__3_Feb_2012_14_51_06_+1100_NOyIQeYRA3vcOgBR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Feb_2012_14_51_06_+1100_NOyIQeYRA3vcOgBR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/base/cpu.c between commit 2885e25c422f ("driver core: cpu: remove
kernel warning when removing a cpu") from the driver-core.current tree
and commit fad12ac8c8c2 ("CPU: Introduce ARCH_HAS_CPU_AUTOPROBE and X86
parts") from the driver-core tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/base/cpu.c
index 23f2c4c,2a0c670..0000000
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@@ -242,7 -224,9 +243,10 @@@ int __cpuinit register_cpu(struct cpu *
  	cpu->node_id =3D cpu_to_node(num);
  	cpu->dev.id =3D num;
  	cpu->dev.bus =3D &cpu_subsys;
 +	cpu->dev.release =3D cpu_device_release;
+ #ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
+ 	cpu->dev.bus->uevent =3D arch_cpu_uevent;
+ #endif
  	error =3D device_register(&cpu->dev);
  	if (!error && cpu->hotpluggable)
  		register_cpu_control(cpu);

--Signature=_Fri__3_Feb_2012_14_51_06_+1100_NOyIQeYRA3vcOgBR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPK1mqAAoJEECxmPOUX5FEYPkQAJ3vjRq8AFMlFVNOD1t4l4LE
/+wjiiQvlhAoeHaoBZkBsGN6lHVfPrGPHjJh/J/a0aXHif4/bVHT7I8ikOnN9snF
WlnjvJ9q4UtChgQZ/LSOpH1GISinQuVUchNNAN/rqRsrlwyECIkFqqmBfJHTkUvK
qz/siO6SHMu5swtLkaOaH4HTttubOKXhKeyzc6mMbZZ8XSprWFsI6ySNXa19kJMS
hxY574rMr8uSMrBqdTA9uiltO2Cz5I078Kru3CZsxqJscyVDJKMIhK53vUTDN6mV
ayBAR+HvcZKu2eg5L6Bct+u7VYvR4SiG8bSrPPwEy/O4mRaNt+HXoKzNTooNXix4
AoriprMtQLslEtA7xgIMpArymlZ6uyJmoPBlRKTtNKqACBbAYrIhQ9PiNWi8CCaZ
sPAdYVZu356wYkZGqR5c2oOlIPH1V9407pwBNiKwRfaCIbNvhzlht7ojYA2JI3oR
vGetr51PU02uXd/c+3/3J7x1HBm6iCw7gtWys4BwbM6/yBIFbdhZRFWrR61I963g
FZ4m8LXuAskg0FqXAFwtVU0l8+VOWegovz6RV6NHAGq1yfTwCiMdZ/YJmK5MUPIL
9rvAuR5Fm728HxCGGzbNe6RkWdpCMbYNv9S7bcovlneRi8uGIP2dqmazJ8Ueh9cu
THtmW1M/9utus5ugHsWw
=qran
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Feb_2012_14_51_06_+1100_NOyIQeYRA3vcOgBR--
