Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2GRQK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:10:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58640 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539Ab2GRQK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:10:26 -0400
Date: Wed, 18 Jul 2012 17:10:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: Boot breaks in -next from LEGACY to LINEAR conversion
Message-ID: <20120718161023.GE4495@opensource.wolfsonmicro.com>
References: <20120717185749.GJ4477@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r7U+bLA8boMOj+mD"
Content-Disposition: inline
In-Reply-To: <20120717185749.GJ4477@opensource.wolfsonmicro.com>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r7U+bLA8boMOj+mD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 17, 2012 at 07:57:49PM +0100, Mark Brown wrote:
> -next fails to boot for me today on my s3c64xx based systems.  Walking
> back to the last time I tried and bisecting likely branches I find that
> commit 910139 (irqdomain: Replace LEGACY mapping with LINEAR) is the one
> that introduces the build break.  Unfortunately the boot fails before I
> get a console which makes diagnosis somewhat more tricky than would be
> ideal.  Any ideas?

Further data: the irq_domain_associate_many() calls that we're now doing
are also causing WARN_ON()s to go off during boot after commit 98aa46
(irqdomain: Support for static IRQ mapping and association) causing
breakage for my interrupt using MFDs.

I don't really have time to investigate now but backing out that commit
seems to make things much happier, I suspect there's some collision with
IRQs allocated statically by the platform but I don't immediately see
what's new here.

--r7U+bLA8boMOj+mD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBt/nAAoJEBus8iNuMP3dKKIP/1NEmR0mJVZtOsfeIONl3fiN
y8XStWb0NtMdZa+N5PIpL7FuKlN32BJ36OSAv7q/kt0AOV2ird1ES0hJBY4uGDZg
TBiF4OYwVnK16MYCloh1Rn373qWm98NxCGnG8wm2m6SD3Sr9+udTGmS+rJvh4hwe
zV4cgKZUONd5S2nOSP9bzIC5qUSkEuDCVcLOmLyZirS5PXW7u6hLt+9rCoWFJaqh
v9yh/Uh+WW7TGzpVWL4mBRDGOZbQMrwsGLa6mLlCjAx/+XAg8OdR1p/iQ/t+OrnK
rLZkst4vQn5Z0O5s+JUdj48eqD80wV53bW8XjAHh9rC/i0V3G/WR0X+3FzkB+zld
OW63sdGa6SUvp255TXdmYhypJm+bffxJplDOpjgRCURjvDd5DlW2BD0jzuYXZO0E
aBeHdOqsn8MbjDrwcJnZozZTw/dfAqPzyCOtMJLaKBwmyWJo2APDWWNdVZsWi4E1
gx9Uw1lhzTQBUeD8GgMZArNdWR+f7YdBC7pgXDJ3NTVAO57Qhkk8xmzfwLJTTJa7
IEz6RnePVwhOUXiZCLV0ZKRN2hbZix98FMKMxDbAD1fPBKT+NAiPhe9BTdGBHK4s
9Tg955GigXQIB2kJSafCMQNIP5dDZniSpoJ1wbZYdeuOsnBBePwC+uO/sENmP71C
DjDzvkHoIIIl7qe2kDr7
=ivJQ
-----END PGP SIGNATURE-----

--r7U+bLA8boMOj+mD--
