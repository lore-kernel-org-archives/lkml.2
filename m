Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422898Ab2JaNc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:32:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57048 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964787Ab2JaNcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:32:55 -0400
Date: Wed, 31 Oct 2012 15:26:50 +0200
From: Felipe Balbi <balbi@ti.com>
To: Xiaotian Feng <xtfeng@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Xiaotian Feng <dannyfeng@tencent.com>,
        Li Yang <leoli@freescale.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 2/3] usb: gadget: fsl_qe_udc: do not use tasklet_disable
 before tasklet_kill
Message-ID: <20121031132650.GP10998@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1351670761-26749-1-git-send-email-xtfeng@gmail.com>
 <1351670761-26749-2-git-send-email-xtfeng@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BouVgDkIlpb7X6Bk"
Content-Disposition: inline
In-Reply-To: <1351670761-26749-2-git-send-email-xtfeng@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BouVgDkIlpb7X6Bk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 31, 2012 at 04:06:00PM +0800, Xiaotian Feng wrote:
> If tasklet_disable() is called before related tasklet handled,
> tasklet_kill will never be finished. tasklet_kill is enough.

how did you test this ? Why changing FSL driver instead of switching
over to chipidea which is supposed to be shared by every licensee of the
chipidea core ?

> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
> Cc: Li Yang <leoli@freescale.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> ---
>  drivers/usb/gadget/fsl_qe_udc.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_=
udc.c
> index b09452d..4ad3b82 100644
> --- a/drivers/usb/gadget/fsl_qe_udc.c
> +++ b/drivers/usb/gadget/fsl_qe_udc.c
> @@ -2661,7 +2661,7 @@ static int __devexit qe_udc_remove(struct platform_=
device *ofdev)
>  	usb_del_gadget_udc(&udc->gadget);
> =20
>  	udc->done =3D &done;
> -	tasklet_disable(&udc->rx_tasklet);
> +	tasklet_kill(&udc->rx_tasklet);
> =20
>  	if (udc->nullmap) {
>  		dma_unmap_single(udc->gadget.dev.parent,
> @@ -2698,8 +2698,6 @@ static int __devexit qe_udc_remove(struct platform_=
device *ofdev)
>  	free_irq(udc->usb_irq, udc);
>  	irq_dispose_mapping(udc->usb_irq);
> =20
> -	tasklet_kill(&udc->rx_tasklet);
> -
>  	iounmap(udc->usb_regs);
> =20
>  	device_unregister(&udc->gadget.dev);
> --=20
> 1.7.9.5
>=20

--=20
balbi

--BouVgDkIlpb7X6Bk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkScaAAoJEIaOsuA1yqREeZQP/1rjEi3brod38FD+F1pcIJFk
t9sVwMsFgbTRJop+BmB1cnwxgtDpwSkUTuLJAhC6iGOgBdMPr4sxyGtPLmteTech
kYZWaWTKwlTom3EGdsx3yMittfFOdwSZG9+mgy9AbuA7+FzdVGmdBcvh+e5FzMOd
sxbP2bhEQDE1wPqgdotstUiWSykfDS3uttXeet1u0GPlLrWWLSL6HZkuTZE5jyDM
bOnBnyjmToUv/AjhzPriiiStIIUTBPzlAXiqjLAMk8rbH5WQK03dfmqmZ5p98wWi
pCM/qrEB5Yc37e1ozWrqU7fkdcWAis++/pLa46Tao8XJDeWeL+xCO/+rpS76Q2DA
y5jpf5FRVlDEsYaKfZ2LGd/iBkePnb64rideCJwwAwKvwTGoG4iNrPlQnrm5ebx6
frCQx9q1vuo+8gtUyrA06rO2FPkjTgZdHb3AD8VVSYSbcMC1GWIlF9S8Kxyl5KUl
ishUW/qCCnthTr8gF34pV1OTh8M7lWfz+/GC/po8Nef0i/4ESO3UHPnMHFq8kFAN
iGK+MK9IhFf1I3E07SOuuDI7nWn4/Sw2+UX889l4cvx3zvHOaNRMG2xYAh15DvQp
N7tF0hoiUNBt/Y/q9MwUrzhplxHTpD1EhgptYkmIQXt53lxjHLgmGQUDBX55hh6E
DvlgxXrgWGVQafp7m9hO
=CINo
-----END PGP SIGNATURE-----

--BouVgDkIlpb7X6Bk--
