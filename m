Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1JBWLF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 18:11:05 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:34365 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913Ab1JBWK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 18:10:58 -0400
Date: Mon, 3 Oct 2011 01:10:51 +0300
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: balbi@ti.com, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 15/30] usb/musb: use a Kconfig choice to pick the right
 DMA method
Message-ID: <20111002221050.GA25790@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1757336.Qk72n3s00p@wuerfel>
 <20111002185608.GA25690@legolas.emea.dhcp.ti.com>
 <1546914.88vcgxkfJf@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <1546914.88vcgxkfJf@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Oct 02, 2011 at 09:44:26PM +0200, Arnd Bergmann wrote:
> > that's how MUSB works now and that's what I have been discussing with
> > Alan Stern for the past month or so, wrt to *HCI. There are even patches
> > floating on linux-usb right now trying to hash out the problems.
>=20
> Ah, glad to see that is happening. I can probably get rid of a bunch
> of randconfig patches I have for those then.

glad to hear you're sorting out randconfig :-)

> > Maybe you should have consulted the maintainers of those drivers before
> > making such statements.
> >
> > MUSB is not the best example because of its history. I understand the
> > DMA part is still really messy, but we have been working very hard to
> > hash the problems and still allow new glue layers to be merged.
>=20
> Sorry if I have made my statement sound like an accusation, it wasn't
> meant as one, merely as a sigh at having identified yet another area
> that needs to be changed in order to have cross-platform ARM kernels
> working in every case.

no big deal ;-)

> > How about taking a sneak pick at what the code does right now ? As of
> > today, I can even even have all UDC controller drivers into one kernel
> > and I generally compile x86 with all controllers available. There's some
> > very small work that has to be done on each of the UDC drivers to remove
> > any references to <arch/..> <asm/..> and <plat/..> headers but that work
> > in in progress.
>=20
> I didn't really see any problems with UDC at all. What I saw were a lot
> of build problems with the musb host side, and I rewrote this patch half
> a dozen times before I ended up with a version that consistently built
> without making the code look worse.

I understand.

> I also agree that the musb implementation is less of a problem than
> ohci/ehci in its current form, as it already is layered in the right
> way. I did not attempt to turn the Kconfig 'choice' statement there
> into a flat list though, so I wouldn't know what problems to expect.

Actually, MUSB still has lots of goofage from the original mentor
release but that's another story.

Anyway, I'll take your patches in, but their too late for this merge
window :-( I already sent my last pull to Greg.

--=20
balbi

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOiOFqAAoJEAv8Txj19kN1tdEH/jW3GhCFAA1rHdmT4BjMZbJq
tM6bYwQs3EywLQeEglPEkChi0cLnB5obwPzlP2q8zbA9CS66t9uoJOHkHrXuQwqV
b9hg64Nzsm5yQHP2mrY3jpe/Xi0r/NBdDPBFQhyhNq5YsazeMf3W3quhPj2O6yzq
6LpenYkAAwQq1bZ/hlPbHKBJ/2UZmNDL7U85lVimXDsdfdj47hj7TTe7pN5pNrlm
oKtuvVqAA6PIL7N9q7pY4jmsdp2ISOg21omrpgORlGtK72X0VAb+PQHQqttWqdSv
MDNKNLpc4kebX4qrjslsi8t9Y89b5W86a3BYQTz6tI6ovmuJW+HXoUHy8aQuoDc=
=Mdj7
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
