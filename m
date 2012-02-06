Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab2BFKcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 05:32:10 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:50956 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753616Ab2BFKcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 05:32:07 -0500
Date: Mon, 6 Feb 2012 12:31:59 +0200
From: Felipe Balbi <balbi@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Felipe Balbi <balbi@ti.com>,
        "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH/RFC] usb: fix renesas_usbhs to not schedule in atomic
 context
Message-ID: <20120206103158.GK15652@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
 <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de>
 <4F22624E.2090201@renesas.com>
 <Pine.LNX.4.64.1201270946150.32661@axis700.grange>
 <4F27CA7D.601@renesas.com>
 <Pine.LNX.4.64.1202022317560.13860@axis700.grange>
 <4F2B9F34.60308@renesas.com>
 <Pine.LNX.4.64.1202031623000.6211@axis700.grange>
 <20120205145358.GA13762@legolas.emea.dhcp.ti.com>
 <Pine.LNX.4.64.1202061058430.10363@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="73fGQZLCrFzENemP"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1202061058430.10363@axis700.grange>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--73fGQZLCrFzENemP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 06, 2012 at 11:11:45AM +0100, Guennadi Liakhovetski wrote:
> Hi Felipe
>=20
> On Sun, 5 Feb 2012, Felipe Balbi wrote:
>=20
> > Hi,
> >=20
> > On Fri, Feb 03, 2012 at 04:43:20PM +0100, Guennadi Liakhovetski wrote:
> > > The current renesas_usbhs driver triggers
> > >=20
> > > BUG: scheduling while atomic: ksoftirqd/0/3/0x00000102
> > >=20
> > > with enabled CONFIG_DEBUG_ATOMIC_SLEEP, by submitting DMA transfers f=
rom=20
> > > an atomic (tasklet) context, which is not supported by the shdma dmae=
ngine=20
> > > driver. Fix it by switching to a work. Also simplify some list=20
> > > manipulations.
> >=20
> > you are doing much more than what you say.
>=20
> Are those two list macro changes what you refer to as "a lot?" ;-) You're=
=20
> right in principle, they are not directly related to the purpose of this=
=20
> patch, they are just something that occurred to me, while tracking down=
=20
> DMA packets. But yes, it can be extracted to a separate cosmetic patch...

please do so ;-)

> > Also, instead of using a
> > workqueue, have you considered using threaded_irqs ?
> >=20
> > (I didn't go over the driver again to see if it makes sense to use
> > threaded_irqs in this case, but doesn't hurt asking)
>=20
> From a first glance these tasklets are not directly enough related to=20
> IRQs, so, doing that is either impossible, or would require a _much_=20
> deeper change to the driver and _this_ would indeed be a much bigger=20
> change than just fixing the Oops.

I see.. so please just split the list changes to separate patch and
resend.

--=20
balbi

--73fGQZLCrFzENemP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPL6weAAoJEIaOsuA1yqRE+ZIP/RXcXb6Ngvg56+KXRbkDSjz+
JC4osfRUhv70f8rIJNeKKoX/ZgAJ1DkBu/bGimR+j8h6cNzsRe/NCRUc0rwbiEAk
/OYU5C2j9r8zyJD6x/1J3+ipClh6t5EPmrZPOJJOol4UnPdmBFjMBEQ1urON9ZVV
c28/lL16973n966Rn+nzEHJEVPlhCx7UN02YxY6OJILP9+jXdLvJZ1PQhRO3ydwp
2GGNtYKguMXpk4fEI32NvyhT7Bh2eYE8SejooJpTcHEUHLDSHc8gV/OGnUsdfEld
5Kj5HNKrMzaMl8JlisM+q/yD1tjYqwAyAH9dh5svRGpPQwhbtSmwoU4xuU09XWi0
vPig5ceSnDZWQKFCSMfz2Srmw+c8isz+bQ/GffEO0zT3C7icMLqo2iY+2DmF6UTV
a6DQkr2KG4+Ng5A01HelIDLs6iYcuHItATT08l3rZnMWOcUxYupPr6rF7c8QHq6v
1g64HapmsmKKplFNI6U3PdqHKHO8OU9QXAYq0goem12vLf43pTr+H+StQxO08YLp
Q6QBVpY8zKF9ZjQ+jAxutvFk2H7OO+2ufSrKTwB+QcWhlw/aUrv0apuUOlXXdSO7
WGTev0cxEKCJrR5cNM7aLDE3pFFkQf+n+EleUiq2XzJ5IphKXLQo3iFh53WjfnQt
mXUhc3tmrRXvKj+GmoF4
=gLHG
-----END PGP SIGNATURE-----

--73fGQZLCrFzENemP--
