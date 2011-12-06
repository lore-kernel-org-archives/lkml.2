Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab1LFNVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:21:49 -0500
Received: from comu.ring0.de ([46.4.151.82]:33476 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932980Ab1LFNVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:21:48 -0500
X-Spam-Report: * -2.6 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.1 AWL AWL: From: address is in the auto white-list
Date: Tue, 6 Dec 2011 14:21:31 +0100
From: Sebastian Reichel <sre@debian.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH] mfd: add bq2415x charger driver
Message-ID: <20111206132131.GA22855@earth.universe>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com>
 <20111206021749.GA7202@earth.universe>
 <CAMP44s3JF9QM00x=aUq3tHGfeuTRnKMbT2WrMseZXZTJg1qUyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <CAMP44s3JF9QM00x=aUq3tHGfeuTRnKMbT2WrMseZXZTJg1qUyQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 06, 2011 at 04:49:37AM +0200, Felipe Contreras wrote:
> Not really. There are 6 bits: 640, 320, 160, 80, 40, 20. So values
> from 0 to 1260mV can be represented, at steps of 20mV. A value of 0
> means 3.5V.

I just checked it. You'r driver just writes 0x42 to the register,
which makes use of the described platform specific resistor.

> bq2415x_i2c_write(cli, BQ2415X_CHG_CTL, 0x42);

I know that 42 is the "Answer to the Ultimate Question of Life, the
Universe, and Everything" [0]. But in this case 0x42 is platform
specific. Check page 30 in the specs, From Table 9 onwards.

> > [...]
> >
> >> + =A0 =A0 bq2415x_i2c_write(cli, BQ2415X_CHG_CTL, 0x42);
> >> + =A0 =A0 bq2415x_set_voltage(cli, 0, 4200000);
> >> + =A0 =A0 bq2415x_set_current_limit(cli, 1800000, 1800000);
> >
> > So it always charges with 1.8A? Shouldn't this be dependent on the
> > input source (e.g. 500mA from USB)? Also what's if no charger is
> > connected at all?
>=20
> No. I'm hard-coding those values, but I wrote the functions
> (set_voltate, set_current_limit) so all values are supported.
>=20
> What is missing is the code to connect this driver to the charger
> detector driver (isp1704), so those values are determined dynamically.

ok, I was talking about the current state ;)

> > Apart from this I think those values should be exposed to sysfs
> > via /sys/class/power_supply.
>=20
> Perhaps. Although I don't see much of the power supply interface that
> could be useful here, but if so, I guess this should be indeed in
> 'drivers/power'.

So it may need some new entries. Normal mobile userspace wants to
know at least charging status & speed. Also it's probably a good
idea to make current_limit sysfs entry writeable, so that advanced
users can overwrite a autodetected value (e.g. a dumb wallcharger
may be detected as 100mA, but can provide 1A).

[0] http://en.wikipedia.org/wiki/Phrases_from_The_Hitchhiker%27s_Guide_to_t=
he_Galaxy

-- Sebasitan

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3hbbAAoJENju1/PIO/qayfUP/3EgUS5gBXhmS5utKuNkYlUY
76gjBnO7NGXRwL8NVL3+EUR6NUbj/S/r9xLRXp9B5iOK27efSFi+xBhkUIJt5It8
Z2EhpxyZlcGnG2a9eRHMKN9hzeg2a8tvO8DLbe0rUF9L0Ts1AK1V+3m8BZ0SSD67
R1p8ZnL5TVGFmOpysKYnBO5LBRl8TaB7UcApJJaIMajaMok1O4DfimhEd9dyJpPB
kQjIQ6Y0dOiztgo2viOzNGj+HCQaM1zXoIopH6LHlxZrooyWXzHXTR3gQwiZmVd+
STxj+cdKcPLhgh8RoobB5VWy/CgvQBviC2UZGT99dquyZcaiw5+AJKVyAYZeY9hU
qyqp8BmBo7Ouranv3MvH2StChSou7iQJ9lXU+rHCJWa6mLEgeJOFAu0GVcAGTOVm
0n+yxbOBGEmrHlyaBLMbpsKaQZAUOMFMEI0liM9h0e3wZQKeHRdwz0hVLpX+CoaP
bbrcF6d9m4A7HYzX0B0nZP7Jp5jBKUsp6/uxN1clvXHOxnVG6MzVChZgevgSfL92
sJ8ryhM86JgZzjFIE+5i7Zwm4ZCDhoHi7e0/Mg+whje5ntffXRIgFn2vfYQUDxhW
SlhTRSNifIEZXS+zRvnUrnpQ+4nuxDBvk3+/lor9XZpqsOQi3DrbrtlHc2vSOX2S
azhQORI9SwmZnb03kSee
=VIHO
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
