Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab2HULGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:06:50 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:53663 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756872Ab2HULGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:06:46 -0400
Date: Tue, 21 Aug 2012 14:02:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: balbi@ti.com, alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>
Subject: Re: [RFC/PATCH 10/13] serial: omap: stick to put_autosuspend
Message-ID: <20120821110245.GY10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
 <1345540555-24359-11-git-send-email-balbi@ti.com>
 <CAMQu2gzm4z8DbCiz4hOS2nKa2HzNofmp=SPORYEu2Z_H3+JN9Q@mail.gmail.com>
 <20120821105702.GX10347@arwen.pp.htv.fi>
 <CAMQu2gzJ2YksrJKPLNZ9pBoBoSih2Up=isca=X9Wsd5MsnNrTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FvpZCdL3V2P9482l"
Content-Disposition: inline
In-Reply-To: <CAMQu2gzJ2YksrJKPLNZ9pBoBoSih2Up=isca=X9Wsd5MsnNrTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FvpZCdL3V2P9482l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 04:35:26PM +0530, Shilimkar, Santosh wrote:
> On Tue, Aug 21, 2012 at 4:27 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Tue, Aug 21, 2012 at 04:12:11PM +0530, Shilimkar, Santosh wrote:
> >> On Tue, Aug 21, 2012 at 2:45 PM, Felipe Balbi <balbi@ti.com> wrote:
> >> > Everytime we're done using our TTY, we want
> >> > the pm timer to be reinitilized. By sticking
> >> > to pm_runtime_pm_autosuspend() we make sure
> >> > that this will always be the case.
> >> >
> >> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> >> > ---
> >> >  drivers/tty/serial/omap-serial.c | 33 ++++++++++++++++++++++-------=
----
> >> >  1 file changed, 22 insertions(+), 11 deletions(-)
> >> >
> >> > diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/o=
map-serial.c
> >> > index 6ea24c5..458d77c 100644
> >> > --- a/drivers/tty/serial/omap-serial.c
> >> > +++ b/drivers/tty/serial/omap-serial.c
> >> > @@ -164,7 +164,8 @@ static void serial_omap_enable_ms(struct uart_po=
rt *port)
> >> >         pm_runtime_get_sync(up->dev);
> >> >         up->ier |=3D UART_IER_MSI;
> >> >         serial_out(up, UART_IER, up->ier);
> >> > -       pm_runtime_put(up->dev);
> >> > +       pm_runtime_mark_last_busy(up->dev);
> >> > +       pm_runtime_put_autosuspend(up->dev);
> >> >  }
> >> >
> >> Can you please expand the change-log a bit ?
> >> Didn't follow the time re-init part completely.
> >
> > It's really just a micro-optimization. The thing is:
> >
> > if I call pm_runtime_put(), I will not reinitialize the pm timer to
> > whatever timeout value I used. This means that pm_runtime_put() could
> > actually execute right away (if timer was about to expire when I called
> > pm_runtime_put()). While this wouldn't cause any issues, it's better to
> > reinitialize the timer and make sure if there's another
> > read/write/set_termios/whatever coming right after this, UART is still
> > powered up.
> >
> > I mean, it's really just trying to avoid context save & restore when
> > UART is still under heavy usage.
> >
> > Does it make sense ?
>=20
> It does. Would be good to add the above description in the change-log.
> Thanks for clarification.

will do, cheers

--=20
balbi

--FvpZCdL3V2P9482l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM2rVAAoJEIaOsuA1yqREnmsP/1IpIFOoPyNLdEdK7Pr4LVK4
Rz05v9c3Qth9OY7xp+hBQvqxoQRgRX/wgf8Sxokq1ITJjeaMFTnyZ/ACfqLq4r+U
R6DYm4K953S2VUEkpVfSKAbbGWItySxUsu+aX5UdkZZwgP7Ww08cymfpBM7Wi5EC
hbyLNrytSBl9PtEtYokftAjhieBxb9RJFkHPbXsWywUfBeXdpBm80suN0vMaEM2r
8+AVwUe5WBm1rFBuOCHg47IrLj0Ne3CWRTelH8MGVxqsldonMenEDOKERZVkm0vu
o/4ws0/AkhvST8fj32bkXLqjryRWiyV/xgxP4pLH/0ZC6Pee6f1+kt27fjQzgKsb
Z7/ISYmiPPGw8NJFW+uLWP6fiaer4+jV+dNRv0ux9zB/JKt2jhVIQJsxnPEuIgLe
g//epHPX8/OEuQiSowKhlvrAQWyoq+RvzCfn5Gr+pbSfP7fpu5j+SSlpSWMA+T64
wyuc0djDXXRGCkOLgIdZB1xEf1pu+Y4/lBAz0s/DgDYL9uqnXPMgaJablekutuzS
452gnVcyP8e6BBGadOOzXI8wGhKPUK09vK5uZuJ4LY+9XYO04JH5s5qVQl2wnagz
fQi9jJaocYZ+XREj7/LguujEqpRRY8rMo6QcaX/CywVKu8l9YC4uqWJkeg9hl3CM
JojabHQ7hzy++oQgi18/
=qGwW
-----END PGP SIGNATURE-----

--FvpZCdL3V2P9482l--
