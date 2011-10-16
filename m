Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1JPWeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 18:34:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab1JPWeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 18:34:10 -0400
Date: Mon, 17 Oct 2011 09:34:01 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
Message-ID: <20111017093401.21cd4461@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1110161018580.28864-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1110152224461.19724-100000@netrider.rowland.org>
	<Pine.LNX.4.44L0.1110161018580.28864-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wVGzTUpHlzirOOXhvsIE6c3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wVGzTUpHlzirOOXhvsIE6c3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 16 Oct 2011 10:51:01 -0400 (EDT) Alan Stern
<stern@rowland.harvard.edu> wrote:

> On Sat, 15 Oct 2011, Alan Stern wrote:
>=20
> > Basically, what we need is a reliable way to intercept the existing
> > mechanisms for suspend/hibernate and to redirect the requests to the PM
> > daemon.  When the daemon is started up in "legacy" mode, it assumes
> > there is a legacy client (representing the entire set of
> > non-wakeup-aware programs) that always forbids suspend _except_ when
> > one of the old mechanisms is invoked.
>=20
> The more I think about this, the better it seems.  In essence, it=20
> amounts to "virtualizing" the existing PM interface.

While "virtualizing" does sound attractive in some way, I think it would be
the wrong thing to do.
In practice there is only one process at a time that is likely to suspend
the system.  I've just been exploring how that works.

gnome-power-manager talks to upowerd over dbus to ask for a suspend.
upowerd then runs /usr/sbin/pm-suspend.
pm-suspend then runs all the script in /usr/lib/pm-utils/sleep.d/
and the calls "do_suspend" which is defined in /usr/lib/pm-utils/pm-functio=
ns

Ugghh.. That is a very deep stack that is doing things the "wrong" way.
i.e. it is structured about request to suspend rather than requests to stay
awake.

Nonetheless, we only really need to worry about the bottom of the stack.
Rather than virtualize /sys/power/state, just modify pm-function, which
you can probably do by putting appropriate content
into /usr/lib/pm-utils/defaults.
Get that to define a do_suspend which interacts with the new suspend-daemon
to say "now would be a good time to suspend" - if nothing else is blocking
suspend, it does.

Put it another way:  power-management has always been "virtualized" via lots
of shell scripts in pm-utils (and various daemons stacked on top of that).
We just need to plug in to that virtualisation.

This is all based on gnome.  kde might be different, but I suspect that it
only at the top levels.  I would be surprised if kde and the other desktops
don't all end up going through pm-utils.

NeilBrown


--Sig_/wVGzTUpHlzirOOXhvsIE6c3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTptb2Tnsnt1WYoG5AQIuHQ//TnECLBnB6xvN3ShfW7jJj/9/NgfHb7f/
CSco/lUdlJ0G+Z5eTKqcTXaRmBli2JEw3WWzGJk+v+BvNheshZvD3nEVwCBVilvR
RNAZ0b1upbxUxp0/j5d5IG03vQHygLntSyIScDj4wQoZKNDCu5P++/PJAqIFF351
bnvKoKIQyiuZ97qJW4GlEQv9n7AKZ0SJsDUzI78a9Bf846hv9vG/dY3Dd7tfWSH0
kcrxQO7Sa5HFfgTKFK912qnHfbvBqvwCwgoQvjapZXq+rCr43B0XbdpbEEAbURZk
fhF6swmrbP9ESimIsP6vC7AlxJWEK0AJFxTZvuly86Bel2rHcUP/QL8jwpbigj+9
flIV6d6eOgCKR1sJ7V9MWQQki3lSjptLkMQgt96pESct4z46kexVcMAWue/0Ig4+
kz5VrjdrM3d4t7apUnuPdTKbIY9Qu3In9s3VGSdT1aLdbl8ZubxCuXCSGbGiHJz0
acz+tk8kV3gp2y9m+IcUXNQ96FWQ8ztVytBBobaCWoDBmIaU8hykKWuBxoiebTPO
hz/hPNZQee6YZK9BnQVwd0zPrqfz94nRZGtDTc4Tdi7jAkeueA+Szz/dKTN0sDiy
vXM5eqeUIxSkyeYgrMDyunEHeSIKt+e702OppunwRpBo/BGA3xohG2/NEN0Zg2EG
Dew5JR/r914=
=PCO0
-----END PGP SIGNATURE-----

--Sig_/wVGzTUpHlzirOOXhvsIE6c3--
