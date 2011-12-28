Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab1L1Gp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 01:45:28 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:58651 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1L1Gp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 01:45:27 -0500
Date: Wed, 28 Dec 2011 17:45:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20111228174518.721624fad9d048f9f85b3d50@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_17_45_18_+1100_TE5+DzC9OC14iyt1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_17_45_18_+1100_TE5+DzC9OC14iyt1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/platforms/cell/spu_base.c: In function 'spu_add_dev_attr':
arch/powerpc/platforms/cell/spu_base.c:533:21: error: ignoring return value=
 of 'device_create_file', declared with attribute warn_unused_result [-Werr=
or=3Dunused-result]
cc1: all warnings being treated as errors
arch/powerpc/kernel/sysfs.c: In function 'topology_init':
arch/powerpc/kernel/sysfs.c:658:22: error: ignoring return value of 'device=
_create_file', declared with attribute warn_unused_result [-Werror=3Dunused=
-result]
arch/powerpc/kernel/sysfs.c: In function 'register_cpu_online':
arch/powerpc/kernel/sysfs.c:346:21: error: ignoring return value of 'device=
_create_file', declared with attribute warn_unused_result [-Werror=3Dunused=
-result]
arch/powerpc/kernel/sysfs.c:380:21: error: ignoring return value of 'device=
_create_file', declared with attribute warn_unused_result [-Werror=3Dunused=
-result]
arch/powerpc/kernel/sysfs.c:384:22: error: ignoring return value of 'device=
_create_file', declared with attribute warn_unused_result [-Werror=3Dunused=
-result]
arch/powerpc/kernel/sysfs.c:388:21: error: ignoring return value of 'device=
_create_file', declared with attribute warn_unused_result [-Werror=3Dunused=
-result]
arch/powerpc/kernel/sysfs.c:391:21: error: ignoring return value of 'device=
_create_file', declared with attribute warn_unused_result [-Werror=3Dunused=
-result]
arch/powerpc/kernel/sysfs.c:394:21: error: ignoring return value of 'device=
_create_file', declared with attribute warn_unused_result [-Werror=3Dunused=
-result]
arch/powerpc/kernel/sysfs.c:397:21: error: ignoring return value of 'device=
_create_file', declared with attribute warn_unused_result [-Werror=3Dunused=
-result]
arch/powerpc/kernel/sysfs.c:400:21: error: ignoring return value of 'device=
_create_file', declared with attribute warn_unused_result [-Werror=3Dunused=
-result]
arch/powerpc/kernel/sysfs.c: In function 'cpu_add_dev_attr':
arch/powerpc/kernel/sysfs.c:532:21: error: ignoring return value of 'device=
_create_file', declared with attribute warn_unused_result [-Werror=3Dunused=
-result]
cc1: all warnings being treated as errors

Caused by commit 8a25a2fd126c ("cpu: convert 'cpu' and 'machinecheck'
sysdev_class to a regular subsystem").   Powerpc builds parts of
arch/powerpc with -Werror.

drivers/base/cpu.c: In function 'cpu_is_hotpluggable':
drivers/base/cpu.c:272:9: error: implicit declaration of function 'get_cpu_=
sysdev' [-Werror=3Dimplicit-function-declaration]
drivers/base/cpu.c:272:27: warning: initialization makes pointer from integ=
er without a cast [enabled by default]
drivers/base/cpu.c:273:16: error: 'struct cpu' has no member named 'sysdev'
drivers/base/cpu.c:273:16: warning: initialization from incompatible pointe=
r type [enabled by default]
drivers/base/cpu.c:273:16: error: 'struct cpu' has no member named 'sysdev'
drivers/base/cpu.c:274:1: warning: control reaches end of non-void function=
 [-Wreturn-type]

Caused by the above commit interacting with commit 2987557f52b9
("driver-core/cpu: Expose hotpluggability to the rest of the kernel")
from the tip tree.  This is will fix up in the merge commit next time.

drivers/base/cpu.c: In function 'register_cpu_control':
drivers/base/cpu.c:66:20: warning: ignoring return value of 'device_create_=
file', declared with attribute warn_unused_result [-Wunused-result]
cc1: some warnings being treated as errors

Caused by the above commit.

Because of the powerpc problems above, I have used the driver-core tree
from next-20111222 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Dec_2011_17_45_18_+1100_TE5+DzC9OC14iyt1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+rr+AAoJEECxmPOUX5FEx7kP+QEMo7A5/qxc9rjoYmF7s8Zv
tEssB1hAQA2VhaEbJ/E1GsuXTiUf39Fj9G7VAaaPawE328LMBIwGlC+bFokIUHhk
DYsEQTR2TRp7kJKDLGOWRBhtjx8lo7Wa0CCvU2ilrOmLrUagP2LGWaRZFpn4eQtK
6vtwmO2ponm+vcqz2QGzHEfvCVi3XLBVOyq8TdY7fmIk2+zoun9y3g8LCXrQ1Xtd
hnbzMKYFPJwVW5sH8g+gQWHC0Sc6jjeCDOKbl1BS7cuYFNCcfs9KEiNHyCsbsv1X
2x36TSHhzuYldocmEgiKsi5sCDjeinrDhF4lTDvnzy8qvTTP1auHbQ6JxIGiljQb
lFcQYhAfCqeIzCgIHXYeAQvmBLMvngQm3fXX8opU+zL9RySUqmNaNGFXt1lsA2Xr
t1wCBqqu75uKIy1Q3j4DVojphN/Ed007H2Fp1gl/M530F8zbukOI7NAE/502B9wD
IZwpffLbJ7Km3Tixal6V387ugtZRAgbaXnGrvWl6S6o/QJxtCSOdUeFEIWA2O3iC
/bJwYC3uYTCsr9tzKv8gX77FvulTONUyOAz4U0qnubi9pq2EEiQulsiOlvI8OG5R
RpXqyUw8qaCBHl4CoCs3MS8qI/k2O3jzPJ5JDXZqbJEe8PtSF5u58Et7YIo8neFm
zCdxWepNy3gsxPRN8LP+
=cBmb
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_17_45_18_+1100_TE5+DzC9OC14iyt1--
