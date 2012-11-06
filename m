Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab2KFJBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:01:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54357 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119Ab2KFJBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 04:01:41 -0500
Date: Tue, 6 Nov 2012 10:01:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Qing Xu <qingx@marvell.com>
Cc: lrg@ti.com, sameo@linux.intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, haojian.zhuang@gmail.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 5/7] mfd: max8925: support dt for regulator
Message-ID: <20121106090137.GH5044@opensource.wolfsonmicro.com>
References: <1352187892-9940-1-git-send-email-qingx@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRdC2OsRnuV8iIl8"
Content-Disposition: inline
In-Reply-To: <1352187892-9940-1-git-send-email-qingx@marvell.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRdC2OsRnuV8iIl8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 06, 2012 at 03:44:52PM +0800, Qing Xu wrote:
> From: Qing Xu <qingx@marvell.com>
>=20
> Signed-off-by: Qing Xu <qingx@marvell.com>
> ---
>  drivers/regulator/max8925-regulator.c |   35 +++++++++++++++++++++++++++=
+++++-
>  1 files changed, 34 insertions(+), 1 deletions(-)

There is no binding document here, documentation is required for all new
bindings.

> +	nproot =3D of_find_node_by_name(nproot, "regulators");
> +	if (!nproot) {
> +		dev_err(&pdev->dev, "failed to find regulators node\n");
> +		return -ENODEV;
> +	}
> +	for_each_child_of_node(nproot, np) {
> +		if (!of_node_cmp(np->name, info->desc.name)) {
> +			config->init_data =3D
> +				of_get_regulator_init_data(&pdev->dev, np);
> +			config->of_node =3D np;
> +			break;
> +		}
> +	}

You appear to be open coding something like the standard helpers in
of_regulator.h, you should use those helpers.

--jRdC2OsRnuV8iIl8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQmNHmAAoJELSic+t+oim9Y34P/iZshhKw7FQXJ0noCBB2fdMq
M0Qz9pElSZfr6urxvCCfqEHdE7HDQUzL2yBRrAJvE/HbLHPKe6IBmi26YAC0lgrj
E1w6UaLemW9fhVOFlarMu5OCLe7g/+/ZW9Vg7cFe18SDeNjugwa8tb6Ev+frXuv+
Fm56fh9G/Qir6moTfkVI95mgFSvWdYHgFOvV2qvRIgqWh1YakAdVk3MXgU2lmutV
FEn1WaqAW5NvDQ2+7QERpLPOx4KoKcXN/iXL8kB4ZK3VBM7ov7YlJ69xAu/HtEyF
SWMkIO0KJO0RXcLEsDhhxCXPcMztl2OjO6bpn3ivL5EjaRzMugrqLE97JCym4rA7
7nWQVYEoN3qOv2phfuKKrURd9wd37HupWlKPasgtrP8ASJv0+2pwr9t87t4sBss9
ewb8ygRnUFX5Lz4HBV6VsBqiTPa21l0P+0NeJDIW2NXMqtAln4M8RAzgxk/m98Zo
+Z8W6qG0chnnxQyysCiiz27y53xdQGPJoGtepG7d8ujyv17uudScsUjIBxF1I5KU
fPziep/ifR2XpO27fuOfb2pAHD3RU78S4HND1ZhCostxw86vvpy4zAGiAzDkFDci
WdHFreMWFl4yET8COSJ/PkaCxyzCwGSHZabO4W9LQlACELPNTX/omwRSqdvdcfPA
cgqLWduQ2Ejs7TpKvwqn
=za1r
-----END PGP SIGNATURE-----

--jRdC2OsRnuV8iIl8--
