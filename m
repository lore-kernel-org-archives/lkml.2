Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab1F2Pjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:39:42 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:49136 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756751Ab1F2Pji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:39:38 -0400
Date: Wed, 29 Jun 2011 18:39:33 +0300
From: Felipe Balbi <balbi@ti.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: balbi@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        avictor.za@gmail.com
Subject: Re: [PATCH] AT91: add AT91SAM9X5 dummy configuration variable
Message-ID: <20110629153932.GB2760@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309260927-11411-1-git-send-email-nicolas.ferre@atmel.com>
 <20110628103549.GG2612@legolas.emea.dhcp.ti.com>
 <4E09C573.2030607@atmel.com>
 <20110628122650.GK2612@legolas.emea.dhcp.ti.com>
 <4E0B43BA.803@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="te9Bkl2b4W0C+FfQ"
Content-Disposition: inline
In-Reply-To: <4E0B43BA.803@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--te9Bkl2b4W0C+FfQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 29, 2011 at 05:24:42PM +0200, Nicolas Ferre wrote:
> > yet you will prevent the driver from being easily used by other
> > architectures. What will happen is that a certain amount of:
> >=20
> > depends on (ARCH_AT91SAM9X5 || ARCH_FOO || ARCH_BAR || ARCH_BAZ)
>=20
> Yes, exactly like:
>=20
> config USB_GADGET_ATMEL_USBA
> [..]
>         depends on AVR32 || ARCH_AT91CAP9 || ARCH_AT91SAM9RL || ARCH_AT91=
SAM9G45
>=20
> or
>=20
> config MMC_ATMELMCI_DMA
> [..]
>         depends on MMC_ATMELMCI && (AVR32 || ARCH_AT91SAM9G45) && DMA_ENG=
INE && EXPERIMENTAL
>=20
> or=20
>=20
> config TOUCHSCREEN_ATMEL_TSADCC
> [..]
>         depends on ARCH_AT91SAM9RL || ARCH_AT91SAM9G45

are you saying that's correct ? Well, I see those are platform_drivers,
so it's probably some IP integrated inside ATMEL chips. Now, what if the
same IP is used by some other SoC ? I mean, other than AT91* even.

> Those are places where I wanted to add my little ARCH_AT91SAM9X5...

After a couple years, someone else comes with another patch adding
ARCH_AT91SAMXXX and ARCH_AT91SAMYYY and ARCH_AT91_SAMZZZ...

But then again, at the end of the day Russell is the final judge :-) I
just wanted to say that it's far better to remove those dependencies and
allow those drivers to be built as modules rather than keep adding
dependencies to the end of times ;-)

> And as Jean-Christophe said, when those lines are getting too long, we
> change this to a nice: HAVE_xxx config option.
>=20
> > will continue to proliferate.
>=20
> So what?
> It will:
> - ease xconfig/menuconfig reading by user: who cares about my Atmel
> driver while running OMAPs?

what if in a couple of years comes one OMAP with the same IP that you're
using ? ;-)

it's rather unlikely, but for a simple example look at how many
Cortex-A9 MPCore Interrupt Controller drivers we have under arch/arm/
where it would be simpler to have _one_ driver being re-used by many
archs ;-)

> - ease user choice by selecting default values depending on chip
> availability

IMHO, it's far simpler to answer 'M' to a driver such as a touchscreen
controller without even thinking about it ;-)

> > Here are a few questions:
> > i) The drivers you're willing to send, are those for Atmel's IPs or are
> > 	the IPs sourced from some other company ?
> > ii) Even if they are Atmel-specific, do you see the possibility of Atmel
> > 	licensing them ?
> > iii) Does your driver current depend on asm/ or mach/ headers ?
> > iv) Is there a generic header which you could use instead of asm/ mach/=
 ?
>=20
> I just want to hide drivers that are not relevant for others: I have
> the feeling that it is a good practice. This tiny patch will ease this
> during my publication flow. Do you seriously care?

Well, it's not that I care. I just don't see the point in hiding the
drivers. For starters we loose the very nice linux-next infrastructure
for giving us compile tests ;-)

--=20
balbi

--te9Bkl2b4W0C+FfQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOC0c0AAoJEAv8Txj19kN1FHIH/ioNYDVe4srqjofVAl0A5RJj
alfD/ccq959mNrWdqiOqJO0W6B1UtwmGBPrXfsDV4J3Kiajvg8IHT4xP2EgMXSg4
2hTfqkOa3ytwPJzCB+tLgMqCK/5uQpgMCekAcyWgAfhMZcYspUVh7PEce0IDGU+/
qPEXM8jkNOpiPKxKIEKppAjs9R2vHHhgHjPD7+Zoj/muz2F5Agcdq5KRdpkFcA+2
CJiqePTvHK0hX/0fRCQh8yEGsx5Xc6ZI3RFs3XXF6Y9/n+9qfLmJL7fKEnqcKH2Z
BOhDrgMWkssO+AX6cNhSgvPqyIhAnouywaSX1lf4Nd+PCusxRfvKpLbsB6pX7EI=
=h/tn
-----END PGP SIGNATURE-----

--te9Bkl2b4W0C+FfQ--
