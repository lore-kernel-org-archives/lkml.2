Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab1KIIUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:20:11 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:43740 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932207Ab1KIIUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:20:09 -0500
Date: Wed, 9 Nov 2011 10:20:05 +0200
From: Felipe Balbi <balbi@ti.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        eric.miao@linaro.org, Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: Adding USB charge current property in the Linux Battery core
Message-ID: <20111109082005.GH23337@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1320826417.1160.8.camel@L-0761.kpit.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qM81t570OJUP5TU/"
Content-Disposition: inline
In-Reply-To: <1320826417.1160.8.camel@L-0761.kpit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qM81t570OJUP5TU/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 09, 2011 at 01:43:37PM +0530, ashishj3 wrote:
> For a better performance in USB charging operation, the DA9052/53 charging
> current can be configured in accordance with the USB host current
> delivering capacity (known through USB drivers negotiation).
> =20
> To implement this useful feature, a new writable property "USB charge cur=
rent"
> needs to be added in the Linux battery core.
>=20
> Let me know your views on it.

that's the wrong way to do it. What we need is to use the transceiver
notifications to notify every time someone calls usb_gadget_vbus_draw()
and pass the mA parameter as argument to the event notification.

Charger driver should 'subscribe' to transceiver notifications and
use the mA argument to reconfigure charging.

--=20
balbi

--qM81t570OJUP5TU/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuje0AAoJEIaOsuA1yqRE70oP/2uoobR+qCTsEG81Ip/YgZTC
lMy8/nX42R/mMPP6NJwv0NZWEIyMhYbWRcrVsSSKT64HiUFTskzXea2fv+gblVtd
sSXDHF4nvcYyo/uPcfLVNxthGoWMh5zpJsoVK4x0kAR+r7LbE+kF76QXKNKs7mbG
+MwBcunm6Icxaz30Yp54WmCyVIlovVLurVGJmiMpSFx3HNM/gSg9JgXcP3MhVQDB
HW/okZsnQ+3/MYRVSPTHF7607cg88nHycPMazpiJS+IKx8BsOBhpgDdhXROpt6Du
9iOdwRknRM9pY7O82lrseBQsimkg63pOZp6dG3cJJktEzUt0YtBzU8cShrBhxeCM
Q5A6VLbd5/4DnBupBwALAAizgt77kJFrrJzTWfOF/CGqxTNjSwyMN27qs6QhQRRf
SnQY0YmbVM2OeSsv1LRIn/TUAodXxDAOVURuYSn3O3VKpMRIbnNeDHObfLNUKJFC
47K9ywGAiSJZwVNKOfljQ1eOF3/RWPko25EAcFmUmw/9acfESZPHTqzLVVmSGu6g
jjJ3RNDWn9fOMfqW8wuG4r3AtaKwDzbximXLsU2ACPGJGuuphqkvltC0PVbIkul/
ZvWjhCAmjSwjrfO9Dr6Slo8hVx0MMdo0AHdT/h5bJdH9bGGxZUOp8Uq/IBF7HhQZ
rFuM42cerubprXU+gx7M
=DOXu
-----END PGP SIGNATURE-----

--qM81t570OJUP5TU/--
