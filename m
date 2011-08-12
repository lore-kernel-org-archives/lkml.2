Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab1HLJUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 05:20:43 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:37744 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768Ab1HLJUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 05:20:42 -0400
Date: Fri, 12 Aug 2011 12:20:37 +0300
From: Felipe Balbi <balbi@ti.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3] usb: gadget: storage_common: make FSG_NUM_BUFFERS
 variable size
Message-ID: <20110812092036.GM19467@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1312839815-30886-1-git-send-email-per.forlin@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tDYGg60iReQ7u8wj"
Content-Disposition: inline
In-Reply-To: <1312839815-30886-1-git-send-email-per.forlin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tDYGg60iReQ7u8wj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 08, 2011 at 11:43:35PM +0200, Per Forlin wrote:
> FSG_NUM_BUFFERS is set to 2 as default.
> Usually 2 buffers are enough to establish a good buffering pipeline.
> The number may be increased in order to compensate a for bursty VFS
> behaviour.
>=20
> Here follows a description of system that may require more than
> 2 buffers.
>  * CPU ondemand governor active
>  * latency cost for wake up and/or frequency change
>  * DMA for IO
>=20
> Use case description.
>  * Data transfer from MMC via VFS to USB.
>  * DMA shuffles data from MMC and to USB.
>  * The CPU wakes up every now and then to pass data in and out from VFS,
>    which cause the bursty VFS behaviour.
>=20
> Test set up
>  * Running dd on the host reading from the mass storage device
>  * cmdline: dd if=3D/dev/sdb of=3D/dev/null bs=3D4k count=3D$((256*100))
>  * Caches are dropped on the host and on the device before each run
>=20
> Measurements on a Snowball board with ondemand_govenor active.
>=20
> FSG_NUM_BUFFERS 2
> 104857600 bytes (105 MB) copied, 5.62173 s, 18.7 MB/s
> 104857600 bytes (105 MB) copied, 5.61811 s, 18.7 MB/s
> 104857600 bytes (105 MB) copied, 5.57817 s, 18.8 MB/s
>=20
> FSG_NUM_BUFFERS 4
> 104857600 bytes (105 MB) copied, 5.26839 s, 19.9 MB/s
> 104857600 bytes (105 MB) copied, 5.2691 s, 19.9 MB/s
> 104857600 bytes (105 MB) copied, 5.2711 s, 19.9 MB/s
>=20
> There may not be one optimal number for all boards. This is why
> the number is added to Kconfig.
>=20
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>

would it make sense to have this as a module parameter so we don't need
to recompile the driver everytime we want to test the driver with a
different number of buffers ??

Alan ?

--=20
balbi

--tDYGg60iReQ7u8wj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJORPBkAAoJEAv8Txj19kN1PH4H/RevDiTDtzhR+zOREnUN6A8t
tjrl7LOm0v4ReMRPXzdgRyNRXmHZ8KW5X1n2or+pvv7s3RJhagS1up8K38jEvnz6
U3wqcx8EmeAdYmIuyuABuOx64/QkCPU9B5qK9l7x7jqQPL9WIKGrPRg2lwimbKwv
ltvPYDUkkiK8YhFMkUwSt+/DEfpRla05FOSagyfEBvEdzEFqON40/fMYo46OVNiS
MKUXnlCdwYQvJWNPxbtAgtVRERuV88RbW/cv/3aCItqB3DKD7EzX4Y+C1BSLkhQs
mRTFurfh73Y2yyBE3DhMzJt2cejiMDBgO3666Y1hhNQgKEt7GuwoH4eR6YAnM3E=
=pp89
-----END PGP SIGNATURE-----

--tDYGg60iReQ7u8wj--
