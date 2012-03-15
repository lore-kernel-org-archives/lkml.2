Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848Ab2COKos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:44:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52984 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753026Ab2COKoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:44:46 -0400
Date: Thu, 15 Mar 2012 10:44:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marc Reilly <marc@cpdesign.com.au>
Cc: sameo@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-i2c@vger.kernel.org,
        u.kleine-koenig@pengutronix.de, oskar@scara.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/6] regmap: add support for 7_25 format
Message-ID: <20120315104443.GC3138@opensource.wolfsonmicro.com>
References: <1331757790-10583-1-git-send-email-marc@cpdesign.com.au>
 <1331757790-10583-2-git-send-email-marc@cpdesign.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OBd5C1Lgu00Gd/Tn"
Content-Disposition: inline
In-Reply-To: <1331757790-10583-2-git-send-email-marc@cpdesign.com.au>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 15, 2012 at 07:43:05AM +1100, Marc Reilly wrote:
> This adds support for devices with 7 address bits and 25 data bits.
> The initial intended user for this are the mc13xxx mfds in spi mode.
> (The 25th data bit is actually a dummy bit)
>=20
> Signed-off-by: Marc Reilly <marc@cpdesign.com.au>

It looks like this should be using the pad_bits parameter, though
currently we only actually support pad bytes and integer sized register
values.  Ugh.  We also have some entertainment because this device
contains a touchscreen so I imagine you want readback but devices using
odd register sizes don't do readback right now.

What I think we want to do here is use pad_bits then internally to the
API notice that reg_bits + pad_bits is a byte and therefore set up for 8
bit registers and set a new value reg_shift in the map which shifts the
register address left, either teaching the register format functions
about it or just making a new one.  This should work better from a
framework point of view.

--OBd5C1Lgu00Gd/Tn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYcgVAAoJEBus8iNuMP3d61MQAJcW8hnq0haqi8lpAziuNKJs
52BB5ZPJtE6XnCXVUezGjq+HstFsvSm9SqGXdJIFVr2KmX9eFUCdsMBCQhcs/KEu
G/V5wzLTUN6MWKIt5zhuye/PVRnEIsOnt9DZslkk1lOtt83Hbx8nJF7pvPSN9TXx
zyY05y18Rr3wAMV8/Kwvnw1mv0NUo7be5X7zbXPaRXhGgw7m9X2iyrnvuX6LMaek
53mc10yBOza+pcbFO3+kFDpTYYFJpxBEVGNYftIPNwPxVrTQDbxVVDtQncQF81Vx
6xS/LWDVucR4KDMM1hUsuSGwV7ZfeB71mLGJKRr6EwgaSwb/Fv3l9shRfbyRdnRk
z5enxb+u535h0Y15aZRQZUjtwEkNQKpToy+bMwVdB3Y5Gc0Ww1Zx0jbyPKbUQsCY
rwcAyJLV+4sNsadRkprfHasDRWvyJJab8dAVky/HJMrXRK3caSXFN36WC375Cvog
Kf9aRf5+7AAZSOrtNroeEeiraOYyCnVQcRIqDNPyINxdJjWgXn9vCNtLZWV2hlLk
Pe2IofYlnOS+hLRsBBHZltmLCXg40E1ReOdC5awocnQcTDhXmRo6EO4vpliR7B4I
5vqjsbTTlIiWTXtaiz5Ab5uC/+4i8DvBKD0A7RSiSDzP+Mnh6obUpR+rzcGTlUX5
Ud+1x3w+4hAWHLT1U8lj
=9oRQ
-----END PGP SIGNATURE-----

--OBd5C1Lgu00Gd/Tn--
