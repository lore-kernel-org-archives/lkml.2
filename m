Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175Ab2COJJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 05:09:06 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:47837 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756303Ab2COJJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 05:09:01 -0400
Date: Thu, 15 Mar 2012 11:08:51 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alex Shi <alex.shi@intel.com>
Cc: Alan stern <stern@rowland.harvard.edu>,
        gregkh <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        "Sharp, Sarah A" <sarah.a.sharp@intel.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/xhci: unify parameter of xhci_msi_irq
Message-ID: <20120315090850.GC21287@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1331787186.2979.71.camel@debian>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+xNpyl7Qekk2NvDX"
Content-Disposition: inline
In-Reply-To: <1331787186.2979.71.camel@debian>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+xNpyl7Qekk2NvDX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 15, 2012 at 12:53:06PM +0800, Alex Shi wrote:
>=20
> According to Felipe and Alan's comments the second parameter of irq
> handler should be 'void *' not a specific structure pointer.=20
> So change it.
>=20
> Signed-off-by: Alex Shi <alex.shi@intel.com>

after a quick look:

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/host/xhci-ring.c |    2 +-
>  drivers/usb/host/xhci.c      |    4 ++--
>  drivers/usb/host/xhci.h      |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index b62037b..c5caad3 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -2396,7 +2396,7 @@ hw_died:
>  	return IRQ_HANDLED;
>  }
> =20
> -irqreturn_t xhci_msi_irq(int irq, struct usb_hcd *hcd)
> +irqreturn_t xhci_msi_irq(int irq, void *hcd)
>  {
>  	return xhci_irq(hcd);
>  }
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index c939f5f..84706cb 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -204,7 +204,7 @@ static int xhci_setup_msi(struct xhci_hcd *xhci)
>  		return ret;
>  	}
> =20
> -	ret =3D request_irq(pdev->irq, (irq_handler_t)xhci_msi_irq,
> +	ret =3D request_irq(pdev->irq, xhci_msi_irq,
>  				0, "xhci_hcd", xhci_to_hcd(xhci));
>  	if (ret) {
>  		xhci_dbg(xhci, "disable MSI interrupt\n");
> @@ -276,7 +276,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
> =20
>  	for (i =3D 0; i < xhci->msix_count; i++) {
>  		ret =3D request_irq(xhci->msix_entries[i].vector,
> -				(irq_handler_t)xhci_msi_irq,
> +				xhci_msi_irq,
>  				0, "xhci_hcd", xhci_to_hcd(xhci));
>  		if (ret)
>  			goto disable_msix;
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index fb99c83..d82cbb6 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -1669,7 +1669,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hiberna=
ted);
> =20
>  int xhci_get_frame(struct usb_hcd *hcd);
>  irqreturn_t xhci_irq(struct usb_hcd *hcd);
> -irqreturn_t xhci_msi_irq(int irq, struct usb_hcd *hcd);
> +irqreturn_t xhci_msi_irq(int irq, void *hcd);
>  int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev);
>  void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev);
>  int xhci_alloc_tt_info(struct xhci_hcd *xhci,
> --=20
> 1.6.3.3
>=20
>=20
>=20

--=20
balbi

--+xNpyl7Qekk2NvDX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYbGiAAoJEIaOsuA1yqREwQcQAKlBK6fybP+VtAtdXLW3EOBM
VdivrvknhJKFZ1XAuXyGoGBGY/RuLDok14JvcbPwsAQazEXV54myN6CJuaH+I6yd
f4MQbek+xeKl1pl0BS+S0lMQOtk83vy9ihC62qGjdFvBEWdyYHkRr8kGciQzXjy4
lrTD6z+RQmNS21AUpsrBFouAdIWSsIWSDP3/vzy+Iy13emJje/PdqNHHDwsNivRq
N5/+VtejyWN/ijUQMzrg9Shbu6pkg7QAcBT04khWsf85S8RWTbPAVj1CMlYPVgeZ
fci2MxUhUo5UutGzmfRdmlmlQin2giT8x2GYzpnjUpTphD4UucMg7+bKbADvVWUv
pNUL/kclQVsd8dLmBWKwnTj5rX0Nye5iAI493tXFSRfzI3gzB32e8UD73805WERA
yfUzAz9IWt4TUq26ZCro1lhntG3hZZhaC8GbhRzpuyNoBFzb0zRRHNooU5JqLwA+
8zVUiDTrdOdVOG/n5/yMtdNC7oPt9fB8/IMm5/6TWyMHT5u3WvHWeNUM5FYU1n95
9by7GeeKkeeJH+W/iJ3MBnCrZJQj3aoZ4wGLRFUVKgh1n4CGb2uRtVIZOwZww1zt
riJFVkY4CFxJ1kP7aB1aJ/oiJh9Naj3zIcCWjAjnqbC+CsJufq4AEL6Z5iKBGUKD
ooTuYA+sSPjpB/bLsHOn
=D0C+
-----END PGP SIGNATURE-----

--+xNpyl7Qekk2NvDX--
