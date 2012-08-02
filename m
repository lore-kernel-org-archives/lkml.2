Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab2HBBUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 21:20:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49680 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab2HBBUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 21:20:45 -0400
Date: Thu, 2 Aug 2012 11:20:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>, Joerg Roedel <joro@8bytes.org>
Subject: linux-next: build failure after merge of the acpi tree
Message-Id: <20120802112033.c1531ffe7bf7147c461cac0a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__2_Aug_2012_11_20_33_+1000_/PYu7p1ObOGRJx=U"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Aug_2012_11_20_33_+1000_/PYu7p1ObOGRJx=U
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

After merging the acpi tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/iommu/amd_iommu_init.c: In function 'early_amd_iommu_init':
drivers/iommu/amd_iommu_init.c:1535:2: error: implicit declaration of funct=
ion 'acpi_get_table_with_size' [-Werror=3Dimplicit-function-declaration]

Caused by commit 705d9245d714 ("ACPI: remove acpi_get_table_with_size()
fucntion").

This extra call to acpi_get_table_with_size() was added by commit
02f3b3f5449c ("iommu/amd: Use acpi_get_table instead of
acpi_table_parse") added to Linus' tree on about July 25 via the iommu
tree.

I have reverted the acpi tree commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__2_Aug_2012_11_20_33_+1000_/PYu7p1ObOGRJx=U
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQGdXhAAoJEECxmPOUX5FEhaYP/jKGfrhHlUi6UTwf3fR1sT+1
zczwDyfhU0niyRMcL9N1uGJQt/Vtxt4Qqos1b1LRdHs5JlwlPGc5bNGL0opjOSom
Pccfzsxfelx9tFQq+u1hv0j/h1LxKmYNT1kw37XbPICpm2OHun7vTPMBy4gY/4Lv
cIRISDTgT1Ip6oXLly/aaXETdkVtfMs0SEkcVPt6ijegT68vtmJfBQQ1N7fvnuG8
StZfIJStyBVjoAkunBvQ4ypTQN3ZSc8dKnISxPrLS0eLhYn2kasNZyP4RUue28dU
VbPWa1NB2ieamGje5EqNMousVNlydO3w6AZzbgEszmmcUoEci1NEt5TmJx9YOUYz
QVeG25+3E5dOGxmoyrmBXEjXDNNBLMZ/GqAeORda3NXnVg1jzgyj6i/eMsOdWDqQ
AVDlzyDe8MU3fgxk4xz7lnjVFyGX0aqnE8SAhafzPb+3XdCmxO1GBZpAn9r1DIbd
75wskBMJoPb0reMwbIjBnBiVsMlhyTP6aEanzzrapIgQajSV6R+PeR8ocPTYDdw9
uxr/nFGK89eZNlx/Y4US/431pC7w0ENAF116pcVedPc09XNWO1P2z1J4FthSo8g4
0UZnriO03RjIyR5TgTbtRiHofdHb5NhL+9/MbyN5d/5kcCh4h4SF4F1Vqa0Vriug
JKtmcVLbbtEZ4zc7nV1l
=4kZs
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Aug_2012_11_20_33_+1000_/PYu7p1ObOGRJx=U--
