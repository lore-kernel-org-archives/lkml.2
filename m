Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab1LNHaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:30:11 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:46336 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752785Ab1LNHaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:30:08 -0500
Date: Wed, 14 Dec 2011 09:30:01 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: balbi@ti.com, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Heikki Krogerus <heikki.krogerus@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] Revert "ARM: RX-51: Enable isp1704 power on/off"
Message-ID: <20111214073000.GB11024@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>
 <1323105820-25946-3-git-send-email-felipe.contreras@nokia.com>
 <CAMP44s3Szzm9iXxghXfNCBjKyUw-nRrG1aEeweKnRCidaxmxEA@mail.gmail.com>
 <4EDF5231.6080309@bitmer.com>
 <CAMP44s0a6hcORZn8wDxHUJKxs=wjAmkhRfiT9kEA_MoDYeAmfg@mail.gmail.com>
 <4EE5A8A0.2010206@bitmer.com>
 <CAMP44s1Zz7CqxRM6PeNT3GN9GbCLy+0smgk6_-9kSjghY33Xuw@mail.gmail.com>
 <20111213225308.GB10066@legolas.emea.dhcp.ti.com>
 <CAMP44s3Gmx1M40Dae-RR3+i=vv-d0Ls6h3YToRuUnMTFoqeSCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <CAMP44s3Gmx1M40Dae-RR3+i=vv-d0Ls6h3YToRuUnMTFoqeSCQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Wed, Dec 14, 2011 at 01:02:09AM +0200, Felipe Contreras wrote:
> On Wed, Dec 14, 2011 at 12:53 AM, Felipe Balbi <balbi@ti.com> wrote:
> > On Tue, Dec 13, 2011 at 11:19:52PM +0200, Felipe Contreras wrote:
> >> On Mon, Dec 12, 2011 at 9:09 AM, Jarkko Nikula <jarkko.nikula@bitmer.c=
om> wrote:
> >> > Indeed yes. I checked that in 3.0 it still works but not in 3.1 so s=
ome
> >> > non isp1704_charger change has broke it as there hasn't been changes=
 on it.
> >>
> >> Actually it's broken in 3.0 as well, try this configuration:
> >>
> >> =A0 =A0 =A0 # CONFIG_USB_MUSB_HOST is not set
> >> =A0 =A0 =A0 # CONFIG_USB_MUSB_PERIPHERAL is not set
> >> =A0 =A0 =A0 CONFIG_USB_MUSB_OTG=3Dy
> >> =A0 =A0 =A0 CONFIG_USB_GADGET_MUSB_HDRC=3Dy
> >> =A0 =A0 =A0 CONFIG_USB_MUSB_HDRC_HCD=3Dy
> >>
> >> =A0 =A0 =A0 CONFIG_USB_GADGET_SELECTED=3Dy
> >> =A0 =A0 =A0 # CONFIG_USB_GADGET_FUSB300 is not set
> >> =A0 =A0 =A0 # CONFIG_USB_GADGET_OMAP is not set
> >> =A0 =A0 =A0 # CONFIG_USB_GADGET_R8A66597 is not set
> >> =A0 =A0 =A0 # CONFIG_USB_GADGET_PXA_U2O is not set
> >> =A0 =A0 =A0 # CONFIG_USB_GADGET_M66592 is not set
> >> =A0 =A0 =A0 # CONFIG_USB_GADGET_DUMMY_HCD is not set
> >>
> >> I will try to find where the issues started to happen, but it's a bit
> >> difficult because all this USB Kconfig stuff is completely messed up.
> >>
> >> *Sigh*
> >
> > patches are welcome
>=20
> The were not last times:
> http://mid.gmane.org/1288656853-4625-1-git-send-email-felipe.contreras@gm=
ail.com

At least [1] will not apply anymore. Most of that stuff has been cleaned
up after I introduced the UDC class/core driver. There are still lots of
things to fix up, but it won't happen overnight. Specially if people are
more willing to complain than to patch.

[2] Makes no sense whatsoever. I have been fighting a lot against these
ARCH dependencies. It's generally used to hide some moronic constructs
relying on <plat/*> or <mach/*> headers. Most of the time, it's just to
be able to access e.g. machine_is_*, cpu_is_* or omap_ctrl_read* and the
like. Also, the first step for having a single ARM zImage is to get rid
of those ARCH dependencies; we need to be able to compile modules on all
ARCHes (even x86 for that matter) because:

a) it makes maintainer's lives easier (make allmodconfig/allyesconfig
really help when applying patches)

b) it helps using linux-next for compile tests better (similar as above)

c) it makes it simpler to have a single zImage (from that particular
driver's point of view, you can delete
arch/arm/plat-omap/include/plat/*.h and nothing will change).

So, if those are the only patches you can provide, please refrain from
doing so as it will only take time reviewing. Instead, help really
cleaning up the problems, make sure drivers compile on other ARCHes,
make sure you don't include <plat/*> or <mach/*> on drivers, make sure
you help reviewing patches which are coming in.

> http://mid.gmane.org/1287482608-11320-1-git-send-email-felipe.contreras@g=
mail.com

"No such article"

> But I'll try again... Once I'm done with this endless bisect =3D/

please do, but follow the above.

[1] http://article.gmane.org/gmane.linux.kernel/1056944
[2] http://article.gmane.org/gmane.linux.ports.arm.omap/45713

--=20
balbi

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO6FB3AAoJEIaOsuA1yqREJfoP/3/Vq9nEABFeIpeIxj6bFVxO
Mp1fV4totx6jWcp9RtDmpG37wD6b/QOh6+3x7eyFO+sZjA886aeEnwD1K+LTOsYo
237iOJgH6dIDjM6rUefUGqAgo4zRzsnIe5jjzUCdbQ7UDncX+36N3w+KRqUUUCWP
Ul6i70DO5BU3ZP3wsmTP4hJl3aPqTO8uHxDZnh2Wuxrc+DAmiO46jPdR78/yeN3t
13GEHYLoMAQm12/I2yFH7+9qLcv5lKFw28nx4qQOnzxRobYgfGo1gjO6PWny/rS3
HOizhbWBmoZqJ2slilLVbuENzyHM/smeSrL1ehIN2RWkngtbt6uv3HRMbqnSFIIZ
nDMG2/VYGJ1jszUzhR5V1RSzqAj41PzQ7ncfAYZ93y0Pskn2K/f8F2l6UtsshVuc
HfT3KYBs/ngrVuSDlSjwZt7MejbQBBbgHM9O9TP3ynxIZgAs2nePp3r9Nss4L5qc
Wl8mfrImU2b88BphaFVyWLh6tPN3E00AP1We4smBWpIe8+wGZ/e32xn7ql9nBeAv
u6QRh365NH1DPhNU5HoaESbqNlimiH0+5cRO2SmJ5cy799tgpi3jvXs2Bv7s6TKQ
RWyFPVvm6WJDAIRoEINQjCNv2H6YuhM1J7CzmCsjeXMvJ07v8udKyp4+5W+9xYzU
tifOCGczW04AtwDAl/FZ
=AwTX
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
