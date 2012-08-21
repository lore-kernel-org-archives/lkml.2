Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab2HULBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:01:05 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:51690 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756253Ab2HULBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:01:01 -0400
Date: Tue, 21 Aug 2012 13:57:03 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, alan@linux.intel.com,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>
Subject: Re: [RFC/PATCH 10/13] serial: omap: stick to put_autosuspend
Message-ID: <20120821105702.GX10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
 <1345540555-24359-11-git-send-email-balbi@ti.com>
 <CAMQu2gzm4z8DbCiz4hOS2nKa2HzNofmp=SPORYEu2Z_H3+JN9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aSOv3uy5xJSQbCk1"
Content-Disposition: inline
In-Reply-To: <CAMQu2gzm4z8DbCiz4hOS2nKa2HzNofmp=SPORYEu2Z_H3+JN9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aSOv3uy5xJSQbCk1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 04:12:11PM +0530, Shilimkar, Santosh wrote:
> On Tue, Aug 21, 2012 at 2:45 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Everytime we're done using our TTY, we want
> > the pm timer to be reinitilized. By sticking
> > to pm_runtime_pm_autosuspend() we make sure
> > that this will always be the case.
> >
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  drivers/tty/serial/omap-serial.c | 33 ++++++++++++++++++++++-----------
> >  1 file changed, 22 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap=
-serial.c
> > index 6ea24c5..458d77c 100644
> > --- a/drivers/tty/serial/omap-serial.c
> > +++ b/drivers/tty/serial/omap-serial.c
> > @@ -164,7 +164,8 @@ static void serial_omap_enable_ms(struct uart_port =
*port)
> >         pm_runtime_get_sync(up->dev);
> >         up->ier |=3D UART_IER_MSI;
> >         serial_out(up, UART_IER, up->ier);
> > -       pm_runtime_put(up->dev);
> > +       pm_runtime_mark_last_busy(up->dev);
> > +       pm_runtime_put_autosuspend(up->dev);
> >  }
> >
> Can you please expand the change-log a bit ?
> Didn't follow the time re-init part completely.

It's really just a micro-optimization. The thing is:

if I call pm_runtime_put(), I will not reinitialize the pm timer to
whatever timeout value I used. This means that pm_runtime_put() could
actually execute right away (if timer was about to expire when I called
pm_runtime_put()). While this wouldn't cause any issues, it's better to
reinitialize the timer and make sure if there's another
read/write/set_termios/whatever coming right after this, UART is still
powered up.

I mean, it's really just trying to avoid context save & restore when
UART is still under heavy usage.

Does it make sense ?

--=20
balbi

--aSOv3uy5xJSQbCk1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM2l9AAoJEIaOsuA1yqREOREP/ivk3823JJxSK6DjQzENC1JY
qa3/jyWz4Qw1QF8byNz/vnj8qh8OWPeszjguPSc6jA1z3HuphM1f6uyFULPWthec
ENms6I8KgmY9rjfc7VFuYRZduT8jkqzuPHuDDmTQOsF+hclhEqtsZjhcC4orgzMo
UhUWXAZvR84i++3PbZO4gRLmhq8gDRUEzRhrJhmSXrpphL8buzoomjxkM4/aY4mv
APQMUjJTP4NwjsKk/Iur/O3EI5qpvwIX4T0tRt8vygazhBX6NSBUlQI+we9ZZoZR
/xMRLcN8XSLhvi6kC9B7cWbe5jJTpHcTqxxmOxv09fS/+gjm+JyHiu7wnNfapw1r
cN3x8/khAc8mCbFTBnQzW2v/aRCAr1dUZSmICNjvXo9T0LhjGiSfFQvnPymvjyDH
GIBmni0lng4FZPhBSmxKSVCHjP+P1jHRfAKsZVM1vhQbFLhS2S9jR7rhNCwlV5qh
GlWct2qzbfxyFf3eNQFEoKN1e4XZbUERGHBCZAdM5vVKZJ3B3QEsUMKzP1EEwgfU
NIPAWq3kG6Pc5K70T6MFncyQ7pNrpAlZJTTVJ5ibb3SVxImYrEksbBD5nsDtQybK
1IEC46fgG7/TMVDKLZX30boUuZsCWPbOz/LVufDS8kfsPg48IbYXDVSEbhB3ozvf
/a9DOxgw9sp3Pp3gJI6S
=gqc5
-----END PGP SIGNATURE-----

--aSOv3uy5xJSQbCk1--
