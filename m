Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880Ab1LOXwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:52:13 -0500
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:54557 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759766Ab1LOXwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:52:11 -0500
Date: Fri, 16 Dec 2011 01:52:06 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, stable@vger.kernel.org
Subject: Re: [PATCH] usb: musb: fix pm_runtime mismatch
Message-ID: <20111215235205.GB2242@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1323988934-11350-1-git-send-email-felipe.contreras@gmail.com>
 <20111215230225.GB26893@kroah.com>
 <20111215231103.GB27434@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
Content-Disposition: inline
In-Reply-To: <20111215231103.GB27434@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 15, 2011 at 03:11:03PM -0800, Greg KH wrote:
> On Thu, Dec 15, 2011 at 03:02:25PM -0800, Greg KH wrote:
> > On Fri, Dec 16, 2011 at 12:42:14AM +0200, Felipe Contreras wrote:
> > > In musb_init_controller() there's a pm_runtime_put(), but there's no
> > > pm_runtime_get(), which creates a mismatch that causes the driver to
> > > sleep when it shouldn't.
> > >=20
> > > This was introduced in 7acc619, but it wasn't triggered until 18a2689
> > > was merged to Linus' branch at point 6899608.
> > >=20
> > > However, it seems most of the time this is used in a way that keeps t=
he
> > > counter above 0, so nobody noticed. Also, it seems to depend on the
> > > configuration used.
> > >=20
> > > I found the problem by loading isp1704_charger before any usb gadgets:
> > > http://article.gmane.org/gmane.linux.kernel/1226122
> > >=20
> > > All versions after 2.6.39 are affected.
> > >=20
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> > > ---
> > >  drivers/usb/musb/musb_core.c |    2 --
> > >  1 files changed, 0 insertions(+), 2 deletions(-)
> >=20
> > Will you be including this in your next pull request for me to include
> > in my tree to go to Linus soon?
>=20
> Doh, wrong Felipe, my apologies.

hehe. To answer the previous question: I want to hash a few things out
first, so it's likely that it won't make it for the next pull request to
Linus. Guess I'll have to send this either on 3.3 merge window or after
that and, of course, Cc stable (as Felipe C. did)

--=20
balbi

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO6oglAAoJEIaOsuA1yqRE0TgP/AwDi8J3vz7Z7CDa1r5tpl5q
+AdIy0vTafRzqOn/3f9FkKVZhWOcLdEWarlSObN/9mtSbroTqbIbEtQ5yTI8DGP3
8/+IUGZZi/233JL9KPQXcXLbUXCdpugNBvxkP/+xtE4+4VNJvcsGBDxk+FZDuUfG
MBdaQZ4ObWuCWRBEd6g5EPeJUkGMJ3gRGRfAdNP4JGbslj3mmXaE3FzAAy13gXlg
2RMsWBWq1pd1yBCHGRH39gfZa1GXWxLuzxUlehIPbQ+PJR62hySL3GqOlCyVRIze
gZ3G/nGhOm5hGpoq6rrZ86TNbbr2h6403KxoMFAqHdSbd79gri+2ACyOtzNQ582K
yzHuV7ixXBrYFLy8y3TmRLlb7m+lGcWfIUHM8VjJan5mKuDsmF4ZaWNW8cRq3OYE
t6UaPQ3K7nRnre/dwTblBA6ZzPiAu/D3nWO8x+bTQfaijdZ7hcr2pthEyHcGoOgv
jfnYMlUqcGwNargw18A4K6aXxABU8O9bzQY1vlCRyJBkVoQljCkg9F2JzDzGJABq
zZg22RFjEpHTJwoRjLEuI8Jvho7d280VO1CRC3tCpNKa4j/ENB7Q2fFiGxxOTK86
tTyBR6LO4PWWrgWNi7MBXJkfQHv/i9e+mwxWRRFCHyXU7DyAjJ3PIIkj8atYFA5x
ugmfo39egXwkjzC3knDF
=RuE1
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--
