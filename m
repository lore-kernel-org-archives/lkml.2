Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab0HYB4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 21:56:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53574 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756306Ab0HYB4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 21:56:12 -0400
Date: Wed, 25 Aug 2010 11:56:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: build failure after merge of the final tree
 (pci-current tree related)
Message-Id: <20100825115604.07928f97.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__25_Aug_2010_11_56_04_+1000_ePwKUw6WiF15vl.p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Aug_2010_11_56_04_+1000_ePwKUw6WiF15vl.p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/pci/hotplug/pciehp_core.c: In function 'pciehp_probe':
drivers/pci/hotplug/pciehp_core.c:238: error: implicit declaration of funct=
ion 'pciehp_acpi_slot_detection_check'

Caused by commit 28eb5f274a305bf3a13b2c80c4804d4515d05c64 ("PCI: PCIe:
Ask BIOS for control of all native services at once").  This function is
only declared if CONFIG_ACPI is defined.

I have reverted that commit for today (and the two that interact with it:
2bd50dd800b52245294cfceb56be62020cdc7515 "PCI: PCIe: Disable PCIe port
services during port initialization" and
271fb719cc472af3b1e96d8c527bb0da7060a172 "PCI: PCIe: Move PCIe PME code
to the pcie directory").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__25_Aug_2010_11_56_04_+1000_ePwKUw6WiF15vl.p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMdHg0AAoJEDMEi1NhKgbsbxQIAIU83Xz8uMx1LmyDvXu55aSQ
NC/EjjVSg855VqbBhV6suZBwv2UBD7TulcKZQDBF5Qvt1Dlju3xiDF6ZAns2p0oX
kJ2dggG4Yl/IvANVg50z0emra8KpDqtimbrl1B9lBAm51HF6C11hrtQhLNureg7i
jjboalrMrpyLfU3BWwKrFeFVEroITni8dxJkuv8+isc8czHJDjn8C6dVN6J7RFap
v4aZQrWSvGl1TE6KnjjYOT55Y6I/CbLXWo1PTsIe/pt6jvkeaS0T0P5Edx4d2ICN
uFM0XxHGjUyBAYmN8lhfVEoZXOH9FdbMoPZlgSbgSibwqxALiKB5rpzspkq5JfM=
=f13I
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Aug_2010_11_56_04_+1000_ePwKUw6WiF15vl.p--
