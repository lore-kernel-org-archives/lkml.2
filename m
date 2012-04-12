Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965605Ab2DLP7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:59:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57753 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965522Ab2DLP7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:59:22 -0400
Date: Thu, 12 Apr 2012 16:59:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: Re: [PATCH 2/2] regulator: da9052: add device tree support
Message-ID: <20120412155917.GC3195@opensource.wolfsonmicro.com>
References: <1334245182-31725-2-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lMM8JwqTlfDpEaS6"
Content-Disposition: inline
In-Reply-To: <1334245182-31725-2-git-send-email-paul.liu@linaro.org>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 12, 2012 at 11:39:42PM +0800, Ying-Chun Liu (PaulLiu) wrote:

> +#ifdef CONFIG_OF
> +		struct device_node *nproot = da9052->dev->of_node;
> +		struct device_node *np;
> +		int c;
> +
> +		if (!nproot) {
> +			ret = -ENODEV;
> +			goto err;
> +		}
> +
> +		nproot = of_find_node_by_name(nproot, "regulators");
> +		if (!nproot) {
> +			ret = -ENODEV;
> +			goto err;
> +		}
> +
> +		c = 0;
> +		for (np = of_get_next_child(nproot, NULL);
> +		     np != NULL;
> +		     np = of_get_next_child(nproot, np)) {
> +			if (c == pdev->id) {
> +				initdata = of_get_regulator_init_data(
> +					&pdev->dev, np);
> +				break;
> +			}
> +			c++;
> +		}

This is really quite unclear but it looks like this is relying on the
order of regulators in the OF table to match things.  As I said in my
reply to the first patch this is really poor for usability and it's
also making the code here more obscure - we should be looking for the
regulator nodes by name.

--lMM8JwqTlfDpEaS6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhvu6AAoJEBus8iNuMP3dXhwP/jmIb9H1xFMAhDLaqOHRiCam
zkSJ265Wuf6vLDYm7ymRiW7rNXNB9La/YZKRku3NfhrEdcO8ZxYQHOWIWvcAOjaK
yk5Y3uLPX5sDX03X45VE2qWbbULsxCr/1aBEgbIA05tlU9bpfvcHPbvVOj5x6zZp
6QcqWBsWyBR4IAmZVSJVV6IcgvEYuEAr9Bg6NZBdI1BMa5kkPqggKI4KuCpGs0tL
WMWJMY+pU8s6cb4An1y2dJ2brS0as5i1OuFrta8iE7QTlpDZNlIhmuIcnTyZ5Zq9
KWC2AcetnfjnvsnpJTMa0Uzq7PPh/Zq4C0zECqzEUgqKAV7opVyLDzPWkdWrMlmr
+/+5mm/FXv+i/y/Q1eKI1JG1txtgk6v8pXmS2zultziLePOhL2k/tJZ7D3IRK9xk
NNJvjMVYp1Gpkf/fOEP4q30w2Ffl8h+rpI3zFrOZvezjMQvmfSBL6WuVAFaV26lw
xXmY/99KStdCMQ1XrLYIBTLaUdwUd2wXoI1uU9UeqE0Jl3ORk7jbmwgUTV4ISyGS
VFPSoaLw0c5chJTsGQV1rKoqmVoRCLo4yN2xaPCU8zYDBh3ylVjczWowkYd8ie4f
BC8anI/cz/nDqIR4/C5pnQ3hhcWs8YpEZDci/rBDPcCLO0/FOZ6zjNxhTU5n8RU+
z8AwYOFMiekiBgWYCboa
=a9so
-----END PGP SIGNATURE-----

--lMM8JwqTlfDpEaS6--
