Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1LSNJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:09:59 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:57598 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346Ab1LSNJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:09:55 -0500
Date: Mon, 19 Dec 2011 15:09:47 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "Greg Kroah-Hartman (supporter:USB SUBSYSTEM ,commit_signer:28/50=56%)" 
	<gregkh@suse.de>,
        "Thomas Dahlmann (supporter:AMD GEODE CS5536...)" 
	<dahlmann.thomas@arcor.de>,
        "Kuninori Morimoto (commit_signer:43/50=86%)" 
	<kuninori.morimoto.gx@renesas.com>,
        "open list:DESIGNWARE USB3 D..." <linux-omap@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:AMD GEODE CS5536..." <linux-geode@lists.infradead.org>
Subject: Re: [PATCH 9/9] usb: gadget: goku: use generic map/unmap routines
Message-ID: <20111219130946.GB3146@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1324290632-23758-1-git-send-email-balbi@ti.com>
 <1324290632-23758-10-git-send-email-balbi@ti.com>
 <4EEF35FB.9090707@mvista.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="whpHMr7UwS4k4x4q"
Content-Disposition: inline
In-Reply-To: <4EEF35FB.9090707@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--whpHMr7UwS4k4x4q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 19, 2011 at 05:02:51PM +0400, Sergei Shtylyov wrote:
> Hello.
>=20
> On 19-12-2011 14:30, Felipe Balbi wrote:
>=20
> >those routines have everything we need to map/unmap
> >USB requests and it's better to use them.
>=20
> >Signed-off-by: Felipe Balbi<balbi@ti.com>
> >---
> >  drivers/usb/gadget/goku_udc.c |   17 +++++++----------
> >  1 files changed, 7 insertions(+), 10 deletions(-)
>=20
> >diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc=
=2Ec
> >index 5af70fcc..bc47735 100644
> >--- a/drivers/usb/gadget/goku_udc.c
> >+++ b/drivers/usb/gadget/goku_udc.c
> [...]
> >@@ -736,10 +732,11 @@ goku_queue(struct usb_ep *_ep, struct usb_request =
*_req, gfp_t gfp_flags)
> >  		return -EBUSY;
> >
> >  	/* set up dma mapping in case the caller didn't */
> >-	if (ep->dma&&  _req->dma =3D=3D DMA_ADDR_INVALID) {
> >-		_req->dma =3D pci_map_single(dev->pdev, _req->buf, _req->length,
> >-			ep->is_in ? PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
> >-		req->mapped =3D 1;
> >+	if (ep->dma) {
> >+		status =3D usb_gadget_map_request(&dev->gadget, &req->req,
>=20
>    Not '&_req->req'?

of course not. _req is the usb_request not Goku's internal
representation. I could change that to:

	usb_gadget_map_request(&dev->gadget, _req, ep->is_in);

though.

--=20
balbi

--whpHMr7UwS4k4x4q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO7zeaAAoJEIaOsuA1yqRE3pQP/19zJDC7XnlvfNBfBD5iSoLx
quZNvFRfgUHFFuNuYazLjYsbevr0mmiiEvdFtGZPSEiMl9/aK4NhA0+d0FSUlb2x
yYfeyNP6hxSOf+ia0IIqbn3lkkufdRKS065rUID5SLFw/iec0O3StPOlq20g2G+y
wPbGR9yOnwo+XzvP8zVgHWeeN7/FwicerQeMhAfQ09o5AliFwJN/jByLPIGH9E2h
k3dzm2BZZxsVa0hH7EWXT6gINKa0AodfZFnVMjCifbhOrMkBEqIq+s5pZVZZz4NU
JkmqivP5h57iPbDc6VDi2plubTxj5tksUKhHR5gTQ2dZ+1UTcskBDsRWfYbndqp8
VPSqfR8269B/sUVj6f2lSdJr3pa1jqXcZcMkyDGoIHw7DBntXoFd5BiLVlth/wSD
S+7xx8ZD30rbMjb9VRvAjHcgWlzZFbtRygwV8PNIWLPR7aAUYVjiE04jzFh/OCL9
S4AJYHHMBKbrQcCFm00z0qtv2A3xAYgimsU+ezbSs662wp7yls+nK8BFQR566Vnn
Nodz4JACcYdVu1Wh2Q8EHtT2IzCjxnmCh9WJIL48FJBIbpcizoA2O7uEC/EId3ln
Y6Qn6RyR9z2CvcY08PO12WxMPhnLDwQmlf3MeDotIczhrPd3Lmnzm82b2kl6hyT/
5d0N41nG3VTolvtgDSvm
=PhZB
-----END PGP SIGNATURE-----

--whpHMr7UwS4k4x4q--
