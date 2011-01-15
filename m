Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab1AOCeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 21:34:22 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51234 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab1AOCeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 21:34:20 -0500
Date: Sat, 15 Jan 2011 13:34:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ozan Caglayan <ozan@pardus.org.tr>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: build failure after merge of the final tree (linus'
 tree related)
Message-Id: <20110115133412.58b8cd89.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__15_Jan_2011_13_34_12_+1100_j_Xe.DuqjJpRxB5u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__15_Jan_2011_13_34_12_+1100_j_Xe.DuqjJpRxB5u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from drivers/pci/pcie/aer/aerdrv.c:20:
include/linux/pci-acpi.h:39: error: expected '=3D', ',', ';', 'asm' or '__a=
ttribute__' before 'acpi_find_root_bridge_handle'

Caused by commit 415e12b2379239973feab91850b0dce985c6058a ("PCI/ACPI:
Request _OSC control once for each root bridge (v3)").  (Yet another
patch not seen in linux-next until merged into Linus' tree.  In this case
the breakage was not seen because the new part of the pci tree was
excluded from linux-next for several days because of another commit that
broke my builds.  That other commit was only excluded from the pci tree
just before being sent to Linus :-()

This is the non CONFIG_ACPI version of acpi_find_root_bridge_handle()
which returns an acpi_handle.  pci-acpi.h is now always included in
drivers/pci/pcie/aer/aerdrv.c.

I tried ifef'ing out the inclusion of pci-acpi.h, but that only made
matters worse.  I have just left it for today.  Please fix.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__15_Jan_2011_13_34_12_+1100_j_Xe.DuqjJpRxB5u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNMQekAAoJEDMEi1NhKgbs6agH/0fNyFKcLUmhidPGmpZWAoFN
MpCYXwE0FEZMkbLYUIqCj0I3bzE1pBz9g451M1NJzgDCy3gim1/qQU2tJm3DT0Kw
x2tmimDCN4AQizRSKJWpfkjBPMu6J0gO69/pzJdKJNIJU9VoT7oA0yTFZdcxXC+i
m2M8Vi7mRuyAzsmAlRljRvhDFW71/vMMnI89LVWCfe1RsNulZKLSONzXMpkYv9X3
7YgtykiwOVUPg+OTx64cTNdbWZCKO5sKbeVKvfnU2tO82mDILjk0KN02X4LVNt5B
G72BxmSXyouY+CbP25k1Xe6fPfLJcTYzvb9I/vkgRz3M005udJ6E3MhOObRGgqo=
=sUFc
-----END PGP SIGNATURE-----

--Signature=_Sat__15_Jan_2011_13_34_12_+1100_j_Xe.DuqjJpRxB5u--
