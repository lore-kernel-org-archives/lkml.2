Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2GROwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 10:52:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55612 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863Ab2GROwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 10:52:50 -0400
Date: Wed, 18 Jul 2012 15:52:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <bryan.wu@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>
Subject: Re: [PATCH 6/6] leds: add new lp8788 led driver
Message-ID: <20120718145248.GC4495@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FD7DE@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ctP54qlpMx3WjD+/"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FD7DE@DQHE02.ent.ti.com>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ctP54qlpMx3WjD+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 18, 2012 at 02:34:02PM +0000, Kim, Milo wrote:

> +static void lp8788_brightness_set(struct led_classdev *led_cdev,
> +				enum led_brightness brt_val)
> +{
> +	struct lp8788_led *led =
> +			container_of(led_cdev, struct lp8788_led, led_dev);
> +	enum lp8788_isink_number num = led->isink_num;
> +	int enable;
> +
> +	switch (num) {
> +	case LP8788_ISINK_1:
> +	case LP8788_ISINK_2:
> +	case LP8788_ISINK_3:
> +		lp8788_write_byte(led->lp, lp8788_pwm_addr[num], brt_val);

The brightness_set() (and other) callbacks can be called from atomic
context so you can't interact with an I2C device here, you need to
defer to a workqueue or something (and ideally factor this out into the
framework so we don't need to keep open coding it...).

--ctP54qlpMx3WjD+/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBs25AAoJEBus8iNuMP3dEa4P/2oDA69G+uRcA/nz4WS8EGri
WFlnN8/LWrCTCFZjOqZYpsi/NhpsARCKcZopx3NEDbKPmswska33H46iTmaLR03H
tc3Zxoeh009kxCocAK8UDlcgcO/zXV6yG/vjxH+s1YQw04M6SOtCdwh177nLvSKg
tD6ZGkEislocnVPKcqEAB3iIW4fpN2ZiFGIQqiilxFcRDXUcehez1nbp+/5NyfNN
fsEx+upF/TDISns7CWt+3lneZEu7G+1hyRdnWHKwllD9hQGRw6W5DIry6jgx4e4M
CI5qblR7E9PqJ/UmKs5NPji3UCDBI2OQ2FUdFefiKhVBwjnX0pN2xq90V8ioV7kp
m0tiEJzZ2ZczxiPDzXUk38637x//LPuhx7TgHF2+w5q44Ewi4JzH+NZ+vO5LB1SP
eD9oahAY2PFWOdM4lFCI72OcgbKbvKWzwsRWiscy89Fv44Kfz/VqVYE1yvqGWklt
H5T9dPD5d1yZI1a2NgcudIe+2HfL5xFb92NtcM7DXodkgvwCmpbeYB1pUSYBIrel
iaUJmnEHJ00Iwo4sIOGFus2cItCIkYRwrg5VjfOwUXYVFeIqG0NPxZFT9E4CaoaQ
QBXghtm0jOQh+YVc+V13ciCoxkINKBXqTi8I0tEpe9DILoRpIurxuDCHJBFDNqIP
fG9G7sB+8SrwFUUq131s
=gZ4M
-----END PGP SIGNATURE-----

--ctP54qlpMx3WjD+/--
