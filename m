Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2BBMwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:52:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38079 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752869Ab2BBMwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:52:53 -0500
Date: Thu, 2 Feb 2012 12:52:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 7/7] MFD: TWL6040: Add regulator support for VIO, V2V1
 supplies
Message-ID: <20120202125250.GJ7428@opensource.wolfsonmicro.com>
References: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com>
 <1328185019-29575-8-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBdJBemW82xJqIAr"
Content-Disposition: inline
In-Reply-To: <1328185019-29575-8-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBdJBemW82xJqIAr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 02, 2012 at 02:16:59PM +0200, Peter Ujfalusi wrote:

> +	twl6040->vio = regulator_get(&client->dev, "vio");
> +	if (IS_ERR(twl6040->vio)) {
> +		ret = PTR_ERR(twl6040->vio);
> +		dev_err(&client->dev, "Failed to request VIO supply: %d\n",
> +			ret);
> +		goto regulator_get_err;
> +	}
> +	twl6040->v2v1 = regulator_get(&client->dev, "v2v1");
> +	if (IS_ERR(twl6040->v2v1)) {
> +		ret = PTR_ERR(twl6040->v2v1);
> +		dev_err(&client->dev, "Failed to request V2V1 supply: %d\n",
> +			ret);
> +		regulator_put(twl6040->vio);
> +		goto regulator_get_err;
> +	}

Looks like you want regulator_bulk_get() here.  Or (better yet though
it'd be a potential issue for merge via MFD and the benefits aren't that
exciting since you still need to disable) devm_regulator_bulk_get().

> +	ret = regulator_enable(twl6040->vio);
> +	if (ret != 0) {
> +		dev_err(&client->dev, "Failed to enable VIO: %d\n", ret);
> +		goto power_err;
> +	}
> +	ret = regulator_enable(twl6040->v2v1);
> +	if (ret != 0) {
> +		dev_err(&client->dev, "Failed to enable V2V1: %d\n", ret);
> +		regulator_disable(twl6040->vio);
> +		goto power_err;
> +	}

Similarly regulator_bulk_enable() here, and it'll fix...

>  gpio1_err:
> +	regulator_disable(twl6040->v2v1);
> +	regulator_disable(twl6040->vio);

...the fact that if you fail to enable the v2.1 regulator you don't
disable vio.

--gBdJBemW82xJqIAr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKocbAAoJEBus8iNuMP3dZ34P/0eSJ5nReLPQ7l+MLlZHOY/Q
Z993OIDFDzV1VpQqU0FcrVZOhHQ/FAnzjUYQLHU6K974ZwF5ZbgE3OGTklhFSp5N
3XovWeyaf4vWlYNtXjOlCtXdjTGmmxKeN69IGUsijy6Wc9+NDnYIdqwS/FYmcJRS
ygGzpdsSFM7/AexQSlbW1GVCkX264MrnkoC84ucO+stmAVrhvthLm7591AMmkJNn
EkzaSID0VZWYACIt+s0ANHR2cBER7/tPK8pkJKqMDXCW0SCnlpfsp2b7iudwkRX2
Ua6vxCN7Y31wfpD/OKn8VMtayPutF0hJYSRibFZ8crgAHS/ctw0Mf4YXgtGLGBLU
EAKL88xZF15TqMMT6fcnKWrIC9FKAgukfsuHnhxTLqxHyTdLS1B2xYQbjpvboUq6
Mnqj8NhlAHxVee9mAb8onMQuzdXxsyWgZwehtIlQkW0AbZtuVU4Ah4DG7++K/iad
hBC6sD7mH4HYpxcYw26fIuZdoM8gakAunV963uHHYoQUkSBYhyPotjbuXSZFs6J0
N9OFfKZdbh/5hEbHWV5bJftrT0XzfekN66Rvle7s9WjpUMV6RTZhGRHpM8C+MhT1
8yFcZhr+RqDCpbWV9jL7wQqrB2NdqJpneIZtI7nAd13KAIFglz/OvZ0DLi7LJo+y
hBTmYQNy1Um9O4ZioqRd
=278o
-----END PGP SIGNATURE-----

--gBdJBemW82xJqIAr--
