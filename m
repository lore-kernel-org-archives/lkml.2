Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2GBCKw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 22:10:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46261 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab2GBCKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 22:10:50 -0400
Date: Mon, 2 Jul 2012 12:10:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lin Ming <ming.m.lin@intel.com>, Huang Ying <ying.huang@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: linux-next: build failure after merge of the libata tree
Message-Id: <20120702121041.01a80802af13e2cf511fe0b6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Jul_2012_12_10_41_+1000_p91bdzOePg8.q6rT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Jul_2012_12_10_41_+1000_p91bdzOePg8.q6rT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

After merging the libata tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/ata/libata-acpi.c: In function 'ata_acpi_set_state':
drivers/ata/libata-acpi.c:872:5: error: too few arguments to function 'acpi=
_pm_device_sleep_state'
include/acpi/acpi_bus.h:418:5: note: declared here

Caused by commit 3bd46600a7a7 ("libata-acpi: add ata port runtime D3Cold
support") from the libata tree interacting with commit ee85f543710d
("ACPI/PM: specify lowest allowed state for device sleep state") from the
pci tree.

I added the following merge fix patch (and can carry it as necessary):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 2 Jul 2012 12:07:25 +1000
Subject: [PATCH] libata-acpi: fix up for acpi_pm_device_sleep_state API
 change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/ata/libata-acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 4112eaa..a2b16c9 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -869,7 +869,7 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message=
_t state)
=20
 		if (state.event !=3D PM_EVENT_ON) {
 			acpi_state =3D acpi_pm_device_sleep_state(
-				&dev->sdev->sdev_gendev, NULL);
+				&dev->sdev->sdev_gendev, NULL, ACPI_STATE_D3);
 			if (acpi_state > 0)
 				acpi_bus_set_power(handle, acpi_state);
 			/* TBD: need to check if it's runtime pm request */
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__2_Jul_2012_12_10_41_+1000_p91bdzOePg8.q6rT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP8QMhAAoJEECxmPOUX5FERLoQAJUQB77Ma2YJAW+hDDxsa9Tf
t8zR02pqQJwO8+4yLGV3hcScsXl+cMJrgp/tHCZVyTy90LhWmZGGXmMC5+GthM5l
Apu9ONa1XT8gSKjuqFIlqtydsttDAMoZqxG9mGXKrBwUpOA+NX1UcvepBagfeD1A
Czy87kUhzqlml9ZkPGGuYFmU+8IcV/sk8488OxVWfzaYAqhDV//AVHRbAhpmp0Rf
C83r2lqwGOc1i+R9Wz3Aj4+KxGV5uc+dKbUcK317pgiTaUM5A/QyfvHBRMxoe1Ku
kAxqw1T2FqPp+/Ojj8gTCMY4ztZwO6vhP2ZkV/xKygMOZdJWXP0gf3F6fjUSRAZG
yHYrB5JzMrU1VGn3fiy2a5X+Ja3+g4oCrzgp/DIZDIRoLI1YFVXBY4FVfk0FyvCO
SdlbX5fWfwmI0u36yZJiXf6+Nsz6a2Vdve56dYIjZysIMB4EYVtioui2Yw6aAhRu
xd6WutQxkji7iiBRENp8dm/sLOdel05nQB7/hnil8cdK0eqKzcVLAgjou3+u6LTz
MCASFRbgCU9MqO5VK6N3HJvMxWRMZXXNpYuMIFwhyGwspsu6vPdI90oxU/4sLUo/
or5ZcRYexZbds9d7X39ssRlOEZr+FJCFYWW4+uycVfIj+X7sCXYba6B9kl7L+snA
ILmfASJ8sr3cqQk//XZZ
=lB+5
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Jul_2012_12_10_41_+1000_p91bdzOePg8.q6rT--
