Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602Ab1JGIjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 04:39:06 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:56581 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759515Ab1JGIjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 04:39:04 -0400
Date: Fri, 7 Oct 2011 11:38:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
Cc: balbi@ti.com, gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
Message-ID: <20111007083856.GB10910@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
 <20111006120830.GN1714@legolas.emea.dhcp.ti.com>
 <4E8EB6EE.8040700@sensortherm.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
In-Reply-To: <4E8EB6EE.8040700@sensortherm.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 07, 2011 at 10:23:10AM +0200, Klaus Schwarzkopf wrote:
> Hi,
>=20
> thanks for your comments. See my patch v2.
>=20
> Am 06.10.2011 14:08, schrieb Felipe Balbi:
>=20
> >
> >>+#define CDC_VENDOR_NUM	0x1d6b	/* Linux Foundation */
> >>+#define CDC_PRODUCT_NUM	0x0106	/* CDC Composite: ACM + MS*/
> >
> >did you ask Greg for this ?
> >
>=20
> Greg wrote:
>=20
> I'll do that when I accept the patch for merging into the kernel, and
> not before.

ok.

> >>+/*--------------------------------------------------------------------=
-----*/
> >>+
> >>+/*
> >>+ * Kbuild is not very cooperative with respect to linking separately
> >>+ * compiled library objects into one module.  So for now we won't use
> >>+ * separate compilation ... ensuring init/exit sections work to shrink
> >>+ * the runtime footprint, and giving us at least some parts of what
> >>+ * a "gcc --combine ... part1.c part2.c part3.c ... " build would.
> >>+ */
> >>+
> >>+#include "composite.c"
> >>+#include "usbstring.c"
> >>+#include "config.c"
> >>+#include "epautoconf.c"
> >>+#include "u_serial.c"
> >>+#include "f_acm.c"
> >>+#include "f_mass_storage.c"
> >>+
> >>+/*--------------------------------------------------------------------=
-----*/
> >>+
> >>+static struct usb_device_descriptor device_desc =3D {
> >>+	.bLength =3D		sizeof device_desc,
> >>+	.bDescriptorType =3D	USB_DT_DEVICE,
> >>+
> >>+	.bcdUSB =3D		cpu_to_le16(0x0200),
> >>+
> >>+	.bDeviceClass =3D		USB_CLASS_COMM,
> >>+	.bDeviceSubClass =3D	0,
> >>+	.bDeviceProtocol =3D	0,
> >>+	/* .bMaxPacketSize0 =3D f(hardware) */
> >>+
> >>+	/* Vendor and product id can be overridden by module parameters.  */
> >>+	.idVendor =3D		cpu_to_le16(CDC_VENDOR_NUM),
> >>+	.idProduct =3D		cpu_to_le16(CDC_PRODUCT_NUM),
> >>+	/* .bcdDevice =3D f(hardware) */
> >>+	/* .iManufacturer =3D DYNAMIC */
> >>+	/* .iProduct =3D DYNAMIC */
> >>+	/* NO SERIAL NUMBER */
> >
> >why not ? If someone wants to make a product out of this, they will need
> >a serial number.
> >
>=20
> If an developer want a serial number, he can change this.

ok.

> >>diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> >>index dd1571d..f623f3d 100644
> >>--- a/include/linux/usb/gadget.h
> >>+++ b/include/linux/usb/gadget.h
> >>@@ -15,6 +15,7 @@
> >>  #ifndef __LINUX_USB_GADGET_H
> >>  #define __LINUX_USB_GADGET_H
> >>
> >>+#include<linux/device.h>
> >
> >this is not part of $SUBJECT
> >
>=20
> changed git message

not enough. adding another header is not part of this patch. You need to
let us know why you need this new header there and you need add proper
spacing there.

--=20
balbi

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOjrqgAAoJEAv8Txj19kN1FeoH/25YbaHPh9AAaGR1dy5RMz6p
Z0fqAYr0nOWIJ436WQ1og8d4rw03SAVSPKx0koJlsspDPdyhC8DvGvxJWYMtj4qf
tmC//Lr4DorAnOT+GMJpAbrGqcaMf8Qf9ZVK+Ya3Gxl57ffV3foDQYIBVD56HOMl
m648lBr/3CfkqtTEhODJr4nWPws83MMgFl8j34AqJyQYkMSahDxnDKvJSJj07h8H
Go9JnashugAuVTwmqla9ZgCsKUQ0YFCjB7cvheVzhiKosaZpS0V/QDiGQkXQFO3s
etj9xhJwcRVr46jQRP1g/rWsDj08hm3McoRO5vaL9gm4Ldmn46usu+ZpihRtwqk=
=4zUn
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
