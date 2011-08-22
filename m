Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab1HVLWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 07:22:07 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:57850 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022Ab1HVLWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 07:22:00 -0400
Date: Mon, 22 Aug 2011 14:21:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v6] usb: gadget: storage: make FSG_NUM_BUFFERS variable
 size
Message-ID: <20110822112153.GA30398@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1313781687-13955-1-git-send-email-per.forlin@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <1313781687-13955-1-git-send-email-per.forlin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 19, 2011 at 09:21:27PM +0200, Per Forlin wrote:
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
> Measurements on a Snowball board with ondemand_governor active.
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
> the number is added to Kconfig. If selecting USB_GADGET_DEBUG_FILES
> this value may be set by a module parameter as well.
>=20
> Signed-off-by: Per Forlin <per.forlin@linaro.org>

applied, thanks.

--=20
balbi

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOUjvRAAoJEAv8Txj19kN1gAAIAJ7EY2l+E0ucdMc5iAXEP6Y/
5NtnAOyA9Qec1OZO0+CcgPJpbYLTj49WFD161F8UqIMOYPVyCtasK5OG4uIKMQOY
o6CoCGAWFTzpvCyw6ZhQsa9hilUNVTKD5Ti1AehvyrZRmBIf+pOB/7zEUFQeU0Hj
6f1v2jImjnK6TckW+QBAu94rdpWT4+BA9V7HbRcg2W+VmkK2T4VdEzRFvPHUfYA1
oMg3KxkOl8qo5ZEh9WgIU4o7j53cd4xKd/vUprNbJ19Iy9rH0JZazxDAZQAOnr1m
aJbQZzT9SwpGhjYaCWrWRIP7rR8aYF77lO8h9inPSk5A0BwcTq9WpwWlgAXN1qY=
=qbpZ
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
