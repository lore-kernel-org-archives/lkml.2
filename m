Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab1HRLOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:14:08 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:34718 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755527Ab1HRLOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:14:04 -0400
Date: Thu, 18 Aug 2011 14:14:00 +0300
From: Felipe Balbi <balbi@ti.com>
To: Per Forlin <per.forlin@stericsson.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <mina86@mina86.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Per Forlin <per.forlin@linaro.org>
Subject: Re: [PATCH v4] usb: gadget: storage_common: make FSG_NUM_BUFFERS
 variable size
Message-ID: <20110818111359.GR14514@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1313659726-9406-1-git-send-email-per.forlin@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SWsnvgFfkTS2ATo5"
Content-Disposition: inline
In-Reply-To: <1313659726-9406-1-git-send-email-per.forlin@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SWsnvgFfkTS2ATo5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 18, 2011 at 11:28:46AM +0200, Per Forlin wrote:
> From: Per Forlin <per.forlin@linaro.org>
>=20
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
> the number is added to Kconfig. If selecting USB_DEBUG this value may be
> set by a module parameter as well.
>=20
> Signed-off-by: Per Forlin <per.forlin@linaro.org>

Alan, are you ok with the change ? I'm not sure tying the parameter to
CONFIG_USB_DEBUG is a good idea, maybe CONFIG_USB_GADGET_DEBUG or
CONFIG_USB_FILE_STORAGE_TEST is better ?

--=20
balbi

--SWsnvgFfkTS2ATo5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTPP3AAoJEAv8Txj19kN1I88H/2D1ImSWKynROeXmE/Xhujcs
r+L72gZ7bkdGWaZZf2GXeXirb5MJpREB3vl7brD/K4EckOQPG+npvz2jQT0c1z8D
hDFM6Tbk71Yit3NPOa2pqGH9cr+jeNTZeqT+4pfIP2NosZM/dnbJDTWhjntN0GkA
WeyjqlP5Y0euLBd7ct3Y+h6V2On14yAUWjCA9Ev26JBNNuMmRqU6PdOhhU0Wd+Ls
GCOudzVpkqeS6VWUk3Pifl4Qgna2oD5aVoYDZSgHi2lFPeRCssPpiLVUzNJ8/v/p
h6N7hYGp+QIlpFmYnoga4KR8u99MyE7s1luQCpSDzzEIphlImBC92rtYA4/MRLw=
=s0af
-----END PGP SIGNATURE-----

--SWsnvgFfkTS2ATo5--
