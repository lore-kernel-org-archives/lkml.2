Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1LFPTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 10:19:23 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63214 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab1LFPTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 10:19:22 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH] mfd: add bq2415x charger driver
Date: Tue, 06 Dec 2011 16:19:16 +0100
Message-ID: <2283497.cC5M10DNsE@pali-elitebook>
User-Agent: KMail/4.7.3 (Linux/3.2.0-3-generic; KDE/4.7.3; x86_64; ; )
In-Reply-To: <CAMP44s1uQJZ8nhjMqUXPZLL+XvnWUAZ+qeKejeZdA0WwiS3e=Q@mail.gmail.com>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com> <4644874.uYs2CCTrg9@pali-elitebook> <CAMP44s1uQJZ8nhjMqUXPZLL+XvnWUAZ+qeKejeZdA0WwiS3e=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2982289.SZukELQUPZ"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2982289.SZukELQUPZ
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hello,

On Tuesday 06 December 2011 16:11:33 Felipe Contreras wrote:
> On Tue, Dec 6, 2011 at 3:27 PM, Pali Roh=E1r <pali.rohar@gmail.com> w=
rote:
> > On Tuesday 06 December 2011 12:58:06 you wrote:
> >> Ok. A device with such debugfs would be nice, but I would start
> >> without one, just something that works.
> >=20
> > I think we do not need in mainline kernel driver which "only works"=

> > without any debug or additional support.
>=20
> I think that's a good start, and that's what I will focus on.
>=20
> >> I don't know if the regulator interface makes sense, but I think n=
ot.
> >> Anyway, I don't see how my code is specific to rx51, it should wor=
k
> >> with all bq2415x models.
> >=20
> > voltage and current values could be different for other boards. So =
each
> > board (with bq2415x chip) should have defined default charge proper=
ties
> > (in platform data structure or something else...). your interface d=
oes
> > not support such as other changes.
>=20
> No, they wouldn't, that depends on many things, like the type of
> charger. As Sebastian pointed out, the current *sense* voltage, is
> board specific, but that's about it.
>=20
> >> Why do we need user-space for the boost mode?
> >=20
> > Because on n900 we *want* USB host mode. Without boost mode support=
 (in
> > kernel driver) again will need to rmmod driver (now we stopping BME=
)
> > and start handling it in userspace.
>=20
> But we can have boost mode *without* user-space. There's no reason wh=
y
> it can't be handled by the kernel.

I thought that: we need from userspace signal "now enable host mode" an=
d "now=20
disable host mode". So kernel driver should has sysfs for enable/disabl=
e host=20
mode - only this, all other will be of course handled in kernel.

>=20
> >> >> I'm not familiar with any of this stuff, so don't take my
> >> >> opinions too seriously :)
> >> >=20
> >> > Consider my code. We do not need two (or more) implementation of=

> >> > same
> >> > driver in kernel. And also we do not need only rx51 specified
> >> > code.
> >>=20
> >> Of course, that's why I am discussing this :)
> >>=20
> >> > I separated bq2415x register access into one module (bq2415x.c -=

> >> > without any logic, only cover chip options) and real battery
> >> > charging should be done in power_supply interface
> >> > (bq2415x_charger.c)
> >>=20
> >> I don't see the point of having two drivers.
> >=20
> > Because proper charging on n900 needs interact with isp1704 driver.=
 But
> > this is specified for n900, not for all boards. bq2415x module shou=
ld
> > be general for all boards - so it should cover *only* bq2415x chip =
-
> > nothing other.
> Yes, and that be done with hooks. The bq2415x driver will have hooks,=

> and the rx51 board configuration will connect isp1704 to bq2415x, and=

> that's it. No need for yet another driver.

Ok, this sounds good.

>=20
> >> > My code has also prepaired boost support - for usb host mode,
> >> > which must be done in driver.
> >>=20
> >> Well, yeah, in my driver it can be added as well, however, I don't=

> >> think it's _needed_ right now.
> >=20
> > Of course, but I (and maybe some other people) do not need uncomple=
ted
> > chip driver.
>=20
> Anything is better than what we have now, which is nothing. Look for
> example to how the bq27x00 battery driver evolved; it started very
> simple.

I know, I sent more bq27x00_battery patches :-)

>=20
> >> First, I would like something that works by itself (without
> >> user-space), which I already have. Next, I would like it to plug i=
nto
> >> isp1704 to detect when a charger is connected, and select the corr=
ect
> >> limits accordingly. I guess this hooks should be connected on the
> >> board code. Once having that, I think the driver should be ready f=
or
> >> merging, the rest of the features can come later.
> >=20
> > Working without userspace is my primary goal. But also for debuggin=
g
> > (and
> > status apps/scripts) is needed direct register access. isp1704
> > interaction should not be in bq2415x chip driver, but in some rx51
> > specified code.
> Yes.
>=20
> > Charging should be done in power_supply interface.
> >=20
> > See also api specification by Joerg Reisenweber (one of n900 usb
> > hostmode
> > support) on http://maemo.cloud-7.de/bq24150-sysnode.spec.txt
> > Similar interface is needed for proper usb host mode.
>=20
> That is very interesting... Is there yet another module for this?
> Again, I don't understand why interaction with user-space is *needed*=

> for host mode.

No other module exists - my is not finished :-)
Host mode only needs to kernel enable or disable it.

>=20
> > Also your driver does not handle errors, when charging and watchdog=

> > should be stopped. Charging is *very* crytical parts and it really
> > should detect errors.
> Indeed, that's why this is RFC only.
>=20
> > When in future I (or someone else) will want to add all missing fea=
tures
> > into bq2415x chip driver, it will be needed to rewrite it... (e.g.
> > handling errors in boost mode)...
>=20
> Perhaps, but I don't think so. Anyway, again, see the evolution of
> bq27x00, or basically anything in the kernel. If something needs to b=
e
> refactored for new features, so be it.
>=20
> But I think there is some consensus; the drivers should be in
> drivers/power, and have a power supply interface, rx51 board info
> should configure some sense voltage, and hook it up with
> isp1704_charger somehow. Once this is done and driver is merged, I
> don't expect that to change.

Ok, I agree with this.

>=20
> > Why to very very quicky merge uncompleted (but working) driver to
> > upstream? I think we should finish bq2415x chip driver and if all w=
ill
> > be implemented, then to merge it. What other developers think about=

> > that?
>=20
> This version of the driver is not the one I am proposing to merge. Th=
e
> one I'm proposed to merge should be a good basis for future work (or
> what you are doing right now).
>=20
> Cheers.

I updated my last code at http://atrey.karlin.mff.cuni.cz/~pali/bq2415x=
/

Now my question is: Should I stop working on my implementation and wait=
 until=20
you finish yours? Or start merging code?


--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart2982289.SZukELQUPZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7eMnQACgkQi/DJPQPkQ1If+ACeNIapllaEJvwxkBSHBfK6s1mA
AFgAoLsCyDByW5bBBSLV/LAypgM/Gq/S
=Oprl
-----END PGP SIGNATURE-----

--nextPart2982289.SZukELQUPZ--

