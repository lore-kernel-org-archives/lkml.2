Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab0FUPpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:45:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53126 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab0FUPpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:45:18 -0400
Date: Mon, 21 Jun 2010 17:45:14 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Rabin VINCENT <rabin.vincent@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "l.fu@pengutronix.de" <l.fu@pengutronix.de>
Subject: Re: [PATCH 1/3] mfd: add STMPExxxx I/O Expander support
Message-ID: <20100621154514.GA416@pengutronix.de>
Mail-Followup-To: Rabin VINCENT <rabin.vincent@stericsson.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	"l.fu@pengutronix.de" <l.fu@pengutronix.de>
References: <1275308236-1775-1-git-send-email-rabin.vincent@stericsson.com> <20100618234222.GL3582@sortiz.org> <20100621133305.GA2744@bnru02.bnr.st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20100621133305.GA2744@bnru02.bnr.st.com>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:30:53 up 14 days,  7:58, 58 users,  load average: 0.33, 0.60,
	1.19
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 21, 2010 at 07:03:07PM +0530, Rabin VINCENT wrote:
> On Sat, Jun 19, 2010 at 01:42:24 +0200, Samuel Ortiz wrote:
> > On Mon, May 31, 2010 at 05:47:14PM +0530, Rabin Vincent wrote:
> > > Add support for the STMPExxxx family of I/O Expanders from
> > > STMicroelectronics.  These devices include upto 24 gpios, a PWM
> > > controller, and a keypad controller.  This patch adds the MFD core.
> > The patchset looks fairly good, but before merging it I'd like to know =
of we
> > could merge it with this one:
> > https://patchwork.kernel.org/patch/106173/
> >=20
> > I don't know enough about the hardware, and although the register layou=
ts don't
> > look like they have much in common, I'd like to know from the actual HW
> > manufacturer (i.e. you :)) if there's something we can do here.
>=20
> I don't have any inside information about these parts (we just use them
> on our U8500 dev boards), but all the datasheets are publicly
> available[1].  There seems to be more than a dozen variants of this MFD
> with varying combinations of devices.
>=20
> [1] http://www.st.com/stonline/stappl/productcatalog/app?path=3D/pages/st=
com/PcStComPartNumberSearch.searchPartNumber&search=3Dstmpe
>=20
> On Sat, Jun 19, 2010 at 15:50:16 +0200, Luotao Fu wrote:
> > hmm, I took a quick look into the core driver. The register layout
> > seems, as Samuel mentioned, quite different. However, the r/w
> > functionalities and irq handling are quite the same. For now I'd say
> > that should be possible to merge the stuff.
>=20
> The IRQ handling and GPIO block seem to be about the same (registers are
> at different offsets, but this is also the case between STMPE1601 and
> STMPE24XX and is thus already handled in the STMPExxxx driver).  The
> STMPExxxx GPIO driver should also already be able to handle a variant
> with lesser gpios, such as STMPE811.
>=20
> Similarities:
>  - I2C access functions
>  - GPIO block (same registers, different offsets)
>  - IRQ block (same registers and handling, different irqs and different
>    register offsets)
>=20
> Differences:
>  - Different blocks (but sharing between different groups of variants)
>  - SYSCTRL register bits (reset, clock enabling)
>  - GPIO altfunc bits
>  - The STMPE811 also has a SPI interface, while most other support only I=
2C
>    This is also not avaiabile in Luotao's driver so I'm not addressing
>    this for now.
>=20
I2C is the most common usage variant. Otherwise adding spi access
routines should be no big deal. Some additional to the probe function
might be needed besides the r/w core functions. I do think that we leave
the stuff this way and take care of them if somebody does need SPI.

> Here's a preliminary patch (untested!) which shows how the STMPExxx can
> be made more generic to support 811 and hopefully other variants.  If
> this looks sane, I'll complete it up, fold it in, and repost the
> STMPExxxx series for review and also 811 testing and touchscreen
> addition from Luotao.
>=20

I'll test the patch as soon as I can. Do you have any public GIT tree
with the stmpexxx stuffs in them, so that I might be able to merge it
with my board stuffs directly?

cheers
Luotao Fu

--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwfiQoACgkQkLuxfMCkDTbATwCfXeWoIQaYZDy4egahQRydHb7k
tjIAnRiM3CAuwH3L2KNQBrmqYhY2ccQe
=3gbp
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
