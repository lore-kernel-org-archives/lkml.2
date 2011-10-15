Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1JOVnv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 17:43:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239Ab1JOVnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 17:43:50 -0400
Date: Sun, 16 Oct 2011 08:43:40 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
Message-ID: <20111016084340.288fd080@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1110151426420.15129-100000@netrider.rowland.org>
References: <20111015080718.01aef515@notabene.brown>
	<Pine.LNX.4.44L0.1110151426420.15129-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mQAVfhSNbTO0.Hxa4IOQk+o"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mQAVfhSNbTO0.Hxa4IOQk+o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 15 Oct 2011 14:34:59 -0400 (EDT) Alan Stern
<stern@rowland.harvard.edu> wrote:

> On Sat, 15 Oct 2011, NeilBrown wrote:
>=20
> > > One of the things Rafael didn't mention is that sometimes a kernel=20
> > > driver needs to prevent the system from suspending.  This happens whe=
n=20
> > > recharging over a USB connection.
> > >=20
> > > There's no simple way for such a driver to communicate with a power
> > > daemon.  The driver has to use something like the wakeup mechanism --=
=20
> > > but currently that mechanism is optional.
> > >=20
> > > Alan Stern
> >=20
> > Certainly I don't expect a kernel driver to communicate directly with a
> > user-space daemon.  It communicates indirectly through the wakeup_source
> > mechanism.
> > If user-space wants to block suspend, it talks to the suspend daemon (p=
ower
> > manager) some how (dbus, lock files, sockets, signals, whatever).
> > If the kernel wants to block suspend, it activates a wakeup_source (aka
> > caffeine source) which the suspend daemon notices via /sys/power/wakeup=
_count.
> >=20
> > But you say this wakeup mechanism is optional .... I don't see that.
> >=20
> > It is implemented in drivers/base/power/wakeup.c which is included in t=
he
> > kernel if CONFIG_PM_SLEEP which is defined as
> >=20
> > config PM_SLEEP
> > 	def_bool y
> > 	depends on SUSPEND || HIBERNATE_CALLBACKS
> >=20
> > which seems to mean "enable this unless we don't have suspend and we do=
n't
> > have hibernate".
> >=20
> > So it seems that the only time we don't have the wakeup mechanism, we a=
lso
> > have no risk of ever going to sleep.
> >=20
> > What exactly where you saying was "optional"?? I don't understand.
>=20
> It's optional in the sense that user programs can bypass it.  They=20
> aren't forced to read or write /sys/power/wakeup_countm, and if they=20
> don't then the wakeup mechanism won't prevent the system from=20
> suspending.
>=20
> Alan Stern

Ahh, I understand now, thanks.

I didn't consider that as significant because I see it as a core and necess=
ary
design philosophy.

For example, file locks are advisory in Unix/Linux.  In the old days we had
lock files which could be ignored (or even removed) by any (suitably
privileged) process.  Today we use flock or lockf which are easier to work
with but just as easy to ignore.  So they are optional, but it all still
works.
I have worked with systems with mandatory locking and they are often very
annoying.  I think they make it easier to write bad code, and harder to wri=
te
good code.

Another example is shutdown.  The right way to do this it tell 'init' to
clean up and shutdown, and /sbin/halt does that by default.
But it is optional, "halt -f" or "echo p > /proc/sysrq-trigger" just halt
immediately, and sometimes I want that option.

So yes: using /sys/power/wakeup_count is optional, but if some code doesn't
do it - file a bug report like you would if some code doesn't respect
necessary file locks.

Thanks,
NeilBrown

--Sig_/mQAVfhSNbTO0.Hxa4IOQk+o
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpn+jDnsnt1WYoG5AQKiyQ//YVXMDN+XX0FgWEbXogadbajogY1hWVTJ
ELJiIgcp3V0dR7eT0xZRwSiPUP+f8osD6UCVdohUSBDlf5Yod1pYf8uJsUvw4PZq
TIzc09yN6QNB1+KGvRisHw6mSyv+UBJwWFNWx3o12mvFyiLl4VJl3GPdZonKjbOX
2vDBkKA0+OVP3T6X3w35+sEBBnN0GIwXNaf36XQmdDIQGWVMtWvBKKOKHUWVjnIA
AzKTtO8GejUghmlq7/4Gb47Bn2PVDEeGNZbEgEXrTr7qBrg2Dd8rFIF1OTBtNa1u
oZ1IHOodlIhJXfvgtB/HzfQTZgvQ3clkYQjICk3xZr1GG8tSZJg7zW2QwGwKzfVN
SlSGDpA9xkTCGXYYugodFIIWVyMx59M5FULlLAt5trb4bOER4JXOGounRMtsh3ov
ME3sNliVVv5QSOIWkEiYretR4bdswQkpYngZCOJvxiLh2O2fWi9WGDkUWXSO74TP
4nuGfbovTTYCSVC8OPN9wuNbTlGK684Wket7SiaQ5y67x6DhirFi5AvxX2YldOkU
OgrcxR8rJUGO0VGeYbH6eUXg7V5RSXJl/OAgcAQWLGzA0F9oMuVaMZA5GlvXZF3X
RVFhS436cdGjUP0oMLdmbApmqK1QZRXifYLi4GVMrVznqouS4J/+1VSXx74LU1iF
D1H6dzdMrPk=
=Rj8F
-----END PGP SIGNATURE-----

--Sig_/mQAVfhSNbTO0.Hxa4IOQk+o--
