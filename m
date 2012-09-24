Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab2IXGyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 02:54:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37647 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab2IXGyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 02:54:52 -0400
Date: Mon, 24 Sep 2012 16:54:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>, Len Brown <lenb@kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: linux-next: manual merge of the usb tree with the acpi tree
Message-Id: <20120924165449.58e81fb0c925ecc580ec502e@canb.auug.org.au>
In-Reply-To: <20120924164916.faeb0225ef2b0732762d8aac@canb.auug.org.au>
References: <20120924164916.faeb0225ef2b0732762d8aac@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_16_54_49_+1000_rUBiz6LY9pRHe0gl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_16_54_49_+1000_rUBiz6LY9pRHe0gl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 24 Sep 2012 16:49:16 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/core/usb-acpi.c between commit 59e6423ba8aa ("usb-acpi:
> Comply with the ACPI API change") from the acpi tree and commit
> 05f916894a69 ("usb/acpi: Store info on device removability") from the usb
> tree.
>=20
> The latter removed the function changed by the former, so I just did that
> and can carry the fix as necessary (no action is required).

It also needed this merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 24 Sep 2012 16:51:38 +1000
Subject: [PATCH] usb-acpi: Comply with the ACPI API change after usb tree
 merge

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/usb/core/usb-acpi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/usb-acpi.c b/drivers/usb/core/usb-acpi.c
index 0ef7d42..e9b159a 100644
--- a/drivers/usb/core/usb-acpi.c
+++ b/drivers/usb/core/usb-acpi.c
@@ -87,7 +87,7 @@ static int usb_acpi_check_port_connect_type(struct usb_de=
vice *hdev,
 	acpi_status status;
 	struct acpi_buffer buffer =3D { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *upc;
-	struct acpi_pld pld;
+	struct acpi_pld_info *pld;
 	int ret =3D 0;
=20
 	/*
@@ -111,13 +111,13 @@ static int usb_acpi_check_port_connect_type(struct us=
b_device *hdev,
 	}
=20
 	if (upc->package.elements[0].integer.value)
-		if (pld.user_visible)
+		if (pld->user_visible)
 			usb_set_hub_port_connect_type(hdev, port1,
 				USB_PORT_CONNECT_TYPE_HOT_PLUG);
 		else
 			usb_set_hub_port_connect_type(hdev, port1,
 				USB_PORT_CONNECT_TYPE_HARD_WIRED);
-	else if (!pld.user_visible)
+	else if (!pld->user_visible)
 		usb_set_hub_port_connect_type(hdev, port1, USB_PORT_NOT_USED);
=20
 out:
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Sep_2012_16_54_49_+1000_rUBiz6LY9pRHe0gl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYAO5AAoJEECxmPOUX5FE7+YP/Ri3PWIdzAlpgLVT3nDQpldo
brWvn/5xp8/i+hYA+YYGpBnAmlTs9edgfAgE+rZoN035iIFqKJszmUYa//Ht7TdU
1limgtvqJWfocD4M/OdRg5WVr6ikRYqmti2BYGzL+CUn7sb+tFqoEwxc3YVBoPhM
dnp/0II+87ALPeeCiqvW+F9qLTot15m2LmmGsCs+gFx8nz6QaD4uKciMZ7+koVYf
kqTbtPd3uKD6EGrxVCHJknH9Oa//09Yl+ZY8zR4kyWpWM57ofx1D5BYpPXCiB1u8
dtCq7cuARY8sOeANS/stLDSgrGpmYwZ3ProxskIbdK2JS75Q2UcSfn3/DCK8sokx
7ZN2Yxt+dvVT2h2ByHg8WyNNFQlDOpzQ3CV/meb5zzRCvKerYrprNT1w+E8NlUgs
Wc/52lVOPM5dHB4gBEXTN2W+3svqRI8Z207tprLheSQWGeTsnYdocQaAIM10/CgJ
vxAsXCUZQRW4JJBT8u3mgbSeGbJhgf1ABljF0y2LWP0cFyuwC6F9vI43oUkM9MgK
kpNOmTnJOzF2mOudsZrZNvTtdDZ/pT+0aEaaETwRKWJXu2vrj9fnhch6W/2Vi3Nl
uujLxveodWEpyDzGPE8fZ0e8uyH/GuLgxpyg68FOMpYjIEpIGDQio1ZPI1E3i4RS
74+MibItEbsChv+lqPdR
=qtOo
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_16_54_49_+1000_rUBiz6LY9pRHe0gl--
