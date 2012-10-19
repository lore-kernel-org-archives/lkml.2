Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167Ab2JSRnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:43:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60459 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759078Ab2JSRnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:43:00 -0400
Date: Fri, 19 Oct 2012 20:37:19 +0300
From: Felipe Balbi <balbi@ti.com>
To: Simon Haggett <simon.haggett@realvnc.com>
CC: Li Yang <leoli@freescale.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/1] usb: gadget: Don't attempt to dequeue requests for a
 disabled USB endpoint on Freescale hardware
Message-ID: <20121019173718.GA2738@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350667166-3559-1-git-send-email-simon.haggett@realvnc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <1350667166-3559-1-git-send-email-simon.haggett@realvnc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 19, 2012 at 06:19:26PM +0100, Simon Haggett wrote:
> Some gadget drivers may attempt to dequeue requests for an endpoint that =
has
> already been disabled. For example, in the UVC gadget driver, uvc_functio=
n_set_alt()
> will call usb_ep_disable() when alt setting 0 is selected. When the users=
pace
> application subsequently issues the VIDIOC_STREAMOFF ioctl, uvc_video_ena=
ble()
> invokes usb_ep_dequeue() to ensure that all requests have been cancelled.

bug is on uvc gadget, then. Laurent ?

Also, fsl should be removed from the tree, I'm trying to persuade iMX
folks to use drivers/usb/chipidea instead.

> For the Freescale High Speed Dual-Role USB controller, fsl_ep_dequeue() p=
rovides
> the implementation of usb_ep_dequeue(). If this is called for a disabled =
endpoint,
> a kernel oops will occur when the ep->ep.desc field is dereferenced (by e=
p_index()).
> fsl_ep_disable() sets this field to NULL, as well as deleting all pending=
 requests
> for the endpoint.
>=20
> This patch adds an additional check to fsl_ep_dequeue() to ensure that the
> endpoint has not already been disabled before attempting to dequeue reque=
sts.
>=20
> Signed-off-by: Simon Haggett <simon.haggett@realvnc.com>
> ---
>  drivers/usb/gadget/fsl_udc_core.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_u=
dc_core.c
> index 6ae70cb..acd513b 100644
> --- a/drivers/usb/gadget/fsl_udc_core.c
> +++ b/drivers/usb/gadget/fsl_udc_core.c
> @@ -955,7 +955,10 @@ static int fsl_ep_dequeue(struct usb_ep *_ep, struct=
 usb_request *_req)
>  	int ep_num, stopped, ret =3D 0;
>  	u32 epctrl;
> =20
> -	if (!_ep || !_req)
> +	/* Ensure that the ep and request are valid, and the ep is not
> +	 * disabled
> +	 */
> +	if (!_ep || !_req || !ep->ep.desc)
>  		return -EINVAL;
> =20
>  	spin_lock_irqsave(&ep->udc->lock, flags);
> --=20
> 1.7.4.1
>=20

--=20
balbi

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQgY/OAAoJEIaOsuA1yqRE9eMP+wUsM1/1Gfw+t5rlLkUsJlJL
fygKxCgyQ+ZZKfkH3R7jzByWE3rs54sBwduB0HBaGT5bGeWaSgAoUs96UY78DiAC
eLDl78iL8rMGkYhU4pRYWuZewue/dlmIkd84c5f9lQ5hg/6guD721aT7gaaC+nzb
PnluAUizkD5hYt5ixv3I7DlXAyw0OwrCOBVwByHSKScQp1a2KBL8L75vCMK2YkFZ
ssI5NfW18k/8XcjkMw22MyeCfaTuuwAl+Pv1v5eBZbhinFvdhpe75IxvwO867d6J
EHw3p2UI3YP8c8SYHACIqW8a70eC8ESLLN42ObslUe8EcK8/j+pb0Xqu9yA/NbbL
LG1ApoebAmRsKuZ55NgztZS9SG1Vrfk+qdO7s8nG5E6B3I0TCsxmL5LpovZc8tIQ
uLERkGwdNfQq4QdViIYDy7iwLTOzwomNos4rMrlHwIdtmKPPf5TphhiISGd099co
mIIFiYJXWfeiEZfEQHETnuithA7oqhPm3p1EnOAdQ8xxzzxoArEgJ2c71zM3HFUF
JbHTzJGB59xoKZvMrwtX+GzINbUN2qup5AdTjN3cunxVQzJdd8QsJH7uhNRy928e
I65LRfEGOmDDbaNjqNJ5Z/s/wTzAYgCh4r2TyyIIMR3c9TsDwZhcr92qx1dFCbZ2
M+LmoCOGHmg3bV3gHbvI
=1zoX
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
