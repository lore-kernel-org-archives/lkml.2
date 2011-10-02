Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab1JBS4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:56:22 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:57926 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716Ab1JBS4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:56:16 -0400
Date: Sun, 2 Oct 2011 21:56:09 +0300
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 15/30] usb/musb: use a Kconfig choice to pick the right
 DMA method
Message-ID: <20111002185608.GA25690@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-16-git-send-email-arnd@arndb.de>
 <20111002161447.GC12323@n2100.arm.linux.org.uk>
 <1757336.Qk72n3s00p@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <1757336.Qk72n3s00p@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Oct 02, 2011 at 08:00:31PM +0200, Arnd Bergmann wrote:
> On Sunday 02 October 2011 17:14:47 Russell King - ARM Linux wrote:
> > On Sun, Oct 02, 2011 at 04:45:45PM +0200, Arnd Bergmann wrote:
> > > The logic to allow only one DMA driver in MUSB is currently
> > > flawed, because it also allows picking no DMA driver at all
> > > and also not selecting PIO mode.
> > >=20
> > > Using a choice statement makes this foolproof for now and
> > > also simplifies the Makefile.
> > >=20
> > > Unfortunately, we will have to revisit this when we start
> > > supporting multiple ARM platforms in a single kernel binary,
> > > because at that point we will actually need to select
> > > multiple DMA drivers and pick the right one at run-time.
> >=20
> > I thought there was some work going on to convert this to use the
> > dmaengine stuff?
>=20
> That would certainly be the best solution here, I wasn't aware
> that it has already been discussed.
>=20
> Unfortunately, even with the dma parts out of the way there is
> a lot that needs to be done to make musb, ehci or ohci
> really cross-platform. Right now, you can only have one
> platform driver glue for each of those drivers, and they

that's not true for musb. I can already compile am35x and omap2430
together. TUSB is a different story though. With a small effort, we
could also allow DaVinci and the like to compile cleanly and work.

> should eventually be converted to a large library module for
> the core, with independent platform driver front-end, similar

that's how MUSB works now and that's what I have been discussing with
Alan Stern for the past month or so, wrt to *HCI. There are even patches
floating on linux-usb right now trying to hash out the problems.

Maybe you should have consulted the maintainers of those drivers before
making such statements.

MUSB is not the best example because of its history. I understand the
DMA part is still really messy, but we have been working very hard to
hash the problems and still allow new glue layers to be merged.

How about taking a sneak pick at what the code does right now ? As of
today, I can even even have *all* UDC controller drivers into one kernel
and I generally compile x86 with all controllers available. There's some
very small work that has to be done on each of the UDC drivers to remove
any references to <arch/..> <asm/..> and <plat/..> headers but that work
in in progress.

Also, when sending USB patches, be sure to Cc linux-usb@vger where most
of the discussion is happening.

--=20
balbi

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOiLPIAAoJEAv8Txj19kN191wH/3b4CBnKS2hwhKbrh1fHxkhL
bbtL6AG/HzwG9nrRjBalCOuw2WlOGMPbFZoFdTZQ8DMIlaaK6pyaC3P8iNnVeNgC
8Q6NUCT2Aj9M01vhs0zo5IJ8X1QlXktQld2W5UR5oSHe5yfMNACfnZ88ljhPJxL3
os6fFBxZVNbEUIvgzsh+NpGaSqYTLLInPtsvTKDHPSTx4vmHFEfwaXmoCffg7afq
ZV3OBQ6QPjg9J2jxy5VqytmCSGdtMjWKIZ7xVUR+gpArT3hDA+NwqAC6YvvM/Irw
1gT21fs5Bw8i2jFoZaLSui8BXUqIt31OAAiRwML3tIIOfJYsQp6zzTMcTQEPwlo=
=+RyM
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
