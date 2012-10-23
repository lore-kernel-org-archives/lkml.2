Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299Ab2JWR00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 13:26:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:32950 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313Ab2JWR0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 13:26:25 -0400
Date: Tue, 23 Oct 2012 20:20:35 +0300
From: Felipe Balbi <balbi@ti.com>
To: Mitch Bradley <wmb@firmworks.com>
CC: <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        Sourav Poddar <sourav.poddar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121023172035.GB32167@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121022155028.GA13791@core.coreip.homeip.net>
 <CACRpkdaQ1WfRWrx=RXMVkeFtwdERJsOpVa3DaXBTU2KZdgqhRQ@mail.gmail.com>
 <508664CA.7000601@ti.com>
 <CACRpkdbhCS-Vb0DtbTZQ_Zw_8SOh3Bqutme3Y2-QrxNqvMiNNw@mail.gmail.com>
 <20121023100333.GA24418@arwen.pp.htv.fi>
 <5086CD91.9070101@firmworks.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aM3YZ0Iwxop3KEKx"
Content-Disposition: inline
In-Reply-To: <5086CD91.9070101@firmworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Tue, Oct 23, 2012 at 07:02:09AM -1000, Mitch Bradley wrote:
> On 10/23/2012 12:03 AM, Felipe Balbi wrote:
> > Hi,
> >=20
> > I much prefer having drivers explicitly manage all their resources,
> > which would mean that pinctrl calls need to be done on probe() and, if
> > necessary, during suspend()/resume().
>=20
>=20
> Per-driver resource management is certainly convenient when you are
> dealing with a single system, but it becomes difficult to maintain for
> drivers that are shared among many platforms.

why ? look at drivers/usb/dwc3/, we're using that on OMAP, exynos, PCIe
and a couple of different FPGA implementations inside TI. Not to mention
what other licensees of that IP core might have internally.

So far no problesm with resources at all.

We have frameworks exactly to hide the differences.

> The industry trend for many years has been consolidation around a single
> programming model per class of device.  For example, SDHCI, EHCI, ATA.
> This trend will only accelerate, as the cost of developing controller IP
> and associated drivers increases.  Such drivers need to be as
> platform-agnostic as possible.

that's why we have pinctrl framework to abstract the details about pin
muxing.

--=20
balbi

--aM3YZ0Iwxop3KEKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhtHjAAoJEIaOsuA1yqRERJEP/R6cAsvh0r9QFsWN82uTznoV
D2NSMKDmLN4cxWRorxC4zgUwNHfzvf3YsGtyYS4fZzZkU0kLL6c167qOywQaYa9R
hO502+sQuYxa4zY4+9Fb4hdT75zLxh1mRjC4KrX+qf1pHk3mhBS8GS9XLGYwwmtj
R1HXk8cu4zm1MxUkOTFjsf0hgOv6KwPH6p56qY5to0W9yt4PrHyg5C1pePhHzIv1
JK8YtKgJkVLoI/uPfrVUW1RyiuOURK7cQQuEn4Ym0j42GsUsblmAYHx6vvLs17B5
RPs+q9WcJf7s4RF21CWcbHMvXnMe1NiZuKe4l++bG0wxb+8nm6rAIrAN8NE6xxwt
PDithANABIM7fOhpVyBpA+swpSGG4wAr1i4cgNfnoQtHxY+Wi1lAg/lHaPfQKItM
mYny9/6u51xZJTX8VkTF3wiLBpbDKbBSpYms8akw/rLSfnn6zshizpriR45iasF9
hR+q3yQc4JU1gHyxBIzq480ggxrckp40vBt5lSDYOl7v0HFPKflJiAwiCB5Kd4ot
bJGwP2FWSnN/6rSJy0RJ4RAe6jxZVXFiveZqb/UvznOQx1beYMUy4kwtMfXwbx5t
rglHz0YTEMLhQuYiTmF/Sn8VuMz7v8JLYbiBrVem7Qe2mZII0pg6+qhCeAbx306H
6f7SBn9e7iN2eTJgVc6h
=+NdR
-----END PGP SIGNATURE-----

--aM3YZ0Iwxop3KEKx--
