Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab3AJA2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 19:28:51 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:54959 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab3AJA2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 19:28:49 -0500
Date: Thu, 10 Jan 2013 11:28:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: linux-next: manual merge of the pm tree with the pci tree
Message-Id: <20130110112836.19126ca740c8e13a15860dc0@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_Jan_2013_11_28_36_+1100_eG9nmk3UcrCFyoRF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Jan_2013_11_28_36_+1100_eG9nmk3UcrCFyoRF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
drivers/acpi/pci_root.c between commit 3c449ed00759 ("PCI/ACPI: Reserve
firmware-allocated resources for hot-added root buses") from the pci tree
and commit 47525cda88f5 ("ACPI / PCI: Fold acpi_pci_root_start() into
acpi_pci_root_add()") from the pm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/acpi/pci_root.c
index dcbe966,22a8458..0000000
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@@ -632,28 -600,8 +600,10 @@@ static int acpi_pci_root_add(struct acp
  	if (device->wakeup.flags.run_wake)
  		device_set_run_wake(root->bus->bridge, true);
 =20
- 	return 0;
-=20
- out_del_root:
- 	mutex_lock(&acpi_pci_root_lock);
- 	list_del(&root->node);
- 	mutex_unlock(&acpi_pci_root_lock);
-=20
- 	acpi_pci_irq_del_prt(root->segment, root->secondary.start);
- end:
- 	kfree(root);
- 	return result;
- }
-=20
- static int acpi_pci_root_start(struct acpi_device *device)
- {
- 	struct acpi_pci_root *root =3D acpi_driver_data(device);
- 	struct acpi_pci_driver *driver;
-=20
 -	if (system_state !=3D SYSTEM_BOOTING)
 +	if (system_state !=3D SYSTEM_BOOTING) {
 +		pcibios_resource_survey_bus(root->bus);
  		pci_assign_unassigned_bus_resources(root->bus);
 +	}
 =20
  	mutex_lock(&acpi_pci_root_lock);
  	list_for_each_entry(driver, &acpi_pci_drivers, node)

--Signature=_Thu__10_Jan_2013_11_28_36_+1100_eG9nmk3UcrCFyoRF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ7gs0AAoJEECxmPOUX5FEG6QP/iDcR3i+vSTls+EhJ1BdG51T
vYycGcJHu/t86pvkVbucg1S4ZumsUGmJdfwJXNHN86psb/CoH/SmQ6Ji7+n0QF8O
PFD5ohmRqJlHn1roHSYFn/R5n9kFZH7YCj+ThnX0wAVpllsvBLUtTV23lJPq+E0C
wiKlmvDMzrsvQPEnJxVpr0dbQr+y9GXk8w+j4K3K6BOlyPr614/3qrmtkEWc7O5j
SKF3nJ5OpGpVCIzjzur0NZ9++A9EsXIvBw5VGtWuIWwtpYFpfmLHiGSB1iu2LcLZ
4xAwzjCpODyhLya6klEop63OID9mDqWNdB2SWh6eFvT3YLrJse/XdTj59sILY1L8
5myF85+Fqd+Gq6YICBv5Gmb0Nv6WOv52d4Eiu8QhkYy2NC4O6iufmROyW+coHvT/
K42FB34gVAXm+W0LnaxbV1EkoagpBp0XhgxPD6V8ierDNlLDLA90AGfR5ZlRV7F4
PZzZ/vqWxZEBlwH8Arq/glZD6j74BK0OkYNXCK+ks3XSdDZ3G651gDcU/Zi4X8d+
2lMNElN7bbYYQVMlktTdF1WepQF/YRcWJpKn+ZMQsGksklEa1roO7dBiwqxphsS1
AZSeQ+GMnFlNwzrrkXrZjykh/xwHsqR1VGNG7sKKqRcVse2IqtkakfbBFFMWfwQt
LJBI/OoLepWMtn4Jp/7y
=A8C5
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Jan_2013_11_28_36_+1100_eG9nmk3UcrCFyoRF--
