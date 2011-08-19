Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab1HSXbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 19:31:40 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:57803 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754093Ab1HSXbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 19:31:39 -0400
Date: Sat, 20 Aug 2011 02:31:34 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mnazarewicz@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 3/4] usb: gadget: rename usb_gadget_driver::speed to
 max_speed
Message-ID: <20110819233133.GD13317@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1313791722.git.mina86@mina86.com>
 <70e4e8e289439688e5abbd8b0bb15fcc94415bd9.1313791722.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Content-Disposition: inline
In-Reply-To: <70e4e8e289439688e5abbd8b0bb15fcc94415bd9.1313791722.git.mina86@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 20, 2011 at 12:33:01AM +0200, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>=20
> This commit renames the =E2=80=9Cspeed=E2=80=9D	field of the usb_gadget_d=
river
> structure to =E2=80=9Cmax_speed=E2=80=9D.  This is so that to make it more
> apparent that the field represents the maximum speed gadget
> driver can support.
>=20
> This also make the field look more like fields with the same
> name in usb_gadget and usb_composite_driver structures.  All
> of those represent the *maximal* speed given entity supports.
>=20
> After this commit, there are the following fields in various
> structures:
> * usb_gadget::speed - the current connection speed,
> * usb_gadget::max_speed - maximal speed UDC supports,

this will be handled inside the UDC itself, so why do you need to expose
it ?

> * usb_gadget_driver::max_speed - maximal speed gadget driver
>   supports, and
> * usb_composite_driver::max_speed - maximal speed composite
>   gadget supports.
>=20
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  drivers/usb/gadget/amd5536udc.c   |    2 +-
>  drivers/usb/gadget/ci13xxx_udc.c  |    2 +-
>  drivers/usb/gadget/composite.c    |    8 ++++----
>  drivers/usb/gadget/dbgp.c         |    2 +-
>  drivers/usb/gadget/dummy_hcd.c    |   13 ++++++-------
>  drivers/usb/gadget/file_storage.c |    4 ++--
>  drivers/usb/gadget/gmidi.c        |    2 +-
>  drivers/usb/gadget/goku_udc.c     |    2 +-
>  drivers/usb/gadget/inode.c        |    6 +++---
>  drivers/usb/gadget/m66592-udc.c   |    2 +-
>  drivers/usb/gadget/net2272.c      |    2 +-
>  drivers/usb/gadget/net2280.c      |    2 +-
>  drivers/usb/gadget/pch_udc.c      |    2 +-
>  drivers/usb/gadget/printer.c      |    2 +-
>  drivers/usb/gadget/r8a66597-udc.c |    2 +-
>  include/linux/usb/gadget.h        |    4 ++--
>  16 files changed, 28 insertions(+), 29 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536=
udc.c
> index 80ae808..7b48ed2 100644
> --- a/drivers/usb/gadget/amd5536udc.c
> +++ b/drivers/usb/gadget/amd5536udc.c
> @@ -1968,7 +1968,7 @@ static int amd5536_start(struct usb_gadget_driver *=
driver,
>  	u32 tmp;
> =20
>  	if (!driver || !bind || !driver->setup
> -			|| driver->speed !=3D USB_SPEED_HIGH)
> +			|| driver->max_speed !=3D USB_SPEED_HIGH)
>  		return -EINVAL;
>  	if (!dev)
>  		return -ENODEV;
> diff --git a/drivers/usb/gadget/ci13xxx_udc.c b/drivers/usb/gadget/ci13xx=
x_udc.c
> index b877464..6c13174 100644
> --- a/drivers/usb/gadget/ci13xxx_udc.c
> +++ b/drivers/usb/gadget/ci13xxx_udc.c
> @@ -798,7 +798,7 @@ static ssize_t show_driver(struct device *dev, struct=
 device_attribute *attr,
>  	n +=3D scnprintf(buf + n, PAGE_SIZE - n, "function  =3D %s\n",
>  		       (driver->function ? driver->function : ""));
>  	n +=3D scnprintf(buf + n, PAGE_SIZE - n, "max speed =3D %d\n",
> -		       driver->speed);
> +		       driver->max_speed);
> =20
>  	return n;
>  }
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composit=
e.c
> index 5a3461e..851b5da 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -1560,9 +1560,9 @@ composite_resume(struct usb_gadget *gadget)
> =20
>  static struct usb_gadget_driver composite_driver =3D {
>  #ifdef CONFIG_USB_GADGET_SUPERSPEED
> -	.speed		=3D USB_SPEED_SUPER,
> +	.max_speed	=3D USB_SPEED_SUPER,
>  #else
> -	.speed		=3D USB_SPEED_HIGH,
> +	.max_speed	=3D USB_SPEED_HIGH,

by doing this based on what the function drivers tell you, you could
drop this ifdeferry.

--=20
balbi

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTvJVAAoJEAv8Txj19kN1ZEMIAKrBvrP6ZhWkvDrgEo6+GkQR
dpx3Kl/et0liGpweceSSVtQuZ7xBm0locmCshjs8bRrB6hW/thAGW2s7p99uvgE5
+N3zm3uLZ1RkeqePWdovDUf10wDjuMcFjkfRnkYv5jxgygdio4/WE5S4pgvCxI41
FoLCYCHjX1zhjCbxFcSKVgPAnWTJoTstVwFBgt59kVt+HvXVAhF165TPNK979awG
DzReqircq0q1Oa8M47kc/pQfuoxVWgXsivH0KnGT6DmX3/N/7ffDde+dqZMJ4uEF
9Y3h8HLJ6xG5VAUsgOkgubM+Opuzmre/xK8WxgG/1JueQvbJNgZOGZlJIRhzmqs=
=eFmy
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
