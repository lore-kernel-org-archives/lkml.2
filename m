Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab1F1Mdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:33:37 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:44907 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757544Ab1F1McX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 08:32:23 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jun 2011 08:32:23 EDT
Date: Tue, 28 Jun 2011 15:26:51 +0300
From: Felipe Balbi <balbi@ti.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: balbi@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        avictor.za@gmail.com
Subject: Re: [PATCH] AT91: add AT91SAM9X5 dummy configuration variable
Message-ID: <20110628122650.GK2612@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309260927-11411-1-git-send-email-nicolas.ferre@atmel.com>
 <20110628103549.GG2612@legolas.emea.dhcp.ti.com>
 <4E09C573.2030607@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kkcDP0v44wDpNmbp"
Content-Disposition: inline
In-Reply-To: <4E09C573.2030607@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kkcDP0v44wDpNmbp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 28, 2011 at 02:13:39PM +0200, Nicolas Ferre wrote:
> Le 28/06/2011 12:35, Felipe Balbi :
> > On Tue, Jun 28, 2011 at 01:35:27PM +0200, Nicolas Ferre wrote:
> >> Add this Kconfig variable to ease the submission of this chip support.
> >> As this chip/board inclusion is dealayed due to deep consolidation of
> >> arm/mach-at91 sources, we include this dummy configuration variable to=
 allow
> >> submission of SAM9x5 related drivers in other subsystems.
> >=20
> > Why are the drivers even depending on this ? They should be portable
> > enough. Can you share a few drivers so we have a look ?
>=20
> Yes sure. The dependence is only on the Kconfig side: I plan to make
> some drivers dependent on this configuration variable.
> The goal is to submit the final driver addition without having to send
> again a correction to the Kconfig after the chip/board support is merged.

my point is that the drivers shouldn't need that ;-) Are the controllers
Atmel's specific or are you guys sourcing from somewhere else ?

> This will ease the submission process at the cost of a two lines dummy
> patch and will remove interdependence between subsystem trees: it worth
> it, is not it?

if you remove any architecture dependency from the driver, why do you
even need these two lines ? ;-)

> > IMHO, the whole idea of the consolidation is beyond arch/arm, drivers
> > should be affected too.
>=20
> Yes sure, I also understood like this.
> I will not spread ARCH_AT91SAM9X5 ifdef in driver code...

yet you will prevent the driver from being easily used by other
architectures. What will happen is that a certain amount of:

depends on (ARCH_AT91SAM9X5 || ARCH_FOO || ARCH_BAR || ARCH_BAZ)

will continue to proliferate.

Here are a few questions:

i) The drivers you're willing to send, are those for Atmel's IPs or are
	the IPs sourced from some other company ?

ii) Even if they are Atmel-specific, do you see the possibility of Atmel
	licensing them ?

iii) Does your driver current depend on asm/ or mach/ headers ?

iv) Is there a generic header which you could use instead of asm/ mach/ ?

If you could share the driver, it would be easier to review on that one.

--=20
balbi

--kkcDP0v44wDpNmbp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOCciKAAoJEAv8Txj19kN12bwIAI9kX35j1l0nWkfHhCRsiyAG
FrNxiEauilW76H1K4EDv+NoUhtK9ORAYgwVAgb0K899fhN58F/4n1oCbyn/yIjp8
C4fV6w56u26Wb2cDZ+fCrYqEFs2cnRhp758mqgM5z/3WLdDb0U5OjpCNSmiy5VJn
mtjq6OjFfw6y1sWXmze/c+XxwAmNmNmm3eDqbNbda4Q0DGklVvdoyu6MZ/O1df47
sHs7tk0oM0GNKeXyB7YT5nP5jI5+cYz5Q3vuqXDDNeFkhR1MfXogRvCq5hjyaqfg
bFzQc1ruuNhrIxCYux6MmnDeFmak7esbooDWKgFEGwCfFXrCd5N10DMbnLq/POw=
=84dB
-----END PGP SIGNATURE-----

--kkcDP0v44wDpNmbp--
