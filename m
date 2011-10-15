Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1JOW0K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 18:26:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab1JOW0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 18:26:08 -0400
Date: Sun, 16 Oct 2011 09:25:56 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: markgross@thegnar.org, <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <arve@android.com>,
        <amit.kucheria@linaro.org>, <farrowg@sg.ibm.com>,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        <linux-pm@lists.linux-foundation.org>, <khilman@ti.com>,
        Magnus Damm <damm@opensource.se>, <mjg@redhat.com>,
        <peterz@infradead.org>
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
Message-ID: <20111016092556.07d6e415@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1110151435080.15129-100000@netrider.rowland.org>
References: <20111015084732.5fe55467@notabene.brown>
	<Pine.LNX.4.44L0.1110151435080.15129-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PY+JivncGbtfbXeBxxZc8tW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/PY+JivncGbtfbXeBxxZc8tW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 15 Oct 2011 14:45:37 -0400 (EDT) Alan Stern
<stern@rowland.harvard.edu> wrote:

> On Sat, 15 Oct 2011, NeilBrown wrote:
>=20
> > On Thu, 13 Oct 2011 11:16:23 -0400 (EDT) Alan Stern
> > <stern@rowland.harvard.edu> wrote:
> >=20
> > > On Thu, 13 Oct 2011, NeilBrown wrote:
> > >=20
> > > > Nope, but I'm keen for you to convince me.  Identify a wakeup event=
 that
> > > > cannot be made visible to poll (or to user-space by some other
> > > > mechanism) before the wakeup_source needs to be deactivated.  Or if=
 I've
> > > > misunderstood what sort of notification is problematic, help me und=
erstand.
> > >=20
> > > Here's an example (just for kicks, not completely relevant to your
> > > discussion): A USB keyboard key release.  Unlike key presses, key
> > > releases need not generate input events.  If no processes are
> > > monitoring the raw keyboard event queue then the release is not visib=
le
> > > to userspace at all, hence not visible before the wakeup_source needs
> > > to be deactivated.
> > >=20
> > > Alan Stern
> >=20
> > As you say, not completely relevant.
> >=20
> > If a tree falls in a forest with no one to here, does it make a sound?
> >=20
> > similarly if an event happens that no-one is looking for, is it visible?
> > It doesn't really matter.
>=20
> That's a different question, but I'll answer it anyway: Yes, it does
> matter.  If the kernel is unable to _know_ that nobody is looking for
> an event, it has to _assume_ that somebody is.  Then what should happen=20
> if it turns out that nobody really is looking for it?

Same answer - it doesn't really matter.
In every case, the kernel's responsibility is to make the sure the event is
visible to any watching user-space process before it releases the
wakeup_source.
What user-space does then is up to user-space.
If no-one is watching the kernel is free to drop it at any stage - as soon =
as
it discovers no-one is watching.
When the input layer gets an event, it iterated through a list of fds which
are open on the event source and queues it to each one.  This list might be
empty - no big deal.  It was still a wakeup_event.  If we were suspended, t=
he
write to /sys/power/state will now complete, the suspend daemon will go back
around its loop, nothing will seem to be happening, so the system will go
back to sleep.

>=20
> > So at most this is a case of "is not made visible" rather than "cannot =
be
> > made visible".
>=20
> In this case it's the same thing.  How can a key release be made=20
> visible?

/dev/input/eventX??  the evdev driver presents key-down and key-up events
separately.

>=20
> > The key-release just needs to clear the "key is pressed" state so that
> > auto-repeat stops and if it was a modifier, the modification is discard=
ed.
> > That is all trivially done in some kernel driver while the wakeup_sourc=
e is
> > active.
>=20
> In other words, if the event is discarded from within the kernel then=20
> the wakeup_source can be deactivated at that time.  That's fine -- but=20
> it indicates that your original request above was phrased wrongly.  You=20
> should have asked for an example of a wakeup_source which the kernel=20
> must not deactivate without a userspace handshake, but which cannot be=20
> made visible by poll or some other similar mechanism.

Yes, I agree that is more precise statement of what I was trying to say - a=
nd
precision is important here.

Thanks!

NeilBrown


--Sig_/PY+JivncGbtfbXeBxxZc8tW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpoIdDnsnt1WYoG5AQKaEQ/+MrDMWcSG8r/YmMhxgYvT/RLUcnBU/+Hp
PuyFf8tvfLnNnKIsf0NuPZITUnR2uMEb4+VeIouYjxXLJECVPM1IkTPTz0GSDVcu
zYjEDTKIvB7lROvcW7N9IuuQmiYwsG93O9B1TDEdaE5fKvnWRJzEFgkgCR4SmlKk
rXbGsXNv3y3N2ginSJtUkkZIzOrIm71Jrv1FXdDMsNRBuyDWT8fqBGI/xhRaHtBQ
YhLyRBVVci9PIdynt9HHUKrmU+whqI0uXguPAkXAAtWKh3ggA0/rTpZjLTYJMjJP
onr4kQU5vMbkmojMzTMWcghLNaey/SXNZXWi0nTtHGUzU+GGXPozWcFLCssd8n/R
IrYq/fZnLU6GA7uJjLudERUIp/sDv74BErccve/58CeKHXdNffwCdji5g1cO//r1
Y08ROIsay746gG/w5Zj3O23qIuV2/oaBBFe3YKxlgWbTgNe3DoROWXNDqG3ldHr4
ZsG+BPIbXqdYbdUn8djCfTpPXYz4yJmRIgNnE/z+N1L/G/FKWp0zFC39pgKJm4w7
ryFrFkf02meoxMmrF+ves/IToTUBlC4l9lvszJ2LtzRES0VDI7UXF1Yg6SsyEEbc
14LMtAQAWFMAMlLQtyA2yfErAGcJvFYFQ/7Vi+e7lFR1dU6Ag88d9kPM6LnIFxPl
ykdbyFYlhZ8=
=E4ph
-----END PGP SIGNATURE-----

--Sig_/PY+JivncGbtfbXeBxxZc8tW--
