Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab1KOIfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 03:35:02 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:58440 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753624Ab1KOIfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 03:35:00 -0500
Date: Tue, 15 Nov 2011 10:34:55 +0200
From: Felipe Balbi <balbi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: oskar.andero@sonyericsson.com,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "aghayal@codeaurora.org" <aghayal@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonyericsson.com>
Subject: Re: [PATCH v2] input: add driver support for Sharp gp2ap002a00f
 proximity sensor
Message-ID: <20111115083454.GE6492@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1321285158-7123-1-git-send-email-oskar.andero@sonyericsson.com>
 <20111114170352.GA12659@core.coreip.homeip.net>
 <20111115075629.GE9307@caracas.corpusers.net>
 <20111115082926.GA13157@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/2994txjAzEdQwm5"
Content-Disposition: inline
In-Reply-To: <20111115082926.GA13157@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/2994txjAzEdQwm5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 15, 2011 at 12:29:26AM -0800, Dmitry Torokhov wrote:
> > > > +	error =3D input_register_device(dt->device);
> > > > +	if (error) {
> > > > +		dev_err(&dt->device->dev, "device registration failed\n");
> > > > +		input_free_device(dt->device);
> > >=20
> > > If you swap request_threaded_irq() and input_register_device() so that
> > > registration is the last action error handling will be much simpler.
> > >
> >=20
> > I am getting a bit confused here, since you asked me to swap the order
> > of request_threaded_irq() and input_register_device() in my previous
> > version as well. Swapping again will take us back to square one or maybe
> > I am misinterpreting your comment?
>=20
> Gah, sorry, a bit of boilerplate slipped in. You already have the calls
> in right order, you just need proper labels.
>=20
>=20
> 	input_dev =3D input_allocate_device();
> 	if (!input_dev) {
> 		dev_err(...);
> 		error =3D -ENOMEM;
> 		goto err_free_mem;
> 	}
>=20
> 	... set up input device fully ...
>=20
> 	error =3D request_threaded_irq(...);
> 	if (error) {
> 		dev_err(...);
> 		goto err_free_input_dev;
> 	}
>=20
> 	error =3D input_register_device(input_dev);
> 	if (error) {
> 		dev_err(...);
> 		goto err_free_irq;
> 	}

are you sure this is right order ? Won't this create a very small
timeframe where we could try to call input_report_switch() and
input_sync() on an unregistered input device ??

--=20
balbi

--/2994txjAzEdQwm5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOwiQuAAoJEIaOsuA1yqREsLMP/igXEPsej8Ml237iHfTk2TWW
4rkllWXAfP5ynwyX2+LvVDed+YeyV2pg5cqyMxjNS0SbMLIsKNC7u9FZdmJUoS97
hRxml4qZBLoz3myKOeidijtxRvDeGPqURZJJ5SK1XY7fhGjzpj/yWl0x+oQpbfTx
rBXGSan2W0OuithIQtrJ7uJN1RM+o7ro4JijUclmguoqu1cLJK/ur4xS5Lt4P6RU
PcOUJ1JGniiqpIe1TlC27R5clV174ztZF26QRqmOQMQahUWrWPvAEtb6MZs00ndR
HKfqPdnGIPWTl/tt4U6jJv1X6BmdYPqYREDQhPzaYKWeAfdyWkIIcnUFBgfcdw8/
vdhrXe8NeMLVLWKAT2vj7cYztjTAEk5fNx6qLYZ9/claziNnGtCpmJaS2/hdR+T+
4UJrH+AMP1Tq54El+CcMs9njUev6PnV06xutdA6IwfUMmMDJJjgA+OvQ1uRjTYZz
aL2YRekoeK7fpVXLkdw0yw2s+EqC44V7/9i8izcQXZnWZAvrhlEujnshDP39gUah
/D4qfDFydI7Y/NfZEHSG411iuJSPCPDNrS5pH/Ulp/TxelW+arek8Az6AoL6Aj4K
AE8ldBgszdRyaY/0kHvhhk13IjKD2YsuHnWNPKp8aGvBJx6NzV6i+ZvFC6VOfHMn
0hCDg72bvnBVgcdt6X66
=IZkW
-----END PGP SIGNATURE-----

--/2994txjAzEdQwm5--
