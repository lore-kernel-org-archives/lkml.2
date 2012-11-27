Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab2K0Gff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:35:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41460 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758021Ab2K0Gfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:35:32 -0500
Date: Tue, 27 Nov 2012 06:35:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: arizona: Only set GPIO if it has been requested
Message-ID: <20121127063528.GU9411@opensource.wolfsonmicro.com>
References: <1353929315-8874-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <50B3FAAB.9090406@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uUozbLrG2OP+gMtx"
Content-Disposition: inline
In-Reply-To: <50B3FAAB.9090406@samsung.com>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uUozbLrG2OP+gMtx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 27, 2012 at 08:26:35AM +0900, Chanwoo Choi wrote:
> On 11/26/2012 08:28 PM, Mark Brown wrote:

> > +	if (arizona->pdata.micd_pol_gpio > 0)
> > +		gpio_set_value_cansleep(arizona->pdata.micd_pol_gpio,
> > +					info->micd_modes[mode].gpio);

> Why not use gpio_is_valid() function to test arizona->pdata.micd_pol_gpio ?

Zero is normally a valid GPIO (since it's an index into a big array
after all) but this is unhelpful when checking to see if someone filled
in platform data as it's also the default value for uninitialised member
variables.  It's much more likely that someone didn't fill in a GPIO
than that GPIO 0 got assigned to this.

--uUozbLrG2OP+gMtx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtF8RAAoJELSic+t+oim9/foQAJJKOIbWxsnX1ge/RBCklzsu
jC4a82DHFjuJG3HaeBp5IaqihlglvfccrERW2YKW54fau3PWnuL1x/MCIYIIlvyq
Cv/ZI4CHK1x80731MZ3NoANtfwjmcGpk1bHUMfkn/YwrEzs3503T/oHw4HE/UNld
qT2l/LZArpi8v2G6NCuY+aWAfTzHQuViOo82kJHRjradsl6VGZtCMoFh3eqC5/bR
ysQC019DzRCb/nPnVeG0N/E9lIogbApfR/Aw9bf0nKWN0De6LlW5UZBV1sKsyQEy
yaz7cwEQqENElNilLEifMYTTNfIMEQRbs6sh7qDT1YP15utZAKmVdGPoj/9V66eo
K5RJEWq+Qe7H45K7AA6FXWI9YXxdgUHnz3l2JAIG6o1ETt7sXkNyvNxos3t3vWWc
4EMGi0jnSAm2fOWsNc+nTd1H4FND/+e+cJql2bz4DYNvPQ2ld5kcRYWfZ1sQ7X8k
GNh6sFOZ+fOu4o8HS0UnGhcQCixJOssTzEiKsVPoq+T51ItCldr7ufA63Aq+MsCE
6lXf282TnQ6X8YYGXvumj6OnWp71061cGnitoACzoOzXdqlCuzXYjePH1Fk92ZmC
6eA65O1UhVnQUBydR4RmJXc5Ma0D3P3w+tjv0xh8PZVoroZa2XzUHyxIT0G9pGuJ
m6iZ8ixTeF7Tuzga3juc
=0JxP
-----END PGP SIGNATURE-----

--uUozbLrG2OP+gMtx--
