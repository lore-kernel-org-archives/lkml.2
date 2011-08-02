Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1HBWuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:50:55 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:40757 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349Ab1HBWus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:50:48 -0400
Date: Wed, 3 Aug 2011 01:50:42 +0300
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: balbi@ti.com, Jesper Juhl <jj@chaosbits.net>,
        LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH][Resend] Remove unneeded version.h includes (and add
 where needed) for drivers/usb/
Message-ID: <20110802225041.GA10284@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <alpine.LNX.2.00.1108012329380.31999@swampdragon.chaosbits.net>
 <20110802211923.GB10120@legolas.emea.dhcp.ti.com>
 <201108030011.54322.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <201108030011.54322.laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On Wed, Aug 03, 2011 at 12:11:53AM +0200, Laurent Pinchart wrote:
> Hi Felipe,
>=20
> On Tuesday 02 August 2011 23:19:24 Felipe Balbi wrote:
> > On Mon, Aug 01, 2011 at 11:33:29PM +0200, Jesper Juhl wrote:
> > > It was pointed out by 'make versioncheck' that linux/version.h was not
> > > always being included where needed and sometimes included needlessly
> > > in drivers/usb/.
> > > This patch fixes up the includes.
> > >=20
> > > For the UVC gadget driver bits, this was ACK'ed by Laurent Pinchart.
> > >=20
> > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > >=20
> > >  drivers/usb/gadget/uvc.h         |    1 +
> > >  drivers/usb/gadget/uvc_v4l2.c    |    1 -
> > >  drivers/usb/storage/realtek_cr.c |    1 -
> > >  3 files changed, 1 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
> > > index 5b79194..81971fb 100644
> > > --- a/drivers/usb/gadget/uvc.h
> > > +++ b/drivers/usb/gadget/uvc.h
> > > @@ -56,6 +56,7 @@ struct uvc_event
> > >=20
> > >  #include <linux/usb.h>	/* For usb_endpoint_* */
> > >  #include <linux/usb/gadget.h>
> > >  #include <linux/videodev2.h>
> > >=20
> > > +#include <linux/version.h>
> >=20
> > does uvc.h really needs <linux/version.h> ?? Laurent ?
>=20
> uvc.h has
>=20
> #define DRIVER_VERSION_NUMBER                   KERNEL_VERSION(0, 1, 0)
>=20
> This is used in drivers/usb/gadget/uvc_v4l2.c only.
>=20
> As the uvc gadget driver lives in-tree, the best fix is probably to remov=
e=20
> DRIVER_VERSION_NUMBER completely, and replace it with LINUX_VERSION_CODE =
where=20
> it is used.

yeah, I can agree with that, but do you need a MODULE_VERSION() anyway ?
Would it be better to just remove the MODULE_VERSION altogether as
there's no real benefit from having it ?

--=20
balbi

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOH9BAAoJEAv8Txj19kN1+88H/jH+9/fwg8DgGksH1bZct50I
rXYg0XyninWFDY0fc/Im3hGwFFUeCKd4PGE6+8KRWAjZfrQ2LmnsLR6v7IqaAKQY
B7o8DkFksaVw+YxgNXVjC3SrZPOf3ZN0ENQvKDZamoSxkUVRE74exeGxb0tTCbW8
gYgwUAMSUI48jPoMMPew4+baHMeG4P6Ee/ZZHi1+/YAgS7kzoYHDxUDEw5R6WQA+
ewFrjODz14kwTOmu2utPHJOOQGsCYxN3GsDmDGsI7TtzL+KIFtv1mJGapUTUh6uV
88uQg5iYxFFolB1Ea2RWQD/BWpLd6lfk6jcABjJrfoZnE6X+Fx2f4QBf7n23hco=
=3oiv
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
