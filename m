Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab2CVLPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 07:15:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42033 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932104Ab2CVLPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 07:15:37 -0400
Date: Thu, 22 Mar 2012 11:15:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] clk: wm831x: Add initial WM831x clock driver
Message-ID: <20120322111531.GA3091@opensource.wolfsonmicro.com>
References: <1332360082-25092-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1332360082-25092-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120321222622.GG29317@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <20120321222622.GG29317@pengutronix.de>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 21, 2012 at 11:26:22PM +0100, Sascha Hauer wrote:
> On Wed, Mar 21, 2012 at 08:01:22PM +0000, Mark Brown wrote:

> > +	if (!clk_register(&pdev->dev, "xtal", &wm831x_xtal_ops,
> > +			  &clkdata->xtal_hw, NULL, 0, CLK_IS_ROOT))
> > +		return -EINVAL;

> The clock names are unique identifiers for the clock, so clocks in
> drivers should probably have dev_name encoded into them.

No, that's not sensible.  We shouldn't be open coding this into each
individual driver that provides clocks, and we shouldn't have clock
users having to guess at what scheme the driver author used to dedupe
the clocks.  As a driver author you would assume that the reason we're
providing the struct device to the registration function in the first
place is so that the core has the information it needs to do that.

I did provide patches to do what you suggest in the core for one of the
earlier versions of the API, I have to say I didn't check to see if they
got dropped during the general lulls.

> You could also use the fixed rate generic clock here.

It doesn't really do what I want with reporting the enables - for
diagnostic purposes I wanted to always have the clock present but
non-enablable so we could actually look at the clock tree and see=20
what's going on directly when there's no clock coming out.

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPawnLAAoJEBus8iNuMP3dNqkP/3I86zyJkd8uoFjeesgGhr8L
sUFf5roRQfxD78ejWXKwmZWtZOfUMr98QfRQjGXcQ9w0zbskVU/HHipjvD2nWWM/
9dCefleZ+/x5xEfRSH93OL0CVJy/HnfRMBxcw92eqr0DBN75PKnLaA0FRequ5SWr
DGqvtmGkWQSu4ls0Xou680Iw2N7iYeoEEuu2++OUYgD25RJKJjDsgs4L6iS6XbRT
9kVHllF/s20xwF/YQXgFRX5bzULTbmJkSWdXkH71RSjdQE4KjRsPAqrZXTGG0IHB
hhSH4LO0K+PnXLPTkZdb7dHlMsUmWPI9RV/qq5GlrT1t042kG9qUqp4QA144q7nJ
PWUXj1sbUy6BWes1e+0StDTDkPBjjR8J9e89VLyFrXmCUwnTbwDcNJHgVg+g13hF
WjtoKLL2gEY1aXXWfZ28k0ywSiOQyc/LZPGyBtrvU6rajUC7icAqZyJjQ9MYv0ot
vHzT8tTjD1ANAQN19zod1yIRG/rj+2WfakNNaBiRomQAs9vAXfYSAuDy8MNeYeAa
/X13QulrNfO4EymgdoYII1AzTPEulGjrtqEBzOs9sEy2pWtHvq84vCGpfPsla3R8
T5JJNwhyoERMuCiiAqkPf/As/vAvJdUw8qKnoNsNYV/PonxVW01lbJUJrDV8/63y
9Qv7k/MCZ1WK9D3bVtYM
=3tX6
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
