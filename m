Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab2DSQ3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:29:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50624 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865Ab2DSQ3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:29:19 -0400
Date: Thu, 19 Apr 2012 17:29:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Subject: Re: [PATCH] regulator: Provide a check for dummy regulator
Message-ID: <20120419162905.GA3084@opensource.wolfsonmicro.com>
References: <1334829097-32084-1-git-send-email-jaswinder.singh@linaro.org>
 <20120419124204.GE3046@opensource.wolfsonmicro.com>
 <CAJe_ZhfbFq98fT56CS-q4VoU8wnybj-+swfB+Jrknd3Zmt9V8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <CAJe_ZhfbFq98fT56CS-q4VoU8wnybj-+swfB+Jrknd3Zmt9V8g@mail.gmail.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 19, 2012 at 07:35:03PM +0530, Jassi Brar wrote:

> I am talking about the delay the consumer driver might want after
> enabling the regulator for the end device to, say, initialize itself or
> perform POST or whatever.

> I do realize that such consumer drivers ought to know about the
> presence of the real regulator via platform_data(PD) or DT, but

No!  You're *completely* failing to understand the usage model of the
regulator API here, any driver doing this is clearly buggy.

> Another POV is :
>   Is a consumer's need, to know if the gotten regulator is a real
> or a dummy one, reasonable ?

Absolutely not, you're completely failing to understand what I said
about abstraction here.  *Nothing* about this is anything to do with
dummy regulators in the slightest, it's about supplies which are already
on at the time the driver powers the device up.  Doing this for dummy
regulators is not helpful, being enabled isn't in the slightest bit tied
to the fact that the regulator is a dummy regulator and it's silly to
optimise this only in the specific case where a dummy regulator (which
is in the first place only a crutch to keep systems with buggy regulator
setups going) is being used is silly.

I'd suggest checking with regulator_is_enabled() prior to power up, or
adding a notifier for physical enable events and using that.

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJPkD1JAAoJEBus8iNuMP3dkfgP+MvPT5stoS+cc9EVo+AGyrBH
5h2XtYhoPe+s0hhmOxZoFqji+raEY29WSrS21Ij+xF8/ddA29fstbzvlKhBT5/xj
EPZ8Rp1X/r1LCR8crLekiADfP9DZiQ26QD2kn+Wzh5/JAu3n3OWkQqPSIrRQrp5/
5IvLu3gtmtJhKTkCWJOwh+pvRgkucmcjnZy8tSTxyjBZ4hRdS2nqlOoK0yH8tw/F
ycIt5h5AQmQd8toex2wqoOt4bxV3Gsjlwj93Tj1QzBI13jb91PNTJj3I9ukzp/pN
zmNRlzXKq+Oa0uhb47TQGKeVKhFmMnMJIMEoEGXmSXxuu98fhqCjCxKBtF+6IQG2
Q/hWL4t/urdrqkxNHtWdw6IOJVhfD235lrvy/clHnkwhEJxqjuxyMeZWmLNKUYKd
W2xoHc95Oo2jPIKo1i/oosmlULvjMDT2apzi/6/44f9zg/kLZTioCV/HaaiZq+ms
xHUi3Ahvu1pBNk690VknTak3Fms/fB/PvR3i7NMet4hP7FOtkiM0vve1OZH9c1RI
c46A/AKO3GZ8xYvM+Zhp87umwiRdPe1Q4nmgQtRa656nEB2U6sarskJ1SDcmLkXt
FQArt8ImkY4c/GHM545WEzMjtsbDAd9ZJMPZGhhnx/6+GxTvJ9Pdtj2r/Hipkby4
p57sptDt2nAvkdqywCM=
=eCIe
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
