Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab1HIOwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:52:03 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:55744 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771Ab1HIOwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:52:01 -0400
Date: Tue, 9 Aug 2011 17:51:55 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Per Forlin <per.forlin@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH v3] usb: gadget: storage_common: make FSG_NUM_BUFFERS
 variable size
Message-ID: <20110809145154.GA32212@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1312839815-30886-1-git-send-email-per.forlin@linaro.org>
 <Pine.LNX.4.44L0.1108090957020.1949-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aZaBog0ly0buBYah"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1108090957020.1949-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aZaBog0ly0buBYah
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 09, 2011 at 09:57:19AM -0400, Alan Stern wrote:
> On Mon, 8 Aug 2011, Per Forlin wrote:
>=20
> > FSG_NUM_BUFFERS is set to 2 as default.
> > Usually 2 buffers are enough to establish a good buffering pipeline.
> > The number may be increased in order to compensate a for bursty VFS
> > behaviour.
> >=20
> > Here follows a description of system that may require more than
> > 2 buffers.
> >  * CPU ondemand governor active
> >  * latency cost for wake up and/or frequency change
> >  * DMA for IO
> >=20
> > Use case description.
> >  * Data transfer from MMC via VFS to USB.
> >  * DMA shuffles data from MMC and to USB.
> >  * The CPU wakes up every now and then to pass data in and out from VFS,
> >    which cause the bursty VFS behaviour.
> >=20
> > Test set up
> >  * Running dd on the host reading from the mass storage device
> >  * cmdline: dd if=3D/dev/sdb of=3D/dev/null bs=3D4k count=3D$((256*100))
> >  * Caches are dropped on the host and on the device before each run
> >=20
> > Measurements on a Snowball board with ondemand_govenor active.
> >=20
> > FSG_NUM_BUFFERS 2
> > 104857600 bytes (105 MB) copied, 5.62173 s, 18.7 MB/s
> > 104857600 bytes (105 MB) copied, 5.61811 s, 18.7 MB/s
> > 104857600 bytes (105 MB) copied, 5.57817 s, 18.8 MB/s
> >=20
> > FSG_NUM_BUFFERS 4
> > 104857600 bytes (105 MB) copied, 5.26839 s, 19.9 MB/s
> > 104857600 bytes (105 MB) copied, 5.2691 s, 19.9 MB/s
> > 104857600 bytes (105 MB) copied, 5.2711 s, 19.9 MB/s
> >=20
> > There may not be one optimal number for all boards. This is why
> > the number is added to Kconfig.
> >=20
> > Signed-off-by: Per Forlin <per.forlin@linaro.org>
> > Acked-by: Michal Nazarewicz <mina86@mina86.com>
>=20
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Thanks.

Hijacking this thread for a small note. I'll be back on applying patches
this friday. Until then I'll be focussed on some other issues which
we're tracking down.

Thanks for understanding ;-)

--=20
balbi

--aZaBog0ly0buBYah
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOQUmKAAoJEAv8Txj19kN1XfMH/3vvnIKIsiU1sdgnQjauGZY3
RmdqLwmh8H5cW6U7vE/636UJe9dlwmkV/NtL5vFpkxssWOUaJQTsH8/4MQwRB3k6
GyO2UAg+Wk9yj73kExD7LapXl14auRRimgAbEgzdgK0blMMX1IL4iaw9NyVhdfd/
9NCPOL2y3gS19is/XnRF0yWbn2XnUvK2ittomJoYl3xAazocT7zJQ4xTT7S4vDf2
jJ6HOylPPa2k1Acz4GErfbG/cbX/RSN//fPddMf18Envdu7ylbLsGctV24cKjfYq
AlDJQ4Vh1UuT/MvLkp8UIm2216x98v0RQ0s4G9WbRxxTquQ0k+WTq/tyEMGraxE=
=p3mW
-----END PGP SIGNATURE-----

--aZaBog0ly0buBYah--
