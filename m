Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab2B1KvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:51:22 -0500
Received: from 8bytes.org ([88.198.83.132]:36150 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757021Ab2B1KvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:51:21 -0500
Date: Tue, 28 Feb 2012 11:51:18 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU fixes for v3.3-rc5
Message-ID: <20120228105117.GA2376@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 6b21d18ed50c7d145220b0724ea7f2613abf0f95:

  Linux 3.3-rc5 (2012-02-25 12:18:16 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git iommu/fixes

or as a signed tag at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git iommu-fixes-=
v3.3-rc5

Ohad Ben-Cohen (3):
      iommu/omap: fix erroneous omap-iommu-debug API calls
      iommu/omap: fix NULL pointer dereference
      ARM: OMAP: make iommu subsys_initcall to fix builtin omap3isp

 arch/arm/mach-omap2/mailbox.c    |    3 +-
 drivers/iommu/omap-iommu-debug.c |   59 +++++++++++++++++++++++++++++-----=
----
 drivers/iommu/omap-iommu.c       |    3 +-
 3 files changed, 49 insertions(+), 16 deletions(-)
 =20
All the fixes are for the OMAP IOMMU driver. The first patch is the
biggest one. It fixes the calls of the function omap_find_iovm_area() in
the omap-iommu-debug module which expects a 'struct device' parameter
since commit fabdbca instead of an omap_iommu handle. The
omap-iommu-debug code still passed the handle to the function which
caused a crash.
The second patch fixes a NULL pointer dereference in the OMAP code and
the third patch makes sure that the omap-iommu is initialized before the
omap-isp driver, which relies on the iommu. The last patch is only a
workaround until defered probing is implemented.

The top-commit id on my local machine is

	435792d93410f008120c4dbab148019a3cc31dbc

Please pull.

Thanks,

	Joerg


--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTLGlAAoJECvwRC2XARrjuekQAJCpm7rbkzxHZVO6vlzWe4Mq
GK/qV6tOnOW2YAdh0eQ5nO2u0ryLZDtnQJOCi2kXGCTULUy+WhOP5wauJSHP6n6o
+LBLx1RWL+NWX0bngARtYMh5n9NKdMvsBYXAj7L7xYQTY3glZxfIGdkT22mtCdG5
D17qURfUhLFosdO4UADuIC/OlQlL2RP1vlqSFv9DpoUhF/Kt+uZIbavWkDBRZQAa
OJOf97hsNnZC/0fvJvT5V9G0+V1a6q7LZMUF/3eOM+UyGEjpjQzAHoDynmjyY9jQ
RieQ1lLORjd89T/4psGpm9gZPPEFb+sfUBgIAvhRtk/YW8PQJDLojpt+w2z/kwAJ
cewMbjPjFyLfnGKPV2C78yOPMw98wMLVTlQR/CKlhGzmouArU3sAK47nvxgSkYRq
iAi2iT/qbXrtdYz0nBJENeVab8CCAF4YgPJvHe5lvdYwPJLH7n/+Yg0YrRiPI3zT
C2oF2Fe+yFL1H+EA3kIqWFSLpHGnxcbsqNSZjIMDCYw3T3ApbpbSqPUxHL9HnU+i
nZhKR+obfMl+bQhrrt+ELQba14UcAccXUdlv2s3RvfTFsOoy41sN94dOs3hz4vjH
X3p8AVS7EVId5PWw2GOT276HlxGPcVWWFbY5ckt4StGnVajGChfE2SOhZcOiOO8k
9WtCL4gklInZF/LZnx/B
=K+go
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
