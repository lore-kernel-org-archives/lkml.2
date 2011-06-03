Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1FCIDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 04:03:45 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:50659 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770Ab1FCIDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 04:03:42 -0400
Date: Fri, 3 Jun 2011 11:03:35 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 7/9] usb:gadget: Add SuperSpeed support to the Gadget
 Framework
Message-ID: <20110603080333.GS2409@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1306847914-19876-1-git-send-email-tlinder@codeaurora.org>
 <1306847914-19876-8-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WVXkb2QE2eH0aWe4"
Content-Disposition: inline
In-Reply-To: <1306847914-19876-8-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WVXkb2QE2eH0aWe4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 31, 2011 at 04:18:27PM +0300, Tatyana Brokhman wrote:
> @@ -377,9 +425,10 @@ static int config_desc(struct usb_composite_dev *cde=
v, unsigned w_value)
>  	u8				type =3D w_value >> 8;
>  	enum usb_device_speed		speed =3D USB_SPEED_UNKNOWN;
> =20
> -	if (gadget_is_dualspeed(gadget)) {
> -		int			hs =3D 0;
> -
> +	if (gadget->speed =3D=3D USB_SPEED_SUPER)

if (gadget_is_superspeed(gadget)) ??

> @@ -413,16 +469,22 @@ static int count_configs(struct usb_composite_dev *=
cdev, unsigned type)
>  	struct usb_configuration	*c;
>  	unsigned			count =3D 0;
>  	int				hs =3D 0;
> +	int				ss =3D 0;
> =20
>  	if (gadget_is_dualspeed(gadget)) {
>  		if (gadget->speed =3D=3D USB_SPEED_HIGH)
>  			hs =3D 1;
> +		if (gadget->speed =3D=3D USB_SPEED_SUPER)
> +			ss =3D 1;

is this really correct under gadget_is_dualspeed() ?? puzzled.

--=20
balbi

--WVXkb2QE2eH0aWe4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN6JVVAAoJEAv8Txj19kN17psH/RrqYP1QMfdAO9wkWMHtTjAH
aGd+v4zOy8ujP2CxdK6kvZ+Ui9/yYmSYGZNQi3VlFLNthwui9N3MlRq9Uh+G1bv4
pBDI83uQ97RSRSOUJ/8FrR4RS371GYXATSvsPoRC+iN/3oI5snmS48WIatVwxoHO
Xt35/KHJo6LsheIyq9uFY9fzLz3OKgm42ja6xrryY486QZ8blGdQraTR8PhuChZK
yczT33LKNSZqtNlhzqlWCSL3594tUKEg8QuAXeZHfo2TsdRalzE1thTNHudguopN
Sa+ENG3mfQ5GXx7RUR0zl9LA7JC3aZDWJIr+nf5M4T7+fAsJ8UoLZ9qjEE7bMcs=
=gCaH
-----END PGP SIGNATURE-----

--WVXkb2QE2eH0aWe4--
