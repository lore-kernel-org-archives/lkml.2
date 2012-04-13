Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab2DMJSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 05:18:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59540 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195Ab2DMJSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 05:18:33 -0400
Date: Fri, 13 Apr 2012 10:18:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH/RFC v2] ARM: amba: Remove AMBA level regulator support
Message-ID: <20120413091828.GJ3168@opensource.wolfsonmicro.com>
References: <1333306720-28344-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4F87EBFC.90000@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bWEb1MG/o7IKOlQF"
Content-Disposition: inline
In-Reply-To: <4F87EBFC.90000@stericsson.com>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bWEb1MG/o7IKOlQF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 13, 2012 at 11:03:56AM +0200, Ulf Hansson wrote:

> But, how should those amba drivers that implements runtime PM
> support be able to switch of the vcore regulator during normal
> suspend? In normal suspend case we can not use

A generic AMBA driver should have no idea about the implementation of
the particular SoC that it's integrated on to.  This applies even more
to system suspend (where drivers can generally just assume that they
will loose all power normally) than it does to runtime suspend.

> pm_runtime_put/pm_runtime_put_sync to trigger the power domain
> runtime functions to switch of vcore. This is kind of more generic
> problem when dealing with power domains, but as said this patch will
> have consequences.

The power domain gets callbacks on the system suspend path too and can
do whatever is sensible there.

> As far as I can see, the power domain must then implement a
> suspend_noirq function to make sure same things is done as for the
> runtime_suspend function. Do you agree with this as well or is there
> another option?

Yes, the power domain should just be handling this transparently.

--bWEb1MG/o7IKOlQF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPh+8MAAoJEBus8iNuMP3dDZwP/1qxctpI2J+iKn/IWKj5ThYw
XHThdzr9JOjRHW0LE/q+aoLMnMGvxDUKxivGl+Tv7CcrX8kR8SVydGPPYg8zhYRH
yQjGsidz7Fi9bm3/2RBOCh10YJKjaeDCGDt+h0lg27Ix5M6CgfWFOtB7GxScJugY
jvu/uwDUaTDWI8UQtDfoOnz6V2XHweLq1z2ziV9u3MD7LixaSvtu624stvm1+2D5
4aTyTlyAxAcG1qyZe7n98hR/3AcW9ecQ77n1TwUtt2ApfcYC2FkWIDwpIoNel+Y8
JhqJlzrbuW0yRzG1ueAuTmQIql6y4LO2mDQNzk2zWU2+bp95BJpJctvJB4Zt3vJM
IBLP0Q8rEYm1LiXIt9Lx6FwmbH/cmA76a1ok7cY5YrGzly//0T3mvLcdHklkdFKv
cUr3ss/UdBjaxxj9DR0x3FvY2vJ30svMRoniqghXhWuMot2UHCO1S6Vw56sgj5Z4
OztgmppoUy4QopU8PmHZUqgcFzVR0SgX2qkeh7YFUZ3QJYbF9sc8K675WntlV2uv
DgLDbB/nRa3VF5vkMw+QF5Y9ylveWLN9/deFdLhzOaJ3dqsMEmqJ5T5k8LSApVhd
zBxNTwisZGWC2Qjgz+UBxPQJWh39p4O+Bropti606B5zL98ulwZ65lSGZuF4c2OF
6sqco3Y5FLjAkqIq0IMn
=jBrg
-----END PGP SIGNATURE-----

--bWEb1MG/o7IKOlQF--
