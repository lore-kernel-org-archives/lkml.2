Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224Ab2IKOlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:41:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53507 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759423Ab2IKOln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:41:43 -0400
Date: Tue, 11 Sep 2012 16:40:43 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 5/7] pwm: i.MX: add devicetree support
Message-ID: <20120911144043.GA3824@avionic-0098.mockup.avionic-design.de>
References: <1347267577-3296-1-git-send-email-s.hauer@pengutronix.de>
 <1347267577-3296-6-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <1347267577-3296-6-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ZOVIU/AqD8NUJ3eDGqtoShZ08OuCpGwsl4/tbCGb96H
 SccBxPPR2HNLCg4to160XTYxHJzwpHLnazncNJZjCUbPfgfnxu
 poxX1rBSjCzOWyM/PY8SkxP/HGhJygZ4gaPdqF4vNBgOA/t1vk
 E588dAiZiGZ1xlwJG28neYD2nuoNt+XEvIfcu/Fmy55bMGSyRA
 Q796W8cSlTuXYOzqcdmc55SIe/6GxN31gv/D/AeqcaLI/8Kvqq
 jM/zBSustpqTDm1xyWNp+E5p//wZ2GS9ptWY1CSwLPpQPz1dR5
 2qfx7YV8x0J1lar0NRwfPMKfazg6acBjvK2LUnhKMwqtIlKhMh
 drCjniPk77nz8t1SEXo4qLZ1MX9PTUvP5gmHuxqCazdNTf+I2M
 HToto0k4QW6FcKefWYqe45CUgrZiVSLFy3d8oOQaml2xx9SCIf
 VA5tC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 10, 2012 at 10:59:35AM +0200, Sascha Hauer wrote:
> From: Philipp Zabel <p.zabel@pengutronix.de>
>=20
> At the same time remove platform based support. No user for
> this driver has made it into mainline so far, so all we break
> is out of tree stuff.
>=20
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
> Reviewed-by: Beno=C3=AEt Th=C3=A9baudeau <benoit.thebaudeau@advansee.com>
[...]

I was just doing some build tests on the series and noticed that it
fails with this:

	  CC [M]  drivers/pwm/pwm-imx.o
	/home/thierry.reding/src/kernel/linux-pwm.git/drivers/pwm/pwm-imx.c: In fu=
nction 'imx_pwm_config_v2':
	/home/thierry.reding/src/kernel/linux-pwm.git/drivers/pwm/pwm-imx.c:140:2:=
 error: implicit declaration of function 'cpu_is_mx25' [-Werror=3Dimplicit-=
function-declaration]

This breaks bisection in the middle of the series. It seems to be
related to this change.

> diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
> index a1e799e..b4e0ad3 100644
> --- a/drivers/pwm/pwm-imx.c
> +++ b/drivers/pwm/pwm-imx.c
> @@ -16,8 +16,7 @@
>  #include <linux/clk.h>
>  #include <linux/io.h>
>  #include <linux/pwm.h>
> -#include <mach/hardware.h>

This probably needs to be postponed to the next patch, until the final
reference to cpu_is_mx25() is removed.

Thierry

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQT01rAAoJEN0jrNd/PrOhfXEQAMI62kxsWcO90a2VKH/mn3nl
jqNvLMe4jL+dlmqZqrL4vkATU1FNuuglF5Tu+aay1nXpDvSAJ/SEg2+tPLWDVomO
p09fXMllaMCr8ol8LouE10yYPWW+uM66ZAoXbnLrkDhjLd4g/fdV9mRnhnojalpe
U5YPrEpRh3axUo8SwE+hptJ/AJE1i/wopIDt7SvYurDxKNN9UaVex9mmZ1ZBspa+
cRckUuT+NRf/+YnwCtOL9BNvIVGqjKscbP2dzWGOsfEHzTgmQ2BPaMBM407xU7kz
geJvGNkJ4MBEz0fEOHREWInfrrB017FQSfUSdcXwsZL5xq6QbOpBG6LqDlGuhEhN
M+yuua4eXaKT+EPXGS8u4ruhzMv/9fcECSBKcsDgFPbMbHKqAZ51rxTW/X6Pna3w
6jCq1iRoD3wwUOr+iRSnm8qsubckqhqY1KSPodt2mt0Bh11Etq9ANvSkHy3AYmL3
i19eoEaSIPbENRJ+PmsiaIDfv2o0naItVeDL+ZzeYmRBTz1gDX6Rk8UpCtfhS4vp
7ImQthwUynB7KY90oBfpXD56q6jI5GHKgrkJfDoDSpQyGOHdNxb/DnvKzhvRKJsu
y8SjAFI2Gk+geet035cgEKEO9fsEwx7wVqOafSZcq0wuFR1U3gGqlJefW+OhaOTX
srmCNpG1P5DhPL2pb4g1
=qS+n
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
