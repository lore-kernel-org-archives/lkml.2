Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934270Ab2HWTEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 15:04:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59377 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189Ab2HWTEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 15:04:08 -0400
Date: Thu, 23 Aug 2012 21:04:02 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] pwm: Call pwm_enable() before pwm_config()
Message-ID: <20120823190402.GA8127@avionic-0098.mockup.avionic-design.de>
References: <36966374.2768747.1345741025741.JavaMail.root@advansee.com>
 <50366464.4070801@metafoo.de>
 <50366628.5020007@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <50366628.5020007@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:fitHem+MX4hcX+KT/PiTdQ3m7zzxWWAADybYxRT0YtZ
 kT02gfHH+l7mojwg2FSFEsWmWx8T4SgcyVKR8hLlThYUlRu3pN
 B+0E7DnjnD7cTfPbgz63/4i8gjVm9LnRWlL6COS0BdCEHu2ds2
 Pccdpxjpg2zOVl8AA545DZWW8fRDO1A5TNMj9xmgQLyaAD1gdI
 IlOEGISBbMDZWjn3ryvRJKHU9NBR5G8sJGbtlm6Q8gOGq135UP
 tWM2tOSQiyhrd5n7GHuWoXgqOn4I6e+/pvluKdhGvD0JIuLCaL
 +Thh6FHrbgFc2iraiKJOgDTQ33CF2GQU5+u5RWBxX5/LZqjYYm
 nno5PeE7HXgizOwpF5VAXrT+3rAzqhx07bxUAm45b8r45Sxwij
 crCV+J5roiKJ021qnUrNLb7I7x0EWmosS8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 23, 2012 at 07:19:36PM +0200, Lars-Peter Clausen wrote:
> On 08/23/2012 07:12 PM, Lars-Peter Clausen wrote:
> >[...]
> > Or maybe just use the runtime pm API for this. This probably makes even=
 more
> > sense and grab a reference to the pm context when the enable() is calle=
d,
> > release it when disable() is called and also grab it before calling the
> > device's config callback and release it afterward.
>=20
> Btw. this seems to be exactly what the pwm-tiecap and pwm-tiehrpwm drivers
> already do today. I'd just make that a core PWM framework feature.

Using runtime PM for this sounds indeed like the most generic approach.
I'm not very familiar with the API, but I thought it required explicit
architecture or bus support (or the driver itself can provide hooks via
pm_ops), so it might be difficult to implement for platforms that don't
have working runtime PM support. I'll have to look into this some more.

Anyway, if we add this kind of support to the PWM core we should take it
through next first. For drivers that are currently broken, they should
be, as you said, fixed by enabling the clock before reconfiguring and
disable it after (unless the PWM is enabled) like Tegra does.

Thierry

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQNn6hAAoJEN0jrNd/PrOhbZUQALCCmw0uie9t60hTMAAFNJBK
phFnATVrHoXdW5pnG7G7b2sAc6zFIYgK29rDyS//uB0Fv8JNUp0+01QsZf/mSvh5
aUr+FYR0QoUuMSvdJyq3H2oDc3HRnCHNBnv4lAVS7AwbJyzJMw4YwqO+sTaS0E8S
+eKz8BDK3L3IAvUkn3XiUHYGBlaTCEuQBF+pohcARplHksTOmzA0KR4EMrJG7vOC
iUAH3BPD1BuZl/wXZgGVG4PUCU26wXi9brBp/0JXvIFq412Z5VbWhlTu0sNml1pN
+a5gD+PgspwMURaQHsMv8m647yfV+6/QMya5gPMTCAq1dqFIc7mUQFnG6qmpAE6C
t0hYU8ymZURPDrlS8o3V9fcOaiRdIMZNND7RSSIg+4QNA4m9jb94hS4/vnDLA3Gh
uIQVBQwMD6Tp+wLKq2pn7KgBDPeeZ2NLd9AbYlgK2yP7zB5p5uZbTe3fjxG3dIod
+8O0nzgQGpxJQxLaWnKA7Ue1SB2pRwawA3LV7q8c8r1vcuu1kWYSYZeaugSs/v0N
oLRCsmYvrFV/bpsa+OhaC+03NsVuSpIU/+NhrEjnGVxHGj9GJFt5IZbSLX6EMEij
H0a1htgwZBv0GPjCEXgqLOWV3ibsWo5mnzzomJLZZ5WEGyuvDdxon+XdbnxQ7LQI
X3XJBYlIat8vaM3SEYML
=81uJ
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
