Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab2K3JlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 04:41:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50981 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2K3JlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 04:41:01 -0500
Date: Fri, 30 Nov 2012 10:40:44 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: SPARC and OF_GPIO
Message-ID: <20121130094044.GA3053@avionic-0098.adnet.avionic-design.de>
References: <20121105095315.GG5847@avionic-0098.mockup.avionic-design.de>
 <20121106.184058.636480855516538607.davem@davemloft.net>
 <20121107065258.GA22325@avionic-0098.mockup.avionic-design.de>
 <20121107.023419.1656398773495533906.davem@davemloft.net>
 <20121130093520.631503E070C@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20121130093520.631503E070C@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Vc7t0qUEcVsd00BPrKeuCHxfy/kHWW163i0A0hk1rb7
 0qdMg/Trqt9F1E43blu9jQJKaLzZsl9SydT8zp6+l8KCzTZrfw
 HyIqcV+gSYQxnbPyCJWz7dSUCcdAmXoareq76dIKvPX6d2SD1L
 fsNhDXAY3dADxtPLNar7oJ1vEQDpvlCUZZurFxPu7yy3wVh1YC
 QqigwBPsBmJJ5/P57Ty9q8EACMmTQ5x1yna5+lmyH7SKUa6ja8
 wfhc534Ae5c3RA+fAsapQ9CY/vyDUSUvGFLCjilFg3OdQTlTRw
 iqUvm/tq/Wxvlmy5nMGfEkf0AGI3fcLSZq5JPEMT9mfmJWrKV3
 cY01ZvG4dUuZktqvlJYJBuBFrYQpJFViZG0qEYU6rxJRmeZA95
 iFQRzH2NKC84pdioKUUNOEwTDULIsr2MB0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 30, 2012 at 09:35:20AM +0000, Grant Likely wrote:
> On Wed, 07 Nov 2012 02:34:19 -0500 (EST), David Miller <davem@davemloft.n=
et> wrote:
> > From: Thierry Reding <thierry.reding@avionic-design.de>
> > Date: Wed, 7 Nov 2012 07:52:58 +0100
> >=20
> > > It seems like OF_ADDRESS would be trickier. A comment around line 60 =
in
> > > drivers/of/platform.c says that SPARC doesn't need functions defined =
in
> > > the enclosing #ifdef CONFIG_OF_ADDRESS block. I'm not sure it would be
> > > acceptable to remove the conflict nonetheless, even if the functions
> > > aren't used. One benefit would be that the code could receive some ex=
tra
> > > compile coverage.
> >  ...
> > > Finally, OF_IRQ is again just generic code to map device tree data to
> > > IRQ domains. While I didn't see the IRQ_DOMAIN symbol selected anywhe=
re
> > > in SPARC it should still be possible to run drivers that properly
> > > implement IRQ domains on SPARC, right? Or is there any reason why they
> > > wouldn't work?
> >=20
> > These are the two most conflicted areas for Sparc.
> >=20
> > For addresses, we fully compute the full fully resolved physical
> > address of all registers of an OF device very early at bootup time
> > when we first scan the device tree.
> >=20
> > Same goes for interrupts, we fully compute them early in the bootup
> > process.
>=20
> Right. That's the reason I haven't tackled making all architectures do
> the same thing. I've not been confident that I'd get the sparc bits
> correct. I think it could be done, but I haven't been able to wrap my
> brain around it sufficiently.
>=20
> On non-sparc I've actually been moving in the direction of resolving
> resources at .probe time to make it easier to handle deferred probing.
> So if, for example, a device irq line is routed to a GPIO instead of the
> core interrupt controller, then the irq number won't be known until
> after the gpio driver .probe occurs. For addresses, this situation is
> unlikely, but for all the other kinds of resources (gpios, regs, clocks, =
irqs,
> etc) it is a problem that we're actually seeing.

Interesting. I have some I2C devices that run into the problem where
their interrupts cannot be resolved at instantiation time so I've had to
work around it by calling irq_of_parse_and_map() at .probe() time and
return -EPROBE_DEFER if that return NO_IRQ.

Are any of your plans documented somewhere? I'd be interested to know
how this is supposed to be solved. irq_of_parse_and_map() is not going
to work for non-DT setups so the above can't be a proper solution.

Thierry

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQuH8cAAoJEN0jrNd/PrOhj9kP/Rx7j/G7+W2Lt9mPYt27DFz9
smpzyWaaZ8wCYeEyjTVM91qVQt2BGTdg6YKUGHIqccra7jR/l2eMmujV2+Xkoa1h
LDYrwFknVaq+2H08aNh9bswk5vtWa2bF39LwnXnNvSTtqRNrfxaIwtrCw0PSL7XS
ekx7EQm/SyeN7jZeW8a86wY33R5/chJqSc4MMuXCCK05ILvVUr6tc0dNC9ihyf6E
dgmzP1M/JXW4B9BC14liVPDxFHzdi6mehX2uQHo83NPEXi7pfJmAoa8hLvg/i2sb
+I1nGNuRNdUpLUDOJYkiQ9WH4heAVxaMON86NNgpYI76FdNvyavtVXe7I2vh5/m/
QdXqx51HMcGNMtGM24sGMv9qxkkDfvEzUQNF3+aHGpTR+8LGyV0xWrGhstab3p6a
MQziLNW3akVqOiC0OdRxFPeM3zC/yGd8z98X6JvCq2bWvVt8xPFqM4X902MGZcLd
MlL+z/hfgnmIo0X2SB0plcBh1Ju/Q3sIccQcvpK72AEC7kBguIukD4y41m332Vbh
cMEwHTmbwJL3Q0X47SVRuEqLwRKcoySqN8K1WWQxv8qgbbuPiwZOVvqS9iKQZwSC
W7iJMvFu9hTozGiMgqO2JtHlbvv6A8iC3i/CJjVryUJB/64ABHJ4VpN9k5W+X7ej
nMFdh6TQEHOTjleK1cJW
=gO1u
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
