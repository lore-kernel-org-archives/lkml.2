Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab1FPQSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:18:39 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:57045 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594Ab1FPQSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:18:36 -0400
Date: Thu, 16 Jun 2011 19:18:30 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC 2/5] usb:dummy_hcd: connect/disconnect test support
Message-ID: <20110616161828.GW12230@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org>
 <1308231068-24038-3-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0k4Rxg87Lb8yV0u3"
Content-Disposition: inline
In-Reply-To: <1308231068-24038-3-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0k4Rxg87Lb8yV0u3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 16, 2011 at 04:31:04PM +0300, Tatyana Brokhman wrote:
> @@ -1362,6 +1363,43 @@ static struct dummy_ep *find_endpoint (struct dumm=
y *dum, u8 address)
>  #define Ep_Request	(USB_TYPE_STANDARD | USB_RECIP_ENDPOINT)
>  #define Ep_InRequest	(Ep_Request | USB_DIR_IN)
> =20
> +/**
> + * dummy_hcd_conn_disc_work() - performs a disconnect/connect sequence.
> + * @data: pointer to the sceduled work_struct
> + */
> +static void dummy_hcd_conn_disc_work(struct work_struct *data)
> +{
> +	struct dummy_hcd *dum_hcd =3D
> +		container_of(data, struct dummy_hcd, conn_disc_work);
> +	int ret_val;
> +
> +	if (!dum_hcd->dum->driver) {
> +		dev_err(dummy_dev(dum_hcd),
> +			"dummy_hcd_conn_disc_work called without connected "
> +			"device\n");
> +		return;
> +	}
> +
> +	dev_info(dummy_dev(dum_hcd), "disconnecting device...\n");
> +	ret_val =3D dummy_pullup(&dum_hcd->dum->gadget, 0);
> +	if (ret_val) {
> +		dev_err(dummy_dev(dum_hcd), "dummy_hcd_conn_disc_work:"
> +					    " couldn't disconnect device:"
> +					    " ret_val=3D%d\n",
> +				ret_val);
> +		return;
> +	}
> +
> +	dev_info(dummy_dev(dum_hcd), "re-connecting device...\n");
> +	/* We have to let the hub task to update the device disconnect state */
> +	msleep_interruptible(1000);
> +	ret_val =3D dummy_pullup(&dum_hcd->dum->gadget, 1);
> +	if (ret_val)
> +		dev_err(dummy_dev(dum_hcd), "dummy_hcd_conn_disc_work:"
> +					    " couldn't re-connect device:"
> +					    " ret_val=3D%d\n",
> +				ret_val);

this print is quite ugly. How about something like:

	dev_err(dummy_dev(dum_hcd), "%s: couldn't re-connect --> %d\n",
		__func__, ret_val);

???

--=20
balbi

--0k4Rxg87Lb8yV0u3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+izUAAoJEAv8Txj19kN1qcoH/RuJ+PpHqPIrA9VKr9bhUeVu
grvbw6NUizV86aeHxTaY9PSmjmYck2t1bQNsTwqzAy3RDlG/XjAo2DMcmClbmOKb
VgO2tJniLfaq3lr7Lnr4VTG4VI0z+tqclX3OX1BOrnHSYJaiWushSqDxw3M275ot
a7LltmMyezofFo+P1PKjQvSNmMbMIHhkO64KFZwSFeNC34GHCScO1IyBqi/NDsj2
Lb/kTj0amRGRnzF4U2Sk83o9dXT6gSuKtRHqyeHPOsNygFNg24DLluWlb6yT8dNM
8Fr0NQDeatSIjK0bI5B4xn/wkcQwJiUxR+jt+Z4fT9E+Fi5CddTeaRebjQ26+2U=
=QV9l
-----END PGP SIGNATURE-----

--0k4Rxg87Lb8yV0u3--
