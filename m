Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab1JTARu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 20:17:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab1JTARs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 20:17:48 -0400
Date: Thu, 20 Oct 2011 11:17:43 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
Message-ID: <20111020111743.13b40558@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1110191208570.2067-100000@iolanthe.rowland.org>
References: <20111019095540.1011993d@notabene.brown>
	<Pine.LNX.4.44L0.1110191208570.2067-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/leeYPgbKdoC/noOKO2i+nHJ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/leeYPgbKdoC/noOKO2i+nHJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Oct 2011 12:19:21 -0400 (EDT) Alan Stern
<stern@rowland.harvard.edu> wrote:

> On Wed, 19 Oct 2011, NeilBrown wrote:
>=20
> > > There's another way to implement "inhibit suspend" -- via the notify=
=20
> > > mechanism.  If the client doesn't respond to a callback, the server=20
> > > won't suspend.  Hence if people use the fd-timer approach,=20
> > > be-awake-after isn't needed.
> >=20
> > I don't like that approach though.  It leaves the daemon thinking "we a=
re on
> > the way towards suspend" and that is what it tells other clients.  But =
really
> > we are in state "someone doesn't want us to suspend now".
> > So some clients are assuming suspend is imminent and are waiting expect=
antly
> > for it to be over, but in reality the system is staying awake and only =
one
> > client knows about it.
>=20
> Clients should not make assumptions of that sort.  They have no need to
> know exactly what the daemon is doing, and there's no reason for the
> daemon to tell them.
>=20
> All a client needs to know is whether or not _it_ is busy, so that it
> can provide correct information to the daemon.  (Some clients may also
> need to be notified each time the system resumes -- that's a separate
> matter.)  As for the rest, a client may as well assume that the system
> is perpetually on the verge of suspending, except when it has
> personally told the daemon to stay awake.

I don't think it is always appropriate to assume the system is on the verge
of suspending except when explicitly asking for stay-awake.

Consider a daemon tasked with managing the "GSM" interface in a phone.
Any message from the GSM module will wake the phone if it is suspended.

When suspended, the daemon only wants to get "incoming call" and "incoming
SMS" events.
When not suspended, the daemon also wants "Active cell changed" events so
that it can make this information available to some display widget.

So when it is told that a suspend is imminent it quickly tells the GSM
module to be quieter and then says "OK".  If it had to assume it was always
on the verge, it could never allow active-cell-changed events.

You could argue that the GSM daemon should only be reporting CELL changes -
and so the GSM module should only be asked to report them - when the widget
(or some other client) is explicitly asking for them.  So when the screen
goes blank, the widget stops getting expose events, so it rescinds is reque=
st
for updates and the GSM daemon passes that on to the GSM module.  So when
suspend happens, the GSM module has already stopped reporting.

But I'm not convinced that complexity is always justified.

I could make the situation a little more complex.  There might be a daemon
which wants to monitor GSM cell locations and so is always asking.
The GSM daemon might have a policy that if anyone wants those updates, then
 - if system is awake for some other reason, report them as they arrive
 - if system is otherwise suspended, wake up every 10 minutes to poll and
   report.

In that case the suspend-client (the GSM daemon) really does care about the
difference between an explicit stay-awake and a late reply to a
suspend-imminent message.

So I'm still inclined to think that the two cases need to be treated
separately.

Thanks,
NeilBrown



>=20
> On the daemon's side, I don't think there is a significant difference
> between "we are on the way toward suspend and waiting for this client's
> response" and "this client doesn't want us to suspend now".  Either
> way, the daemon can't make any forward progress until it hears from
> the client -- and the client might send an update at any time.
>=20
> Alan Stern


--Sig_/leeYPgbKdoC/noOKO2i+nHJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTp9opznsnt1WYoG5AQJ9KBAAvQ5Se8oF5or+63BK0NNjpzCX9qiJd3FM
SVuAUZWmxWY01x63APNz5H0fu3EtXrQVR6H97ZfQ3GWZSITFgBDPOVP0zjE1q4Yd
O18AGmctvjLeOXhMi841qZ8wOTWCYQKu6YoX65kfGGHm4PQDEcPta/UOmlThhN9k
F/oENeXdPPfO1DVDe/4eOfq1khRaPTPzZBr/mp7IaU+JtTC/Sqmz4p782iHNLbQO
6dDnLBUqTgi7GVFA+zA275NKt/g8gPCBXfOM5ZUlxktzJPMUmQgJT1nv4hysFXjR
p/7WrjubhLIUfafMB2lHYCcEnIr3SnUV2YVSXbyA6BJLosxurWRG8AazSiKZkTOl
BfyKkfBR7qCGZpWw++edsRqTc3Ntf3dycE23ozcf2Rp8AoXtf+CJDGJddHamWjWo
QNbpfFIGBCmtYgC2xhVuxlRlE2+ZconnqkzZEkeZ5HvTIyJcBzT4XMog3GX4K4+O
j0llSj17XlfuCBBW7OfFwORZqQbmRkbk4+yHVLEeSNnZUGyoauCbtsI5B4rZMgPF
JPY+Q8x2RAr/tXVomiUJ7tyNMYcd7x4aQyUuBAWSsh4gHfoD5qdLQFlC9G/fmk6g
SNqUxKP6SnBpsbZ6tHU+2j0QlmAXZQ2oSuP8oc3t38bkKJKJAPyrcu8XEs3iN3zZ
we7Khzpgll8=
=69bj
-----END PGP SIGNATURE-----

--Sig_/leeYPgbKdoC/noOKO2i+nHJ--
