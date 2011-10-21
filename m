Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab1JUFGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 01:06:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab1JUFGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 01:06:07 -0400
Date: Fri, 21 Oct 2011 16:05:37 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
Message-ID: <20111021160537.757cbf1d@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1110201019500.2081-100000@iolanthe.rowland.org>
References: <20111020111743.13b40558@notabene.brown>
	<Pine.LNX.4.44L0.1110201019500.2081-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.eNXCJVHA6GhLXsi3DVzdjt"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.eNXCJVHA6GhLXsi3DVzdjt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Oct 2011 10:29:33 -0400 (EDT) Alan Stern
<stern@rowland.harvard.edu> wrote:

> On Thu, 20 Oct 2011, NeilBrown wrote:
>=20
> > > All a client needs to know is whether or not _it_ is busy, so that it
> > > can provide correct information to the daemon.  (Some clients may also
> > > need to be notified each time the system resumes -- that's a separate
> > > matter.)  As for the rest, a client may as well assume that the system
> > > is perpetually on the verge of suspending, except when it has
> > > personally told the daemon to stay awake.
> >=20
> > I don't think it is always appropriate to assume the system is on the v=
erge
> > of suspending except when explicitly asking for stay-awake.
>=20
> For some programs it may not be appropriate, but for wakeup clients I=20
> believe it is.
>=20
> > Consider a daemon tasked with managing the "GSM" interface in a phone.
> > Any message from the GSM module will wake the phone if it is suspended.
> >=20
> > When suspended, the daemon only wants to get "incoming call" and "incom=
ing
> > SMS" events.
> > When not suspended, the daemon also wants "Active cell changed" events =
so
> > that it can make this information available to some display widget.
> >=20
> > So when it is told that a suspend is imminent it quickly tells the GSM
> > module to be quieter and then says "OK".  If it had to assume it was al=
ways
> > on the verge, it could never allow active-cell-changed events.
> >=20
> > You could argue that the GSM daemon should only be reporting CELL chang=
es -
> > and so the GSM module should only be asked to report them - when the wi=
dget
> > (or some other client) is explicitly asking for them.  So when the scre=
en
> > goes blank, the widget stops getting expose events, so it rescinds is r=
equest
> > for updates and the GSM daemon passes that on to the GSM module.  So wh=
en
> > suspend happens, the GSM module has already stopped reporting.
> >=20
> > But I'm not convinced that complexity is always justified.
> >=20
> > I could make the situation a little more complex.  There might be a dae=
mon
> > which wants to monitor GSM cell locations and so is always asking.
> > The GSM daemon might have a policy that if anyone wants those updates, =
then
> >  - if system is awake for some other reason, report them as they arrive
> >  - if system is otherwise suspended, wake up every 10 minutes to poll a=
nd
> >    report.
> >=20
> > In that case the suspend-client (the GSM daemon) really does care about=
 the
> > difference between an explicit stay-awake and a late reply to a
> > suspend-imminent message.
> >=20
> > So I'm still inclined to think that the two cases need to be treated
> > separately.
>=20
> The way I see it, your GSM daemon needs to know when the system is=20
> about to go into suspend.  That's a separate matter from communicating=20
> information about wakeup activity to/from the PM daemon.

I agree that it is conceptually distinct.
However I think that in practice it ends up looking very similar.
Maybe that is just the way I practice.

>=20
> What should happen is this: When the PM daemon is ready to start a
> suspend (none of its clients need to keep the system awake), it should
> broadcast the fact that a suspend is about to begin.  This broadcast
> could take various forms, the simplest of which is to run a shell
> script.

I would call it 'publish' rather than 'broadcast' as I expect clients to
subscribe first, but it is a small matter.
Certainly having different protocols for different uses could be appropriat=
e.


>=20
> In fact, we may want to integrate the PM daemon into pm-utils at a=20
> level above where the various suspend scripts get run.
>=20

Probably - yes.

Thanks,
NeilBrown


--Sig_/.eNXCJVHA6GhLXsi3DVzdjt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqD9tjnsnt1WYoG5AQJTZxAAsOqAvXEgA6csmTKqwn3bOAiEbe/r9xUv
u0fWQWIEM5E/GAoB4u5G4YrOXg5gJdwyarGLUpXIjUwD1G7cTeCy5nhvlIpPDx/y
WPpPfm1uQye2gzkZJ62kNC0ooE5aAn1YuPZoLFXFsAnUepQuF85VNvtPe5VZPXwS
Bd+4h3x49NydoewWrXsGmFMVt/v+z5zp6u6odPTDa4ktFIJl7FzXozvOU37AAwyY
6j1d14bacTHWyrOgVcQhTSlASqAk/t4IazYa9gK9A0+jL6OnYF4XLpnu3d6xIMB6
fJxx9WETpH5jB80HkXrY9YDXbMj9twpOuNyIGSyQ/UETkLXkn0+e+vU44DyoNIm5
wq2iwHOq+yJmbvd9AKP1HA4aAy4FIHfe8Tk1GZEia5syvpixHhq6pydC4RESItV+
ooKgWyQ8ArErpEUAqiHYkB0/JaadPz4Rc4dEl8t8WKRXctVzFlQf/08eg/ETjW+P
i3WHvG7GdsKlWT8mUlraPKkHghGlHixnc4+TQ6lcTef0NoU184xDBnge8nruBiRz
F2W+IOss62Ra3bqoeGn0otenAFefRmIKFDjN5n1aOpWETtmPtAddLXfcijAiPSyK
lVLCIBTo/MV1flnj+n5xiQlfob0Pxy3mN7TFj6K7n/E9abONYt62D6Uu39/xFFdc
5R+eKi2KELA=
=4Psb
-----END PGP SIGNATURE-----

--Sig_/.eNXCJVHA6GhLXsi3DVzdjt--
