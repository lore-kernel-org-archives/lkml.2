Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab2HIHSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 03:18:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61590 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab2HIHSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 03:18:52 -0400
Date: Thu, 9 Aug 2012 09:18:48 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>,
        David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: hda/realtek - Keep analog bypass muted on ALC892
Message-ID: <20120809071848.GB6979@avionic-0098.mockup.avionic-design.de>
References: <1344494839-6942-1-git-send-email-thierry.reding@avionic-design.de>
 <s5hfw7wfszx.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
In-Reply-To: <s5hfw7wfszx.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:DG+p8Ilz/RVCm/3n68Bd/ufkc4i99evBujMX2Erv+CO
 V/9Z+eEOjWzaK3PtxJSDUpiBD38pFZzzFJV1/3Z8J24Gyc1DYa
 ajPM3zVNulaUNbg/YuKpMQhcd4LFuvVoJ3oogdnSvX2l/7zS7a
 XchYagOWbulgrdhCtq5v8rDjIVJ/DQPyiRHpNC+R7nMcCbHXFj
 7UWfcy85L7Qr4InrxJkL0xciXi0keUn6dC6RP+fe6YXPLiGL5o
 /CvVX4j6eLj7IW4w51Z2PLJNph8FUQr7JKStDnEc+GbBbX5yk5
 UOPGBzmKO5MyeEww3cMBnfNVKFXg87tHAmilMtfw1zLJ6tCgnD
 gsHKBcUodH98JSaEzKSHYYWS0HxTR8wtF/XB4Sopg7TzwLP/a8
 JGNiLDerTeBLoAP+mlyprQ/QXBJ9aNOhpKlEp7Zvdseqf5o8sI
 KO2TZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 09, 2012 at 09:02:10AM +0200, Takashi Iwai wrote:
> At Thu,  9 Aug 2012 08:47:19 +0200,
> Thierry Reding wrote:
> >=20
> > Unmuting the analog bypass causes any input to be directly bypassed to
> > the outputs, which is usually not expected by the user.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> > Note that this patch could be generalized to include all codec variants
> > that have this second channel. As I don't have access to all the data
> > sheets I'll leave that decision up to somebody with more hardware
> > available.
>=20
> Hmm, are you really sure that this is exclusive switch between two?
> All Realtek codecs with this mixer widget mixes two sources up.
> Otherwise it must not be a "mixer" widget at all but it must be a
> "selector" widget.

It's not an exclusive switch. But the second input is the analog bypass
that basically takes the signal directly from the input path and routes
it to the output.

> And I haven't received a bug report regarding this although ALC892 is
> no new chip and the auto-parser has been enabled for so long time.

I've seen this happen when feeding a signal into the CD-IN (NID 0x1c),
which is then directly routed to the output, so I actually hear that
signal at the output, even if there is no software loopback to capture
the input and play it back via the DAC.

This is probably not a very common use-case, so maybe nobody else has
come across it. Looking at the block diagram in the ALC892 datasheet
(page 5) clearly shows where the input of this second switch comes from.
I don't think this is intended to be unmuted by default, but only in
very special cases where you actually want to pass the analog input
signal directly to the output without going through the ADC and back out
the DAC.

Thierry

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQI2RYAAoJEN0jrNd/PrOhgvIQALJ/nzlAkLx5at9u0ZUXVqod
gDw3eVArqBW5Vt3tuWOBcZWba7hGoii/Fbc97JRbf458utSzAWXOtwVVRZaCEnI1
TurHALdXZBmfF0grl5tn580g2y43/KKyKkXtGhq+nkWJouMMGDlaJ85fIOKdKKd6
xSxfwnWGl6mTrV/i1FAbM+t1h5PEsVQO/2FfLe1bO7IvQLHAzWUrV/B2XBA1oOeN
MNt97moj6+4AWkv5oBhaufMzvQPGp6mxVBbotDyHypwA0PZeTAMzkmaz+cr/dDnQ
TtP6rLa0JIQoCfRM5L1boE44x3Ip+xtwPsRQyVVQY7kDpcJ3dmROMzRElcuh3box
6QSyxRH5nu8WY0NFZ2u/wLKQDzYkVOwnw5J00sKKEImY+ss9XSzecKs6wY4xaplY
F0uGQpWnwyeXHyELI7hdrO3OvQfE9MzGz1tiIIu7CQWZwr7Fxu41wuw/K+eiZmWR
6kiqMJryNV37zGamQGjMen6FNYlzXNyBU7YfYZxSlhgfV/LZ86loSJPgj2NmQzE8
OqFzZ5ajpJB9eAVbRKISSTsHP0JBEFTbPTE8ppUGMt7Gjh8rAfPa/zULC0RLYLcn
idvaGzBY7RL87ul5UYjFNoKho/QAAee6SODWNb9SUujAHQpanpOuyBDwCsPI42pw
twa4zLamxXCzBFeg/i1Y
=2pd9
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
