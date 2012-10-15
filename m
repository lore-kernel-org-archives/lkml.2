Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab2JOMYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:24:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40074 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab2JOMYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:24:18 -0400
Date: Mon, 15 Oct 2012 15:18:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
CC: <balbi@ti.com>, <stern@rowland.harvard.edu>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linus.walleij@linaro.org>,
        <ragupathy.rajaram@stericsson.com>, <praveen.nadahally@stericsson.com>
Subject: Re: [PATCH] usb:musb: Dequeue urbs on device unplug
Message-ID: <20121015121836.GN24333@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1349843763-24716-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4OpS+d6oOtUQaRm1"
Content-Disposition: inline
In-Reply-To: <1349843763-24716-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4OpS+d6oOtUQaRm1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 10, 2012 at 10:06:03AM +0530, Virupax Sadashivpetimath wrote:
> Flush queued urbs on receiving device disconnect
> interrupt. This is required for successful disconnect
> and successive enumeration of the device.
>=20
> In a failure case khubd hangs on usb-storage thread
> for completion. Seen in the below trace.
>=20
> [ 1355.764526] SysRq : Show Blocked State
> [ 1355.768341]   task                PC stack   pid father
> [ 1355.773620] khubd           D c06a1fbc     0   503      2 0x00000000
> [ 1355.780151] [<c06a1fbc>] (__schedule+0x3f0/0x8ec) from [<c06a26a0>] (s=
chedule+0x58/0x70)
> [ 1355.788330] [<c06a26a0>] (schedule+0x58/0x70) from [<c06a2af8>] (sched=
ule_timeout+0x1d8/0x31c)
> [ 1355.796997] [<c06a2af8>] (schedule_timeout+0x1d8/0x31c) from [<c06a199=
4>] (wait_for_common+0xd8/0x180)
> [ 1355.806396] [<c06a1994>] (wait_for_common+0xd8/0x180) from [<c06a1b14>=
] (wait_for_completion+0x20/0x24)
> [ 1355.815887] [<c06a1b14>] (wait_for_completion+0x20/0x24) from [<c00b99=
98>] (kthread_stop+0x68/0x17c)
> [ 1355.825103] [<c00b9998>] (kthread_stop+0x68/0x17c) from [<c039e0e0>] (=
release_everything+0x30/0x8c)
> [ 1355.834228] [<c039e0e0>] (release_everything+0x30/0x8c) from [<c039e16=
8>] (usb_stor_disconnect+0x2c/0x30)
> [ 1355.843902] [<c039e168>] (usb_stor_disconnect+0x2c/0x30) from [<c038e3=
a8>] (usb_unbind_interface+0x60/0x1e0)
> [ 1355.853820] [<c038e3a8>] (usb_unbind_interface+0x60/0x1e0) from [<c031=
dcc0>] (__device_release_driver+0x80/0xd0)
> [ 1355.864074] [<c031dcc0>] (__device_release_driver+0x80/0xd0) from [<c0=
31ddfc>] (device_release_driver+0x2c/0x38)
> [ 1355.874359] [<c031ddfc>] (device_release_driver+0x2c/0x38) from [<c031=
d0d8>] (bus_remove_device+0xbc/0x10c)
> [ 1355.884155] [<c031d0d8>] (bus_remove_device+0xbc/0x10c) from [<c031b63=
c>] (device_del+0x108/0x17c)
> [ 1355.893188] [<c031b63c>] (device_del+0x108/0x17c) from [<c038afe8>] (u=
sb_disable_device+0xbc/0x200)
> [ 1355.902313] [<c038afe8>] (usb_disable_device+0xbc/0x200) from [<c0384c=
58>] (usb_disconnect+0xb8/0x194)
> [ 1355.911682] [<c0384c58>] (usb_disconnect+0xb8/0x194) from [<c0385e58>]=
 (hub_thread+0x45c/0x14b0)
> [ 1355.920562] [<c0385e58>] (hub_thread+0x45c/0x14b0) from [<c00b97e0>] (=
kthread+0x98/0xa0)
> [ 1355.928710] [<c00b97e0>] (kthread+0x98/0xa0) from [<c0064834>] (kernel=
_thread_exit+0x0/0x8)
> [ 1356.014373] usb-storage     D c06a1fbc     0  2379      2 0x00000000
> [ 1356.020843] [<c06a1fbc>] (__schedule+0x3f0/0x8ec) from [<c06a26a0>] (s=
chedule+0x58/0x70)
> [ 1356.029022] [<c06a26a0>] (schedule+0x58/0x70) from [<c06a2af8>] (sched=
ule_timeout+0x1d8/0x31c)
> [ 1356.037719] [<c06a2af8>] (schedule_timeout+0x1d8/0x31c) from [<c06a199=
4>] (wait_for_common+0xd8/0x180)
> [ 1356.047088] [<c06a1994>] (wait_for_common+0xd8/0x180) from [<c06a1b14>=
] (wait_for_completion+0x20/0x24)
> [ 1356.056549] [<c06a1b14>] (wait_for_completion+0x20/0x24) from [<c038b5=
dc>] (usb_sg_wait+0x108/0x194)
> [ 1356.065795] [<c038b5dc>] (usb_sg_wait+0x108/0x194) from [<c039d6dc>] (=
usb_stor_bulk_transfer_sglist+0x9c/0xf4)
> [ 1356.075866] [<c039d6dc>] (usb_stor_bulk_transfer_sglist+0x9c/0xf4) fro=
m [<c039d76c>] (usb_stor_bulk_srb+0x38/0x50)
> [ 1356.086303] [<c039d76c>] (usb_stor_bulk_srb+0x38/0x50) from [<c039d92c=
>] (usb_stor_Bulk_transport+0x114/0x2d0)
> [ 1356.096374] [<c039d92c>] (usb_stor_Bulk_transport+0x114/0x2d0) from [<=
c039d190>] (usb_stor_invoke_transport+0x34/0x3f4)
> [ 1356.107238] [<c039d190>] (usb_stor_invoke_transport+0x34/0x3f4) from [=
<c039cc0c>] (usb_stor_transparent_scsi_command+0x18/0x1c)
> [ 1356.118804] [<c039cc0c>] (usb_stor_transparent_scsi_command+0x18/0x1c)=
 from [<c039f144>] (usb_stor_control_thread+0x190/0x28c)
> [ 1356.130279] [<c039f144>] (usb_stor_control_thread+0x190/0x28c) from [<=
c00b97e0>] (kthread+0x98/0xa0)
> [ 1356.139465] [<c00b97e0>] (kthread+0x98/0xa0) from [<c0064834>] (kernel=
_thread_exit+0x0/0x8)
>=20
> Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@sterics=
son.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

I would like to get some Tested-bys here.

> ---
>  drivers/usb/musb/musb_core.c |   37 +++++++++++++++++++++++++++++++++++++
>  drivers/usb/musb/musb_host.c |    3 +++
>  2 files changed, 40 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> index bb56a0e..fc6e990 100644
> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -414,6 +414,41 @@ static void musb_otg_timer_func(unsigned long data)
>  	spin_unlock_irqrestore(&musb->lock, flags);
>  }
> =20
> +void musb_handle_disconnect(struct musb *musb)
> +{
> +	int epnum, i;
> +	struct urb		*urb;
> +	struct musb_hw_ep       *hw_ep;
> +	struct musb_qh		*qh;
> +	struct usb_hcd *hcd =3D musb_to_hcd(musb);
> +
> +	for (epnum =3D 0; epnum < musb->config->num_eps;
> +			epnum++) {
> +		hw_ep =3D musb->endpoints + epnum;
> +		for (i =3D 0; i < 2; i++) {
> +			if (hw_ep->in_qh =3D=3D hw_ep->out_qh)
> +				i++;
> +			qh =3D (i =3D=3D 0) ? hw_ep->in_qh : hw_ep->out_qh;
> +
> +			if (qh && qh->hep) {
> +				qh->is_ready =3D 0;
> +				while ((urb =3D next_urb(qh))) {
> +					usb_hcd_unlink_urb_from_ep(hcd, urb);
> +
> +					spin_unlock(&musb->lock);
> +					usb_hcd_giveback_urb(hcd, urb, 0);
> +					spin_lock(&musb->lock);
> +				}
> +
> +				qh->hep->hcpriv =3D NULL;
> +				list_del(&qh->ring);
> +				kfree(qh);
> +				hw_ep->in_qh =3D hw_ep->out_qh =3D NULL;
> +			}
> +		}
> +	}
> +}
> +
>  /*
>   * Stops the HNP transition. Caller must take care of locking.
>   */
> @@ -779,11 +814,13 @@ b_host:
>  				otg_state_string(musb->xceiv->state),
>  				MUSB_MODE(musb), devctl);
>  		handled =3D IRQ_HANDLED;
> +		musb->is_active =3D 0;
> =20
>  		switch (musb->xceiv->state) {
>  		case OTG_STATE_A_HOST:
>  		case OTG_STATE_A_SUSPEND:
>  			usb_hcd_resume_root_hub(musb_to_hcd(musb));
> +			musb_handle_disconnect(musb);
>  			musb_root_disconnect(musb);
>  			if (musb->a_wait_bcon !=3D 0)
>  				musb_platform_try_idle(musb, jiffies
> diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
> index 3df6a76..300786a 100644
> --- a/drivers/usb/musb/musb_host.c
> +++ b/drivers/usb/musb/musb_host.c
> @@ -1921,6 +1921,9 @@ static int musb_schedule(
>  	u8			txtype;
>  	struct urb		*urb =3D next_urb(qh);
> =20
> +	if (!musb->is_active)
> +		return -ENODEV;
> +
>  	/* use fixed hardware for control and bulk */
>  	if (qh->type =3D=3D USB_ENDPOINT_XFER_CONTROL) {
>  		head =3D &musb->control;
> --=20
> 1.7.4.3
>=20

--=20
balbi

--4OpS+d6oOtUQaRm1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQe/8cAAoJEIaOsuA1yqREXvAQAKHpF+f+gM4fI7CMKiaOP61O
jo641tnq0V493RNr3dPzM/9sAJt18oY8cTDWkHotpO7ip09QE20E3P9GQZ3G0oTS
XT+X2T7JhY3J4P8LPHV8hKlTYpQT/53JYVx/n6bRGVf36a4HQkqyEpr3TWcfsqr/
jrwEh7otp7DC41HUQc9nPn3cYjt6WKCNCad8NVKi+rse3LDTa7sV7P1ohPVoMn28
fAidi/EOJKf7Mb6gCKxvmlonvLQI6dWURYKBHQDLqBM1XznoPQUwZNtI43n6Rsf9
vN9AlzVuU6TOXHEUVGWOvsjlHZBaYnXXB21im1lC72S7DeH+RQWpbO4XofucGrhe
cJFZXJSlqLQWc7OhsECrQKYSxrj1NIeOQn6aEVl2xSQjkF3/M6+VFdUAeNrbyAKA
6QIe+WEcPyEZqB7ayih1pXowpRq/5uBBbU0hhksfZAClgElrKrDb7xbs6c8kVhTT
fb/mB73KC7aOz0P6HciBY2Pq4BI58J13e5bs7+VVs6Tt/VWa26tJdpvvTdhvwkv0
HuqPiHlm0W7SWZl5u+aGuL7PvCLZxv80YjCjtoVkSaoU6urGWERD+4VLGdYjx92b
Y05Ud65QXANNVJCfYLxEbsC+s14XBd4ZfOpPw8VoGOLyVg67EEVriWo6Ar3CP2gQ
yX2oh2uuZ8yOYD/NI8nU
=uhtE
-----END PGP SIGNATURE-----

--4OpS+d6oOtUQaRm1--
