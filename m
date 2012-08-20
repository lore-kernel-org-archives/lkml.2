Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab2HTMLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 08:11:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51706 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038Ab2HTMK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 08:10:58 -0400
Date: Mon, 20 Aug 2012 13:10:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 5/8] mfd: Provide the PRCMU with its own IRQ domain
Message-ID: <20120820121055.GA26991@opensource.wolfsonmicro.com>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
 <1344527635-6163-6-git-send-email-lee.jones@linaro.org>
 <CACRpkdZ7bMBytyDppV2sB1d1sUbDpPRqAQVOq8k4UOYdmg+Mkw@mail.gmail.com>
 <201208140942.54773.arnd@arndb.de>
 <CACRpkdYbOBEPNbCdfi+=gupdqS8_7t7MpOgXs7VCVTs8Y3j_mQ@mail.gmail.com>
 <20120820083640.GH8450@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20120820083640.GH8450@gmail.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 20, 2012 at 09:36:43AM +0100, Lee Jones wrote:
> On Tue, Aug 14, 2012 at 12:44:37PM +0200, Linus Walleij wrote:

> > Yes but I think I saw this other patch set from Lee, hitting
> > irqdomain, OF and MFD to actually fix this ... or did I get
> > it wrong?

> No, you're not wrong.

> Historically (in my patches) xb8500_irq_get_virq() was used by drivers
> to obtain a VIRQ when not using Device Tree. Now the MFD core handles
> conversion there is little requirement for it. In fact there are no
> more users for db8500_irq_get_virq() and only one user for=20
> ab8500_irq_get_virq() and that's itself. I guess we can rid them and
> call irq_get_mapping() directly instead.

Oh dear.  Unfortunately whoever added this support to the MFD core did
so in such a manner that it's only supported for device tree systems
and only for devices which express the MFD cells as device tree nodes
which means that most devices can't it - db8500 has got a reasonably
unusual combination there.

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQMik4AAoJEFJkBDiqVpZ47nIQAIm1B6EY4PuHXk1xOAwfDb1n
eJ5ZpW7o9YbAb8579XgpYft1Y490wQDHUPvvXvjnYsFsQGFU8H7xZgPbqgy6WkwC
LqvHnHLgDScdjT9OrygFWCGK1IKS8K3zsRAIij74/PsRlrUuGlNqCXuSB1+7t0tz
BWPvByecvuS5JIOlI0Sm5/QNsYHVR9laj46A7LRg/qs4OeOVPao9wsmOvVhwBVRo
05wObknMqIv4C+thpiYhsfqLG6/q6J2AxI8TqMKzZDm0RPn+fCmt2WXZGwnStTP5
2EwdxLCH8sgjFpYTEu3JfywEqLTEvrCrgFsGPeXRcrjvQvbV3iybIih38P6SU3/k
gdQCTj/d+lYHuXVadW4jOhwmUMkcs+ZDQeqW+tAm3aMvPazgPgdbCFfDxwzKIDEr
cyxRNlxxsQaBo+YY2wA89zsfwYScmDhLndSFEdQvSSLcqssz1nvACvb9/Z2G3PI/
CYfMF82NAtWmFujDFqKYCkZIQffOS9ey5jNmaob8N7S/pK61RrBw4cIHwo7y43hF
oly9B10NqYLF4wLxLMGMxaG2I+8nhZZNVpQslOvqW+S2UHydEZDkQZiYhgnjkpR2
K4Id6FH+dVn00PlZinV749G+UGTkKS1mUr6RdgBGd9ixnZMl/z1vpm2fjioi8ASF
0PM1Je4DRTph6x6UjAp/
=3lJ1
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
