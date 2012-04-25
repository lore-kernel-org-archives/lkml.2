Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab2DYICd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:02:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57266 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805Ab2DYICa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:02:30 -0400
Date: Wed, 25 Apr 2012 09:02:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] regulator: core: Keep boot_on regulators powered during
 init
Message-ID: <20120425080226.GA3195@opensource.wolfsonmicro.com>
References: <20120423101804.GA8318@opensource.wolfsonmicro.com>
 <4F953455.3080002@stericsson.com>
 <20120423110522.GB8318@opensource.wolfsonmicro.com>
 <4F95495D.4050508@stericsson.com>
 <20120423122555.GM8318@opensource.wolfsonmicro.com>
 <4F954ED6.2040201@stericsson.com>
 <20120423180140.GR8318@opensource.wolfsonmicro.com>
 <4F965FC4.7010502@stericsson.com>
 <20120424105603.GA12063@opensource.wolfsonmicro.com>
 <4F969FE8.7040500@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <4F969FE8.7040500@stericsson.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 24, 2012 at 02:43:20PM +0200, Ulf Hansson wrote:

> So if grabbing a reference, there is no good point in the code were
> I can drop it. Moreover _every_ host driver needs to handle this. It
> will likely become a "hack" is my first impression.

If it's something that every host driver needs to do then just factor it
into the framework and we're done...  The stuff you're trying to put in
the regulator API feels equally like it's a bodge and it seems to me
like we've just not thought of the best way for the MMC stack to figure
out and keep track of if it needs a regulator or not.

> >This just seems awfully fragile and very much dependant on things like
> >having the driver actually enabled to clean up later.

> Setting this constraint is not done be "default", it could be
> clearly be stated that the consumer must handle the enable/disable,
> otherwise the regulator will be left in the state it was when the
> kernel booted.

Right, but the whole point in having full constraints is to avoid that.
Users are supposed to set constraints to grant permissions for things,
not to work around internal problems in the rest of the stack.  If I
could see a general use case for the feature...  but I'm having trouble
doing that.

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPl6+MAAoJEBus8iNuMP3dfsIP/0tzFNoH2IvaYdNw61CveA+W
FfVh8NLm1fG2NWuIIKnyh0/Z8fT/Fu8Uxvq8zIm2+kDZY3BKZweHNTzqi7OrhYIS
58ecusNfOhkUorkgMYyabYuzIUXi5plWEbqEiJYe/K/ey8MnsE8KsxxqBKoX1csK
F4xNtP0nkfAsI8/0rm9RLFkacsOZHOQAf9QpLHiZkiK54HaQ25Tllv4f2Q0jmEnQ
20YKK9CivLsZPfdbWJO14K9OzYL3N4A7Pf+D16IoTW//ayChNtdJCVzCFTA/e1mT
shrUh4n1orbOYe2yrbVa0wlKFzwuAqMAzYcdwDhgCEi6pQhUsLRLZTU6OKmbzwxf
x2G475rwAt6oIKukjrMyOXo2jq5CesLR0bMgr57AtlwJ4iFPd6MqPfRiFVAZwhEQ
FCwm70lp2j6dzRP38dTVivZPUg3sKd3JeSGRPwa8AD5SRApYzEbPDRgtBDBcIR9J
vf5TO1GRjFaxFS/XPSXg+03J1UXW9GLiXhOk8bYjRjz1q+lC0PdPHmry5JkA3goq
oSX9qSIXEyV2TgjCh7UkgGnwH+5ZQYSQ/y+emNcWZGYrs5ibyFXmnJ79Es7clKGm
mEjJ2osBqc03L5gn76KW6tb6wmlm1ZGb8jgGGr7k/+te6Vttvw8IOweq6qredJto
Q6KXvzc3i6j1KK+GI508
=x3Em
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
