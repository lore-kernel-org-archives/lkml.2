Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166Ab2KIIGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 03:06:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55393 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2KIIGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 03:06:32 -0500
Date: Fri, 9 Nov 2012 09:06:04 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pwm-backlight: Pinctrl-fy
Message-ID: <20121109080604.GA25611@avionic-0098.mockup.avionic-design.de>
References: <1351699047-4487-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <1351699047-4487-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:u2QXPibAd/wFhOpvapVCBbw1FP3ZCHHuhLUeWVghWue
 nSWKrAuPD25nZSz/GxH9jpa1ut2ww5eJyGYwfjXE3R+XSrLJga
 o8bbj1upVjmo5foE/BwdIyI+BIPyTaapZetCtJMInBVOxJ9IzZ
 R7kUWjnHtrlH1VPRwG6ysOCMegIJDmpAHAHXmK/kfGPIpca4Um
 9QWqfpXeee2hQfhBWrjPyS41w/cfzqZcTjaaJuNIH71WNDXCtH
 ClPVqVXZCcln6j5XjlhRtbFiNjyfPBswCfcZzMPmCGiq71/xgB
 KHrPjAElWSovVGV3mdT1KlBm4EJFdukHKGMkWjVNUxzaUcBalY
 3ncyEjyLXt2rQZNVwUKlgp6yFqIuIh8/1Yax8OyCOTKhzQqdj9
 j3dSDAPj63PDefm5zYLF7flHg4XtxJOGH9myS+dtlrsXxfWNfz
 IDHa6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 31, 2012 at 05:57:27PM +0200, Pantelis Antoniou wrote:
> Enable pinctrl for pwm-backlight.
>=20
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  drivers/video/backlight/pwm_bl.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/p=
wm_bl.c
> index 0c91023..f3b6194 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -20,6 +20,8 @@
>  #include <linux/pwm.h>
>  #include <linux/pwm_backlight.h>
>  #include <linux/slab.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/err.h>
> =20
>  struct pwm_bl_data {
>  	struct pwm_device	*pwm;
> @@ -180,9 +182,14 @@ static int pwm_backlight_probe(struct platform_devic=
e *pdev)
>  	struct backlight_properties props;
>  	struct backlight_device *bl;
>  	struct pwm_bl_data *pb;
> +	struct pinctrl *pinctrl;
>  	unsigned int max;
>  	int ret;
> =20
> +	pinctrl =3D devm_pinctrl_get_select_default(&pdev->dev);
> +	if (IS_ERR(pinctrl))
> +		dev_warn(&pdev->dev, "unable to select pin group\n");
> +

I just saw this done in a similar way in some other driver and then
remembered your patch. When I reviewed this I wasn't sure if a warning
was good enough in this case. I've checked the kernel tree and it seems
like a majority handled this as failure instead of a warning. I took a
look at the pinctrl core and it seems like indeed if neither pinctrl is
enabled or if there isn't actually a pinmux configuration for a device,
then devm_pinctrl_get_select_default() will actually not return an
error, so in those cases where an error is returned it should actually
be handled as a fatal error.

I'm Cc'ing Linus Walleij, maybe he knows what to do.

Thierry

>  	if (!data) {
>  		ret =3D pwm_backlight_parse_dt(&pdev->dev, &defdata);
>  		if (ret < 0) {
> --=20
> 1.7.12
>=20
>=20
>=20

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnLlsAAoJEN0jrNd/PrOhPyAQAKKFa+hm98eF89n9eweQiQ/J
VlzY2S6XiSOZaCGbekwla/B7lh6Tq2rqbUM3OZYdDKGvY/sCDcBZRK/8UmmwSoVx
GvZD+6Mq0IRnBkF0xJPO5bYp1lAVOosDP9XYucmIKK5USqV67TKg/Tims1N3yEim
29nnJlLNgHDrbkEQ3gVHdQB9Pfb2mYvbEflGOf6Wc+keVmRNTYtgmjmxNY18Igi8
h7Gxb/15Ic0ytIQdtZ0zRos2V1lfvreWAxCCSl/4i1jwGjVY2Cy3U+K8fNiQy0nA
fBV5OpbwjUCSgia8vQGZ1gA8+saO//ys0OV2Ul8ejztDKW/DN1z3D4fLxCDCeAOE
e5LCfd6IVpFeU/SHSWF7Yw30WisvCYrc7QCnaHR2v1W8q1rEtGwLZEUIrPq5NO80
eyoULAQs8mL/AyYQVArU/vzoWf0ZP6VNQHqVfCKnXRGdbD5N+mhkCOIfhG/hLSg2
VcYd3ZmZ7K3ejhhQ4zRXuJunNdbYMNJ++6rnszdkBFCD18QE/ljWjuQDfUqZ6wOT
OxHr9BNnKHqSnXi2N1i0ITBuqQO3UJByiJQATXUhyISMpMRB7lnX1liH4Q2S7j7p
8hHFq8Ixob0ALmSdjY++wOmdnUX5kpmCNa3x/OeQu1CA9r1f4VneJUlPnv3ezSNm
L6fBMPqs9Lh7ZtLRgUZA
=inHc
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
