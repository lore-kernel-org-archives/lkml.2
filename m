Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab2BGNns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:43:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49009 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754027Ab2BGNnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:43:46 -0500
Date: Tue, 7 Feb 2012 13:43:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/7] MFD: twl6040: Convert to i2c driver, and separate
 it from twl core
Message-ID: <20120207134344.GP3332@opensource.wolfsonmicro.com>
References: <1328619678-26080-1-git-send-email-peter.ujfalusi@ti.com>
 <1328619678-26080-3-git-send-email-peter.ujfalusi@ti.com>
 <20120207132925.GN3332@opensource.wolfsonmicro.com>
 <4F31298C.5090008@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1MCZUn4MZNv/LeVo"
Content-Disposition: inline
In-Reply-To: <4F31298C.5090008@ti.com>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1MCZUn4MZNv/LeVo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2012 at 03:39:24PM +0200, Peter Ujfalusi wrote:

> In the codec driver I have one 'shadow' register which does not exist on
> the HW. I'm going to need to have access to that shadow register's bits
> in the future transparently.

Alternatively just rewrite the code for that to use a variable in the
driver private data.

> I was wondering if we could add support to regmap for such SW only
> registers. This would only make sens if the cache is enabled. We could
> have a callback let's say shadow_reg() in remap_config struct. If it is
> a shadow reg we never reach out for the HW and operate only on the cache.
> Is this something we can add to regmap?

That just sounds far too icky - I'm really not happy that people have
been doing that in ASoC TBH, it just makes everything more tricky than
it should be.  It save a little bit of effort with the control but just
pushes that complexity elsewhere where you're not expecting it.

--1MCZUn4MZNv/LeVo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMSqKAAoJEBus8iNuMP3dBdcP/3idXXplMvTZj8tP3GhbGI0M
QWhPSicJj6Jq8qZnzNEfytHcLc9x9EBK33Ak9JuQQjQVbM5TXM0Q5VmlOcCsh+j6
Nrw9Dv7PEvuO696Qo5SRY3qbcjv9F9zSIgnuN1qPhU7wMacuQtvpPAO7J+LgJDk7
JPYMfINl7JYt8u3cMsXA2V7io3ERyHXzPYp3JbrsRK6w4Kazam2zPdFMnNSIq7Tg
91rvypqNlaHvYOo0wUs7368o0Bo5nCiSg6DjCbR5rCKtOVU1MQE7FSpb3pu43Wet
pB9ZlNI8GUmEtz+5DQ2PMlRQE4zPwmZBPHpl/UQZ7OdvKlFeOxBqqDQpPU7zOxFf
tODyLtpr5Zf0IzUrLlFwtuoS8wEDzp6lT4cQWKU9gNcu7pUaWsUjlsCBUQgkam+e
0LCwG8hpbFDBBzOM8qoLhOfMRomMGu0HHCRb8mLnH7Q+2FP0HlZWau2NZKfk/nkE
XOmUjSgfvB8Q/pkN/MR0hCOuQUbJUx9mnXr32XgdGB1JhddATghi52UojLC31pxw
GtuQHYbwz9H3yJgNBj+khI0qt6YUH/DUGIag9khJQuc2L7x8nuXr+LUCyFtbvXYe
SXBaA/8zHWL/A8usLHNk/6EQ4HNiUg2g5eeMIylO+MlXc5YzcX7ED1kBK4eeIAue
RA3lsaQPkSo0BwknoZEV
=eF8h
-----END PGP SIGNATURE-----

--1MCZUn4MZNv/LeVo--
