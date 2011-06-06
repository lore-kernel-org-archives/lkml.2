Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab1FFR0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:26:08 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:54934 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292Ab1FFR0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:26:05 -0400
Date: Mon, 6 Jun 2011 20:25:57 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Keshava Munegowda <keshava_mgowda@ti.com>,
        USB list <linux-usb@vger.kernel.org>, linux-omap@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        khilman@ti.com, b-cousson@ti.com, paul@pwsan.com
Subject: Re: [PATCH 4/4] mfd: global Suspend and resume support of ehci and
 ohci
Message-ID: <20110606172555.GL12242@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110605195413.GC18731@legolas.emea.dhcp.ti.com>
 <Pine.LNX.4.44L0.1106061141130.1953-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lHuqAdgBYNjQz/wy"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106061141130.1953-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lHuqAdgBYNjQz/wy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 06, 2011 at 12:06:44PM -0400, Alan Stern wrote:
> > > > So, something like:
> > > >=20
> > > > #define __pm_ops	__section(.pm.ops)
> > > >=20
> > > > static const struct dev_pm_ops my_driver_pm_ops __pm_ops =3D {
> > > > 	.suspend	=3D my_driver_suspend,
> > > > 	.resume		=3D my_driver_resume,
> > > > 	[ blablabla ]
> > > > };
> > > >=20
> > > > to simplify things, you could:
> > > >=20
> > > > #define DEFINE_DEV_PM_OPS(_ops)		\
> > > > 	const struct dev_pm_ops _ops __pm_ops
> > > >=20
> > > > that would mean changes to all linker scripts, though and a utility=
 call
> > > > that only does anything ifndef CONFIG_PM to free the .pm.ops sectio=
n.
> > >=20
> > > In my opinion this would make programming harder, not easier.  It's
> >=20
> > I tend to disagree with this statement, see below.
> >=20
> > > very easy to understand "#ifdef" followed by "#endif"; people see them
> >=20
> > very true... Still everybody has to put them in place.
>=20
> True.  But with your suggestion, people have to remember to use=20
> __pm_ops and DEFINE_DEV_PM_OPS.

Ok, I see your point here.

> > > all the time.  The new tags you propose would force people to go
> > > searching through tons of source files to see what they mean, and then
> >=20
> > only those who want to see "how things work" would be forced to do that,
> > other people would be allowed to "assume it's doing the right thing".
>=20
> But what is the "right thing"?  Suppose you want to have conditional=20
> support for dev_pm_ops whenever CONFIG_PM is enabled and you _also_=20
> want to have conditional support for runtime PM whenever=20
> CONFIG_PM_RUNTIME is enabled?

we don't have this today either. Currently everybody does #ifdef
CONFIG_PM, so either all the data is available, or none is and adding
another #ifdef CONFIG_PM_RUNTIME for the runtime_* friends, would just
look even uglier :-)

> > > readers would still have to figure out when these tags should be used
> > > or what advantage they might bring.
> >=20
> > not really, if you add a macro which adds that correctly and during
> > review we only accept drivers using that particular macro, things
> > wouldn't go bad at all.
> >=20
> > > It's a little like "typedef struct foo foo_t;" -- doing this forces
> >=20
> > hey c'mon. Then you're saying that all __initdata, __devinitdata,
> > __initconst and all of those are "typedef struct foo foo_t" ;-)
>=20
> No.  Unlike foo_t, they don't obscure important information and they do=
=20
> provide a significant gain in simplicity.  On the other hand, they also=
=20
> provide a certain degree of confusion.  Remember all the difficulty we=20
> had with intialization code sections in the gadget framework.

this is fairly true, but only because the gadget framework isn't really
a framework. It's just an agreement that all UDCs will export a
particular function. It's a great infrastructure for the function
drivers, but not for UDCs, so I think this isn't a great example :-)

> > > people to remember one extra piece of information that serves no real
> > > purpose except perhaps a minimal reduction in the amount of typing. =
=20
> >=20
> > and a guarantee that the unused data will be freed when it's really not
> > needed ;-)
>=20
> You can obtain that same guarantee by using #ifdef ... #endif.  Even=20
> better, you can guarantee that the unused data won't be present at all,=
=20
> as opposed to loaded and then freed.

I agree with you here, but I give you the same question as you gave me.
How will you have conditional on CONFIG_RUNTIME_PM and CONFIG_PM ? you'd
need two levels of ifdefs.

> > > Since the limiting factor in kernel programming is human brainpower,
> > > not source file length, this is a bad tradeoff.  (Not to mention that
> >=20
> > OTOH we are going through a big re-factor of the ARM port to reduce the
> > amount of code. Not that these few characters would change much but my
> > point is that amount of code also matters. So does uniformity, coding
> > style, etc...
> >=20
> > > it also obscures an important fact: A foo_t is an extended structure
> > > rather than a single value.)
> >=20
> > then it would make sense to have dev_pm_ops only defined when CONFIG_PM
> > is set to force all drivers stick to a common way of handling this.
> >=20
> > Besides, currently, everybody who wants to keep the ifdeferry, needs to
> > define a macro for &my_dev_pm_ops or have two #ifdef..#endif blocks.
> >=20
> > Either you do:
> >=20
> > #ifdef CONFIG_PM
> > static int my_driver_suspend(struct device *dev)
> > {
> > 	...
> >=20
> > 	return 0;
> > }
> > ....
> >=20
> > static const struct dev_pm_ops my_driver_pm_ops =3D {
> > 	.suspend	=3D my_driver_suspend,
> > 	...
> > };
> >=20
> > #define DEV_PM_OPS	(&my_driver_pm_ops)
> > #else
> > #define DEV_PM_OPS	NULL
> > #endif
> >=20
> > static struct platform_driver my_driver =3D {
> > 	...
> > 	.driver	=3D {
> > 		.pm =3D DEV_PM_OPS
> > 	},
> > };
> >=20
> > or you do:
> >=20
> > #ifdef CONFIG_PM
> > static int my_driver_suspend(struct device *dev)
> > {
> > 	...
> >=20
> > 	return 0;
> > }
> > ....
> >=20
> > static const struct dev_pm_ops my_driver_pm_ops =3D {
> > 	.suspend	=3D my_driver_suspend,
> > 	...
> > };
> >=20
> > #endif
> >=20
> > static struct platform_driver my_driver =3D {
> > 	...
> > 	.driver	=3D {
> > #ifdef CONFIG_PM
> > 		.pm =3D &my_driver_pm_ops,
> > #endif
> > 	},
> > };
>=20
> Whereas your way people write:
>=20
> static int __pm_ops my_driver_suspend(struct device *dev)
> {
> 	...
>=20
> 	return 0;
> }
> ....
>=20
> static DEFINE_DEV_PM_OPS(my_driver_pm_ops) =3D {
> 	.suspend	=3D my_driver_suspend,
> 	...
> };
>=20
> static struct platform_driver my_driver =3D {
> 	...
> 	.driver	=3D {
> 		.pm =3D &my_driver_pm_ops,
> 	},
> };
>=20
> It doesn't seem like a good idea to keep the invalid pointer to=20
> my_driver_pm_ops, even though it should never get used.

true, I agree.

> An approach that might work better would be for the PM core to define a=
=20
> suitable macro:
>=20
> #ifdef CONFIG_PM
> 	#define DEV_PM_OPS_REF(my_pm_ops)	&(my_pm_ops)
> #else
> 	#define DEV_PM_OPS_REF(my_pm_ops)	NULL
> #endif
>=20
> Then people could write
>=20
> static struct platform_driver my_driver =3D {
> 	...
> 	.driver	=3D {
> 		.pm =3D DEV_PM_OPS_REF(my_driver_pm_ops),
> 	},
> };
>=20
> without worrying about whether or not my_driver_pm_ops was defined. =20
> And only one #ifdef block would be needed.

that'd be nice. Something similar to __exit_p() and __devexit_p()

> > So, while this is a small thing which is easy to understand, it's still
> > yet another thing that all drivers have to remember to add. And when
> > everybody needs to remember that, I'd rather have it done
> > "automatically" by other means.
> >=20
> > I mean, we already free .init.* sections after __init anyway, so what's
> > the problem in freeing another section ? I don't see it as obfuscation
> > at all. I see it as if the kernel is smart enough to free all unused
> > data by itself, without myself having to add ifdefs or freeing it by my
> > own.
> >=20
> > On top of all that, today, we have driver with both ways of ifdefs plus
> > drivers with no ifdeferry at all, leaving dev_pm_ops floating around for
> > nothing.
> >=20
> > IMHO, if things aren't uniform, we will have small problems, such as
> > this, proliferate because new drivers are based on other drivers,
> > generally.
>=20
> I have to agree that uniformity is to be desired.  And it's probably=20
> already way too late, because we can't prevent new drivers from being=20

I wouldn't call it late. Such small convertions can be done by simple
scripts, but when patches switching drivers over are rejected [1] then
we loose the opportunity to give good example to newcomers.

> based on the existing drivers -- even if all the existing drivers get=20
> changed over (which seems unlikely).

Well, it might work out if pm core makes dev_pm_ops only available on
CONFIG_PM builds.

[1] http://marc.info/?l=3Dlinux-usb&m=3D129733927804315&w=3D2

--=20
balbi

--lHuqAdgBYNjQz/wy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7Q2jAAoJEAv8Txj19kN1olAH/3Rg3xZSYJT2+lEDvIylRB6O
6nuwhvPosJG1zbBHeZWNYkTqKoTai+R3OUnorGgxLZRsEbSnvufQMRP3QzpQWxWN
clUvFJ/zymYNR1axx5Bpv3mVMqnwRA71oToUFycYlqne7G/eYIpokOrrSlEj0K8m
I6UlRl9HpxDtvrF73FrYYBm6pEzfTwO3T7L9g8j4oM98cDJsdaj09FLf7PUeML06
q01hj69vAovZzOeTYovO5MXX7kbwl/JIU/2VmMZxkjVvZJ5AZoW2UPdpDmVxkH+O
EU9B7IGj8zc7zsAzAL/yCvyB0H38EI1Xy9bHZ+VgxPm+Nx6D0HAcPw3+AfUMdAU=
=chDS
-----END PGP SIGNATURE-----

--lHuqAdgBYNjQz/wy--
