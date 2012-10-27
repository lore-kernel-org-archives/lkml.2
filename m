Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab2J0VbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 17:31:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54531 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032Ab2J0VbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 17:31:17 -0400
Date: Sat, 27 Oct 2012 22:31:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
        perex@perex.cz, tiwai@suse.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/6] Add the main bulk of core driver for SI476x code
Message-ID: <20121027213108.GD4564@opensource.wolfsonmicro.com>
References: <1351017872-32488-1-git-send-email-andrey.smirnov@convergeddevices.net>
 <1351017872-32488-3-git-send-email-andrey.smirnov@convergeddevices.net>
 <20121025194524.GV18814@opensource.wolfsonmicro.com>
 <5089BC7A.80103@convergeddevices.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TybLhxa8M7aNoW+V"
Content-Disposition: inline
In-Reply-To: <5089BC7A.80103@convergeddevices.net>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TybLhxa8M7aNoW+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 25, 2012 at 03:26:02PM -0700, Andrey Smirnov wrote:
> On 10/25/2012 12:45 PM, Mark Brown wrote:

> > This really makes little sense to me, why are you doing this?  Does the
> > device *really* layer a byte stream on top of I2C for sending messages
> > that look like marshalled register reads and writes?

> The SI476x chips has a concept of a "property". Each property having
> 16-bit address and 16-bit value. At least a portion of a chip
> configuration is done by modifying those properties. In order to

Right, that's what I remembered from previous code.  There's no way this
should be a regmap bus - a bus is something that gets data serialised by
the core into a byte stream, having the data rendered down into a byte
stream and then reparsing it is a bit silly.  The device should be
hooking in before the data gets marshalled which we can't currently do
but it shouldn't be too hard to make it so that we can have register
read and write functions supplied in the regmap config.

> Also due to the way the driver uses the chip it is only powered up when
> the corresponding file in devfs(e.g. /dev/radio0) is opened at least by
> one user which means that unless there is a user who opened the file all
> the SET/GET_PROPERTY commands sent to it will be lost. The codec driver
> for that chip does not have any say in the power management policy(while
> all the audio configuration is done via "properties") if the chip is not
> powered up the driver has to cache the configuration values it has so
> that they can be applied later.

This is very normal, indeed modern CODEC drivers can leave the chip
powered down whenever it's not performing some function.

> So, since I have to implement a caching functionality in the driver, in
> order to avoid reinventing the wheel I opted for using 'regmap' API for
> this.

> Of course, It is possible that I misunderstood the purpose and
> capabilities of the 'regmap' framework, which would make my code look
> very silly indeed. If that is the case I'll just re-implement it using
> some sort of ad-hoc version of caching.

No, what you're doing is totally sensible.  It needs a bit of extension
to the framework before you can do it though.

--TybLhxa8M7aNoW+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjFKWAAoJELSic+t+oim9t+AP/0J9AouFBxNJbaimfuVuvWh0
VFogUR1c8Mj41jo6Od1mUrX+U9GJrwuI2LVH3L7tpAyyxr/FLjliOYGF0JSK8Hwf
ZnS8jr1B2VtleLbmwssy7i7U8E2np7K4HkvYTlMLdI0tt/CPZbkZWxERnUunYdai
YRieYxNgCVamAsAN2s0f/Dds+IK8SvAMwkF3Xay+mmboSg+TqTedTwXdPcksCkzu
3DD1r6t65zeK/5sKE6wcWyshd6nlZz9Xn4bMg3r93J5vXrqJkKTSxSMGNhy8knZb
MncVWLHZZWk+y2SN5DiTBn5F/piAldMTWh1Mwz8Ln6h7L95r8MeCBW5f/imtW8CK
TxRgkLaiPz5uZTqO3k9K6JMCOBpoGxlAMeiJ+Zmm5CvaQn3OlVRIM57IQZsEk1bM
Wx091a2Tvy5BhUese9FCwwKiUI8qFFygGi7qxlFXAaQGXtR0q2/TYeaHWioU3bBw
Mmkul0pa980inCWARYy0zknOFu/IAiB9znwGAtDwQR9xCxFQr4cWHdbQNSii3Ijs
mPzwDHWBjJ5sOOIXA1KVRtlc2YcYVm+lvUDFNA9egb5BIyDp6ukwZcrXQrMFpBgH
dy2ix8FffHhCEi2cd/3I3sBvDoIQvnGURqobodazMQNxgNizun7BqL2mYdR7csq7
kDzzhJXwOu98G7p+wRZV
=N9xd
-----END PGP SIGNATURE-----

--TybLhxa8M7aNoW+V--
