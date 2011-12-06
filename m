Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab1LFCSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 21:18:08 -0500
Received: from comu.ring0.de ([46.4.151.82]:48140 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932811Ab1LFCSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 21:18:06 -0500
X-Spam-Report: * -2.6 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.1 AWL AWL: From: address is in the auto white-list
Date: Tue, 6 Dec 2011 03:17:49 +0100
From: Sebastian Reichel <sre@debian.org>
To: Felipe Contreras <felipe.contreras@nokia.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH] mfd: add bq2415x charger driver
Message-ID: <20111206021749.GA7202@earth.universe>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Good to hear somebody is working on this :) I planned to do this
myself, but didn't find any time for it. Here are some comments
=66rom me:

[...]

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig

I would expect the driver in drivers/power. But maybe MFD is
better, since the chip can also be used to power USB host?

[...]

> +#define BQ2415X_VOLTAGE_SCALE 20000

If I remember correctly (I read the specs some time ago), this can
be configured via external resistor. So this is board specific?

[...]

> +	bq2415x_i2c_write(cli, BQ2415X_CHG_CTL, 0x42);
> +	bq2415x_set_voltage(cli, 0, 4200000);
> +	bq2415x_set_current_limit(cli, 1800000, 1800000);

So it always charges with 1.8A? Shouldn't this be dependent on the
input source (e.g. 500mA from USB)? Also what's if no charger is
connected at all?

Apart from this I think those values should be exposed to sysfs
via /sys/class/power_supply.

-- Sebastian

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3XtNAAoJENju1/PIO/qaCQQP/jn5Zp92a7kaUss3zOEY3KOw
aFz2YMwPW0OZtPS7QAKT0T2jGHn7SVbh478V6tA2y8g9lCkh3KMutBhd5FkC5dUk
g2yKhnvK2R58ZjgqU5jn+4A5fDS3cf0g16Nvvj41MjQIpmA+meXZC8tYtM+7jxSg
HzfvCJUYXjtfVaLDVvtCOxc/gGt2y2QTE+BUMRmHSh7olVbiaxP+pWoJsvQ9PaMP
WBQM6CvEusr7AEcNkXHdKUXH7OpvOBaU5RWU/BIPpx5WITkfvSq5YBNKHGWvcpv0
wrWemnVpQWfMGJsOOLWiITwoCHLMdMEvyPM09H3Z6RbHgKMHxRR9r5YSTAu63YEM
CJPgVnbvBpdCP1/sJ626gKbTbt2EmzWGJ0vUqynYc/9wE5neDOsvDY/tyP8MMg1g
l8eN9N9C89aWqoxxHbBa3uaauLJtMvyW7U45/yBk+kGY1SATu9/BwwMSFEBxiZZp
c8Q8KMDy5s0EULVi5sHaaiHYGbQ4tCsSJo4DBi/Y0X80idDfnBvSpmB7qI+3BxXs
jdXri1OswbO5rnAbFFSz9IT22JNSoln0VFwuaeTy6FNmlEE1ts+BUUtD/vi2pWWg
ugZ+MdyN84A1msbLiLJGHsksJvILIogDJlryGpc3o+7mf+/1qe1T2g5fjC85Iuo5
D0MF9Xyk+gejJhcpq0Ro
=Wmry
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
