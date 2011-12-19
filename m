Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab1LSP5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:57:39 -0500
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:43647 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734Ab1LSP5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:57:37 -0500
Date: Mon, 19 Dec 2011 17:49:55 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "open list:DESIGNWARE USB3 D..." <linux-omap@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:AMD GEODE CS5536..." <linux-geode@lists.infradead.org>
Subject: Re: [PATCH 8/9] usb: gadget: net2280: use generic map/unmap routines
Message-ID: <20111219154954.GB30355@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1324290632-23758-9-git-send-email-balbi@ti.com>
 <Pine.LNX.4.44L0.1112191019580.1746-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1112191019580.1746-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 19, 2011 at 10:21:36AM -0500, Alan Stern wrote:
> On Mon, 19 Dec 2011, Felipe Balbi wrote:
>=20
> > those routines have everything we need to map/unmap
> > USB requests and it's better to use them.
> >=20
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  drivers/usb/gadget/net2280.c |   19 +++++++++----------
> >  1 files changed, 9 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
> > index cf1f364..59d4794 100644
> > --- a/drivers/usb/gadget/net2280.c
> > +++ b/drivers/usb/gadget/net2280.c
>=20
> > @@ -857,10 +853,13 @@ net2280_queue (struct usb_ep *_ep, struct usb_req=
uest *_req, gfp_t gfp_flags)
> >  		return -EOPNOTSUPP;
> > =20
> >  	/* set up dma mapping in case the caller didn't */
> > -	if (ep->dma && _req->dma =3D=3D DMA_ADDR_INVALID) {
> > -		_req->dma =3D pci_map_single (dev->pdev, _req->buf, _req->length,
> > -			ep->is_in ? PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
> > -		req->mapped =3D 1;
> > +	if (ep->dma) {
> > +		int ret;
> > +
> > +		ret =3D usb_gadget_map_request(&dev->gadget, &req->req,
> > +				ep->is_in);
>=20
> As mentioned for the goku patch, &req->req can be replaced by _req.

sure

--=20
balbi

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO710iAAoJEIaOsuA1yqREhTIQAKVrQKTB18pPIRWXHoyvXRez
N+u9uUsQOi1BYtZoonHTjfoMMkzmVKUVNk4JBK41cHoWtlfLEImBODACCALvTfVy
2QjHnvPclyE9cr9l/ktebzlfGascZ14ErseIYhlqquT5qCqlc+GOiYrsbrJi41KR
wJmAFcVt5g8oMGeakaNc4eM4Z5l83kxtExW9QQ0v4iPPAJS5cTkiHp7A7rYxv9gp
YoTs1xguBVcsjLEta8DSqvxWVey4L3E7x0+FWGleDxBxlffn5x2U9k+A4cHiElRU
OPgjgPk635H5I2+fUsnsY7gIIgHaFnkKQ33nkyTqh6u0WwdcrjVtJyg5S1D2PGWQ
L1S8wn5L6RFWnnz9vzXgizDDphKylN9N/fmwcjgAy8gLd7E8g7mGiuikDua7NuhA
knrkG5MCGSWm0hLUT4kE1jVJs4eJ1txxFIWi+/dftTI7OLuJES/a/FmOCh9PMQ4a
Hr8Hp2pFZgazNbyDWGFtf5cKipeEIO2uAc+tlgMdHdehyoz7bMu4A8mTIQ0hnFMs
MiA+eRbLhJKUlyHy2HDJKbD61AFp8//Q28FGyz88tCtSsfXb/oOsIPG6ufmdByfO
sxou9oFfE8i15s1oXQsH2W1t90HchKPO7iK4FbsZKo43KNKWJzifhfbuijuUbYqo
/meSI1207svS9/47VU2K
=zqQ/
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
