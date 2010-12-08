Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab0LHWi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:38:58 -0500
Received: from liberdade2.minaslivre.org ([74.50.53.203]:42728 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab0LHWiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:38:55 -0500
Date: Wed, 8 Dec 2010 20:37:18 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>, sedat.dilek@gmail.com,
        Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for December 8
 (drivers/platform/x86/Kconfig:422:error: recursive dependency detected!)
Message-ID: <20101208223717.GA4771@barata.holoscopio.com>
References: <AANLkTim3FJjVpbjM10kJJhXbONpvGSGQFE+mfGX9pAS6@mail.gmail.com>
 <AANLkTimjVY-6OwRfFUzUbmyacM81M35wf5qDWqAouUYb@mail.gmail.com>
 <1291801990.5992.105.camel@i7.infradead.org>
 <20101208174603.GA7107@core.coreip.homeip.net>
 <20101208135105.a8482d46.randy.dunlap@oracle.com>
 <20101208221216.GA5649@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20101208221216.GA5649@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 08, 2010 at 02:12:17PM -0800, Dmitry Torokhov wrote:
> On Wed, Dec 08, 2010 at 01:51:05PM -0800, Randy Dunlap wrote:
> > On Wed, 8 Dec 2010 09:46:04 -0800 Dmitry Torokhov wrote:
> >=20
> > > On Wed, Dec 08, 2010 at 09:53:09AM +0000, David Woodhouse wrote:
> > > > On Wed, 2010-12-08 at 10:12 +0100, Corentin Chary wrote:
> > > > >=20
> > > > > I don't really see how it's a recursive dependency, but maybe it's
> > > > > time to clean this KConfig.
> > > > > What is our current policy about that ?
> > > > >=20
> > > > > I think we should *depends* on important subsystem (ACPI, INPUT, =
=2E..)
> > > > > and select obscure things so
> > > > > that the driver does not get lost if you don't enable the leds.
> > > >=20
> > > > A better policy is: "NEVER USE SELECT".
> > > >=20
> > >=20
> > > No, this is BS. User selecting, for example, a button driver should n=
ot
> > > care that it is working in polling mode only and needs polled device
> > > library to work. As it was said before, drivers need to depend on maj=
or
> > > subsystems and select minors and library modules.
> >=20
> > I dislike select, but reality is that modules do need to select/enable
> > library code and minor features sometimes.
> >=20
> > OTOH, where drivers/platform/x86/Kconfig:ACPI_CMPC does "select INPUT"
> > to enable an entire subsystem is wrong and bad IMO.
>=20
> I am 50/50 here. On one hand selecting whole subsystems may not be the
> best option, on the other hand (depending on how Kconfig is organized)
> it might make sense. Consider you have an USB joystick. You are in
> input, in joystick sub-menu, which comes _before_ USB. If you happen to
> have USB disabled then you, with your scheme, will not see the entry for
> the joystick. You will have to go into USB menu, activate USB and then
> go back and scan menus that you already been to for any new options. And
> again, and again. Not very friendly and so right now USB input devices
> do depend on INPUT, select USB and depend on USB_ARCH_HAS_HCD (to make
> sure USB can be activated).
>=20
> Also, in case of CMPC, the user wants to support _all_ features of
> his/her laptop which is kind of useless without input, right?

Thanks, Dmitry, for building the case for CMPC. Besides input devices,
classmate-laptop only supports a single rfkill device. Currently, using
the driver without rfkill support is possible. That's not the case when
the input subsystem is disabled. I would like the user to go the the
platform/x86 menu and say 'hey, classmate support'.

That would however, be an argument for using select for everything, or
making depends work just like some dependencies resolvers work in
package management systems, like apt. OTOH, that would imply in lots of
undesired questions when someone does not want to enable anything that
depends on USB (or any bus or subsystem) at all.

For the case of CMPC, the user has already entered the platform/x86
menu. The CMPC option will not be visible if INPUT has been disabled.
And select works just fine here, since INPUT does not depend on
anything. OTOH, INPUT can only be disabled if EMBEDDED is enabled. And
if the user has done that, user must know what user is doing. So, if the
rule of thumb is that major subsystems should not be selected, I'd be
willing to submit of ack a patch fixing that.

Regards,
Cascardo.

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJNAAicAAoJEEWxSg7udFZIB9cQAMKDfM6DdP4giObX9ZlqDrSN
KtiEHqZvHVOSBDgY2EIFcUZuOPSpYfV0ckbUt6TQojIGR44EpbzJuk8WCeQPcgUe
g2ZxlZuRew+U7sBdaDu4itcUfxk4qdIGMfzYwIZau7n7DOS7hXUUq0KFSvaRki7e
lAs4g5lAQNdi0u65Z0k/rFewFzj9jdk4969Z4pvEpICAvEI5oIoTgMX1xv/HdxHp
7Mm0BZJBlZlQtpIVncx9tiXBi3/jxflDNVcS6RgufJXqE81VlgVLFw8NVcsmv78M
C9M48QeCbKfjPka0Be8GvXSKzlJ2IeqziqVkIizgIQzNS+eUufSo9F6s/++QfciK
yeQIhqcUh3Bpexh8HEISI+uLfWaN3e/1rNKdEYbRjaKByLJmhBI+xFLRDbb8LHFU
ELPRFzyZS62o/HkkN5vHWRPDeUPJLZKcWL11KZMyb68r2TaGRJyl327dUWN3tkOi
1samfRgBolDFc1u8xqLcW9l7sGyBe3KumYq4sJ+h3rznh5i5AwMeasWZ2OdTfk+7
P+aKyr+Lf2Yiu9rzlni8uQ5wvU4GZp6Zp5gobJhnh/I+//2Cvga7fx1YLYg/PkMB
dkOyVijeh0hAGnlBbyVCF9KHECyK41VS4mgTnN8VvjpAl2VO5n+ILRVBDcaOi4pN
jCkO+gJn6SvUzGXLCmT6
=58e2
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
