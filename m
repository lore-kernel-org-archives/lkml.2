Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032543Ab2CSS5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 14:57:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19095 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759253Ab2CSS5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 14:57:18 -0400
Date: Mon, 19 Mar 2012 14:53:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Subject: [GIT PULL] tboot: cleanups for 3.4
Message-ID: <20120319185302.GA7299@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A020208.4F67818C.0054,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Peter,

Please pull in your for-v3.4 branch this branch:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git  stable/for-x86-for-3.4

which has two patches for v3.4. They have been acked by Rafael Wysocki
and Joseph Cihula and posted: https://lkml.org/lkml/2012/3/10/115

The net gain of these patches is to remove the 'tboot' call within the ACPI core
framwork and replace it with an function call where the platform drivers can
register if they choose to. This makes it possible for platforms such as ARM, IA64
to choose whether they want to make a call to something similar to tboot or not.
If nothing is registered the call ends up being a nop.


 arch/x86/kernel/tboot.c       |    9 ++++++---
 drivers/acpi/acpica/hwsleep.c |   10 +++++++---
 drivers/acpi/osl.c            |   24 ++++++++++++++++++++++++
 include/acpi/acexcep.h        |    1 +
 include/linux/acpi.h          |   10 ++++++++++
 include/linux/tboot.h         |    1 -
 6 files changed, 48 insertions(+), 7 deletions(-)

Konrad Rzeszutek Wilk (1):
      tboot: Add return values for tboot_sleep

Tang Liang (1):
      x86, acpi, tboot: Have a ACPI os prepare sleep instead of calling tboot_sleep.


--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJPZ4CKAAoJEFjIrFwIi8fJi/cH/j7ZDLD/l1hzweAVldzluBGP
dydYOWWKFffGaCoN/STOn/A58QkV+qSKFn8wxC0A2hS52vg6FQilesyCVa9O1QsB
9Up+NslSQ/PnyoSf4kC35fV4Ma5eoew87NL6Q+NxBO1fmFZuGYoX7KejMzEnigNZ
pC/ucAPwWS7c2QyJJDtVDCiXsBICRkR4L6wpD0D3XYTWyGAG60E32wIHvKDkVdln
xfnxTJz8m3Y+7wtjTnp6x/EoqJO1CUAg+K3zL6SsmZ6CAvRNGo5hgat48ecoipLA
a/8biLNz0cq4cwTSEV1ztQIhleS5i7zgMZwN2JpjQVFx4stTwIF7xzKzdtJeA3U=
=mN++
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
