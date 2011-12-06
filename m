Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357Ab1LFN2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:28:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42916 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab1LFN16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:27:58 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH] mfd: add bq2415x charger driver
Date: Tue, 06 Dec 2011 14:27:52 +0100
Message-ID: <4644874.uYs2CCTrg9@pali-elitebook>
User-Agent: KMail/4.7.3 (Linux/3.2.0-3-generic; KDE/4.7.3; x86_64; ; )
In-Reply-To: <CAMP44s3hxKgP_epT48vwqwM-jme7ZsZx0U1xW4DTrn9aSpb6hg@mail.gmail.com>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com> <8650361.EbH1hYJT76@pali-elitebook> <CAMP44s3hxKgP_epT48vwqwM-jme7ZsZx0U1xW4DTrn9aSpb6hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1842447.1iKXsySLby"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1842447.1iKXsySLby
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hello,

On Tuesday 06 December 2011 12:58:06 you wrote:
> On Tue, Dec 6, 2011 at 9:25 AM, Pali Roh=E1r <pali.rohar@gmail.com> w=
rote:
> > On Tuesday 06 December 2011 02:12:47 you wrote:
> >> On Tue, Dec 6, 2011 at 1:05 AM, Pali Roh=E1r <pali.rohar@gmail.com=
> wrote:
> >> > I started writing other implementaion of bq2415x charger driver,=

> >> > which
> >> > should support also setting usb host mode. Code is still
> >> > unfinished,
> >> > but now is devided into 2 parts: one power_supply driver and one=

> >> > driver which cover all bq registers. See:
> >> >=20
> >> > http://atrey.karlin.mff.cuni.cz/~pali/bq2415x/
> >> >=20
> >> > Felipe Contreras, I think that my implementation is better - it
> >> > will
> >> > export all bq registers (which is needed for hostmode boost) and=

> >> > will
> >> > also register regulator interface.
> >>=20
> >> I took a look at your driver, and there's definitely good stuff in=
 it.
> >> However, I think there's a lot of unnecessary stuff, like the
> >> miscdevice stuff (which was frowned upon for bq27x00), and a lot o=
f
> >> user-space interface. Moreover, it doesn't seem to do anything on =
its
> >> own (it needs interaction from user-space).
> >=20
> > Ignore miscdevice, I will remove them from driver. I will add some
> > debugfs interface for getting registers output (needed for debuggin=
g)
>=20
> Ok. A device with such debugfs would be nice, but I would start
> without one, just something that works.

I think we do not need in mainline kernel driver which "only works" wit=
hout=20
any debug or additional support.

>=20
> >> IMO the first step should be to have a minimal driver that just wo=
rks,
> >> even if it doesn't achieve the absolute best charging performance.=

> >> More features could be added later on.
> >>=20
> >> Also, I'm not familiar with the regulator interface, but it seems =
to
> >> be meant for real regulators, which have consumers, and based on t=
hose
> >> consumers's needs the real voltage changes. This battery charger o=
n
> >> the other hand doesn't have anything like that. There will be no
> >> consumer, and some stuff like the weak battery voltage is not even=

> >> related to a voltage supply, but rather a threshold that can be
> >> configured to change some behavior of the charger, but there's no
> >> point in changing it dynamically (or maybe at all).
> >=20
> > If regulator interface is not good, I can change it to some sysfs
> > interface. But bq2415x chip driver is not only rx51 specified, so i=
t
> > should handle all chip capabilities.
>=20
> I don't know if the regulator interface makes sense, but I think not.=

> Anyway, I don't see how my code is specific to rx51, it should work
> with all bq2415x models.

voltage and current values could be different for other boards. So each=
 board=20
(with bq2415x chip) should have defined default charge properties (in p=
latform=20
data structure or something else...). your interface does not support s=
uch as=20
other changes.

>=20
> >> I guess the important one is the charge voltage, which is linked t=
o a
> >> real voltage, but what consumers would it have? I don't think ther=
e's
> >> any.
> >>=20
> >> Finally, I don't think user-space interaction should be needed at =
all.
> >> The driver should start charging immediately when there power supp=
ly
> >> available, and stop when there isn't any. Maybe at some point a
> >> user-space interface will be useful later on (I don't see why), bu=
t I
> >> don't think it should be *necessary*.
> >=20
> > Userspace interfaction is needed. We need to tell driver to boost -=
 for
> > usb host mode. But of course, battery charging should be automatic
> > without userspace interfaction.
>=20
> Why do we need user-space for the boost mode?

Because on n900 we *want* USB host mode. Without boost mode support (in=
 kernel=20
driver) again will need to rmmod driver (now we stopping BME) and start=
=20
handling it in userspace.

>=20
> >> I'm not familiar with any of this stuff, so don't take my opinions=
 too
> >> seriously :)
> >=20
> > Consider my code. We do not need two (or more) implementation of sa=
me
> > driver in kernel. And also we do not need only rx51 specified code.=

>=20
> Of course, that's why I am discussing this :)
>=20
> > I separated bq2415x register access into one module (bq2415x.c - wi=
thout
> > any logic, only cover chip options) and real battery charging shoul=
d be
> > done in power_supply interface (bq2415x_charger.c)
>=20
> I don't see the point of having two drivers.

Because proper charging on n900 needs interact with isp1704 driver. But=
 this=20
is specified for n900, not for all boards. bq2415x module should be gen=
eral=20
for all boards - so it should cover *only* bq2415x chip - nothing other=
.

In my opition bq2415x module should only export chip register access (t=
o=20
userspace via debugfs... and to kernel via some interface or symbols...=
)

>=20
> > My code has also prepaired boost support - for usb host mode, which=
 must
> > be done in driver.
>=20
> Well, yeah, in my driver it can be added as well, however, I don't
> think it's _needed_ right now.

Of course, but I (and maybe some other people) do not need uncompleted =
chip=20
driver.

>=20
> First, I would like something that works by itself (without
> user-space), which I already have. Next, I would like it to plug into=

> isp1704 to detect when a charger is connected, and select the correct=

> limits accordingly. I guess this hooks should be connected on the
> board code. Once having that, I think the driver should be ready for
> merging, the rest of the features can come later.

Working without userspace is my primary goal. But also for debugging (a=
nd=20
status apps/scripts) is needed direct register access. isp1704 interact=
ion=20
should not be in bq2415x chip driver, but in some rx51 specified code.

Charging should be done in power_supply interface.

See also api specification by Joerg Reisenweber (one of n900 usb hostmo=
de=20
support) on http://maemo.cloud-7.de/bq24150-sysnode.spec.txt
Similar interface is needed for proper usb host mode.

Also your driver does not handle errors, when charging and watchdog sho=
uld be=20
stopped. Charging is *very* crytical parts and it really should detect =
errors.

When in future I (or someone else) will want to add all missing feature=
s into=20
bq2415x chip driver, it will be needed to rewrite it... (e.g. handling =
errors=20
in boost mode)...

Why to very very quicky merge uncompleted (but working) driver to upstr=
eam? I=20
think we should finish bq2415x chip driver and if all will be implement=
ed,=20
then to merge it. What other developers think about that?

>=20
> Cheers.

--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart1842447.1iKXsySLby
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7eGFgACgkQi/DJPQPkQ1Kc+QCfbb8Ii+jxkpUBDPxZIT46NVil
LOgAn2TCKLLQMxpoTqlNlf/hVHvTqxRT
=DHIY
-----END PGP SIGNATURE-----

--nextPart1842447.1iKXsySLby--

