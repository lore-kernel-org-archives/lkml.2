Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2KQH2c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 02:28:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56270 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab2KQH2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 02:28:31 -0500
Date: Sat, 17 Nov 2012 08:28:14 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: linux-kernel@vger.kernel.org,
        Arm Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        VT8500 Mailing List 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Subject: Re: pwm_backlight/general pwm issue.
Message-ID: <20121117072814.GA26391@avionic-0098.mockup.avionic-design.de>
References: <1353125259.18544.7.camel@gitbox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <1353125259.18544.7.camel@gitbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Bd2Bk3biN055x4LRJHV646pOcYPmAMVkGiV9WW1APaN
 u5BDl7GlQjvYA5mnfC52F+Op8HrFCTvU+1ybcHs98IVSO1SEaR
 KgPnmM9ba/XXs0uiZNP7A0sFwngeF0sdoH+UBouYCIgpg60X4c
 WFqUYAWLhi5LdG90jqZz9RQXmJ4tBMifmXo6VK12K6aZNC731Z
 CwWSCEDQjSkiJEhfuLMmdgoAL6Ubvcka0j6TsBqchMtX1EfZW1
 SR2OMqOFpFdEloHnh/nCwUpoJZcPaqVXCYVtbCGelQPZ8ynYhy
 oJvcVz5W/3NyOs2Q6xaluwZfmokw8SLX3inf+wGG7NM93sHiLB
 bj8iVcpyzSoe3ldVu1VCc2tfxECY/o9Z/bHYgFQcGaEpgBULwi
 U5exVWMUdgm1Kl3pLdXMjfnhlOTRBWM9Bs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 17, 2012 at 05:07:39PM +1300, Tony Prisk wrote:
> Hi Thierry,
>=20
> Looking a little feedback regarding a problem introduced with the pwm
> patch I sent converting the vt8500 pwm driver to devicetree.
>=20
> One of the recommendations you made was to enable/disable the pwm clock
> in pwm_enable/pwm_disable, rather than at driver probe, to reduce power
> usage. Unfortunately, when the last pwm is disabled, the clock is
> disabled which prevents the pwm module from responding to register
> read/writes. This would be fine if pwm_enable was called before any
> other functions.
>=20
> The pwm_backlight driver calls pwm_config before pwm_enable, which
> doesn't work because the pwm module has been disabled. I can appreciate
> that no one wants to enable a pwm before it's configured so I don't
> think this is particularly a driver issue.
>=20
>=20
> My recommendation is the re-enable the previous behaviour which was to
> enable the clock during driver probe, and disable during driver unload.
>=20
> Looking for your thoughts (or anyone else that wants to chime in).

What other drivers do is explicitly make sure that the clock is enabled
before accessing registers if the hardware requires so. Does the driver
work if you change it to do so?

In the end I'll leave it up to you how you want to handle this. If the
power savings aren't an issue on vt8500 (and I suppose keeping the
peripheral clock running all the time doesn't save you *that* much) I'm
willing to take a patch that fixes things for you.

Thierry

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQpzyNAAoJEN0jrNd/PrOhSiwP/jvoq6UPtJIy65ADmWCQsRGZ
9uuQ3JkNGQobK6Q5pl5QxtmC3ovvcomvuKMU3ndjwCXkwDOVKoPfksRdJsN0WBzG
5mCRIVaLmuc2W/TWOFDdG+WbHrLtbRgh0+JAEXbuEUkB+V4lwoLGjFPPqdGDnpAU
1W5prO5oePZNhcBdZR6/xE5kpcDPPGRBXzP9mgMDZcNyAEsU63jEC40w+bj3xYOV
so2jBHHnsaFJQGRgErlRdf9ScW1xt+c58mTtWoahO7cwm7LRo2VH8aBfT+iuztbQ
e/DW5IMjst/ng0JlONtIgQ7KOf3xej+ABK9Z8ZjC5T4EZbE9ZFZTln6Vo7WiHlUm
FojUfcpXu5UI9lUTNhDc4HZjltpZEOfzvMWb8IRiQvFpue0T37kJQ8lfHuMJF7E3
EdrZpYxo8Wv4rRG/hPpBBxvu3nPqAtFiQ6g0nQlBZ63FwABrbrZoc8/CpVnnp3Bb
HZgNYtfnzlaDCDBEwWlVxJ3OuP1qoQN1NFPdUoqNK18hXT++PXuoz/RUL+YKuolC
iOAWx+j3TmFl5kAJW5fG+ntgu82bzQyIFigSqowDcETXGpUwIZ+fCDVHBwNsiyHh
wN8IVP4U/M76YUlnkdN98J+ELeEx+8joegNuhmcypeNIEXMpeBXxuWFi9NQI/zrl
zTjsXiGcgjhKxUCLnZnb
=oPts
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
