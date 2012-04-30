Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab2D3Xr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 19:47:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704Ab2D3Xrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 19:47:55 -0400
Date: Tue, 1 May 2012 09:47:52 +1000
From: NeilBrown <neilb@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org,
        linux-pm@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Question:  How to power-manage UART-attached devices.
Message-ID: <20120501094752.2ea16f23@notabene.brown>
In-Reply-To: <4F9F178F.3030408@zytor.com>
References: <20120501082209.0b560708@notabene.brown>
	<4F9F178F.3030408@zytor.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6CZD60Y87et=6XsCWpSm57o"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6CZD60Y87et=6XsCWpSm57o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Apr 2012 15:51:59 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 04/30/2012 03:22 PM, NeilBrown wrote:
> >=20
> > What I would really like is to integrate it closely with the state
> > of the UART.  i.e. if the /dev/ttyO1 device is open, then the GPS
> > is "on".  If not then it is "off".  Similarly if /dev/tty/O0 is
> > open, bluetooth is "on", else "off". However I cannot find any way
> > to "plug in" to the tty or serial drivers to perform an arbitrary
> > action on first-open or last-close.  Is something like that
> > possible? If not, is it a reasonable thing to ask? Any suggests
> > about where to put such a hook?
> >=20
>=20
> I don't think that's the right interface.  Just because the port is
> currently open doesn't mean the device is active, nor vice versa.  ALL
> it means is that someone currently has an access handle to it.
>=20
> Since a serial port models, well, a *port*, it is logical to think of
> a (hypothetical) socket containing an RS-232 connector as well as a
> power outlet.  Given that, it would be logical to drive the "power
> connector" using the same type of interface used for the other parts
> of an RS-232 control, meaning either with termios flags or via a
> dedicated control ioctl (TIOCPOWER?).
>=20
> 	-hpa

Hi Peter,

 I agree that in general there is not necessarily a 1-1 correspondence betw=
een
 "device file is open" and "device is powered", however I think that in a l=
ot
 of real cases it is a very natural correspondence.=20

 In my bluetooth case, there is nothing useful that the device can do if
 hciattach isn't running and listening to the device, so it may as well be
 off.
 For GPS it is less clear as the GPS could maintain state (current almanac
 and ephemeris) and could even periodically tune in to the satellites and
 update this state (though as mine cannot power on/off the antenna that
 second case might not be very useful).  This particular GPS device does not
 lose state when I toggle the 'on/off' line.  It just stops sending
 information (and maybe stops doing calculations, I don't know).  And that =
is
 exactly what I want to happen when the tty device is closed.

 I imagine this proposal as being like a virtual DTR line.  It may not alwa=
ys
 be appropriate to connect DTR to the power switch, but sometimes it is.

Thanks,
NeilBrown

--Sig_/6CZD60Y87et=6XsCWpSm57o
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT58kqDnsnt1WYoG5AQJmKA/9Hz0EhlXqWXtD6TZxneU9JykQyn+j7bEV
JeOk+9xyPOnwNxxj5oRotFDLX00ynUF75MEW9RTtCmYvr3ZvZcV6pxsxobvriTff
tqW5kb0EiZGgKCFKcT7kjwoyUdBoHdYA5/a5EcoFEVsMQwZibYN9zEgg9g6LWK0a
KM3wPOJdsWd0rUCdPOcxQ46HpScRpL98IMpytT/GwkvfvCfq3bLXgxu4/D9mIwBN
yDIvl31M7phP41lvJoANN76skhKMHkKL8t5Ve2fR6e+bs3/o9vD7xX/MfaUscCZW
yV0ilXyvCXdE5TeU+teTpbaDPedeMhPr3rdB7qL542qsT0E4DkM/D99o+eFwgDn5
0TUbbziHcmye664ToUiSKm+jyrOFudZrle1i0mFD4Z7JWNI/bfTJIpf84L+Gdezo
+WYYfWfVOC36+wW5hKQMbUmcZ3cZLKOZk4JCjtYTaFpczqu+ApWL/JCAj6Fpf8wl
Ppy6S54RBS8kBC9p7yw03D5Ee+8XUcG1OMUWFFfFmnKZM87c0znlapcqfSH/WGFZ
ZTEyPRRkioT81vVxbK+gnDoZViTm7xeVdG5yVMglNzcrM0d03k9/4b9tpYJq0Ee0
YsBGIQinUHLh7i9kziM/nn5ROGHm2wUzMArmB5oGgOEgicJR1MZI0ugxljlzr2m2
eKJv5xAYiCk=
=OZkI
-----END PGP SIGNATURE-----

--Sig_/6CZD60Y87et=6XsCWpSm57o--
