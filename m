Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab2HUJKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:10:14 -0400
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:49387 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753657Ab2HUJKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:10:11 -0400
Date: Tue, 21 Aug 2012 12:06:12 +0300
From: Felipe Balbi <balbi@ti.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] spi: omap2-mcspi: At remove dont use the
 runtime_autosuspend calls
Message-ID: <20120821090611.GD10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345529864-7937-1-git-send-email-shubhrajyoti@ti.com>
 <1345529864-7937-4-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WChQLJJJfbwij+9x"
Content-Disposition: inline
In-Reply-To: <1345529864-7937-4-git-send-email-shubhrajyoti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WChQLJJJfbwij+9x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 11:47:44AM +0530, Shubhrajyoti D wrote:
> At remove we shouldnt be using the autosuspend timeout as we are
> calling pm_runtime_disable immediately after.
>=20
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>

Makes sense to me:

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/spi/spi-omap2-mcspi.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> index 5642111..f5bf628 100644
> --- a/drivers/spi/spi-omap2-mcspi.c
> +++ b/drivers/spi/spi-omap2-mcspi.c
> @@ -1243,8 +1243,7 @@ static int __devexit omap2_mcspi_remove(struct plat=
form_device *pdev)
>  	mcspi =3D spi_master_get_devdata(master);
>  	dma_channels =3D mcspi->dma_channels;
> =20
> -	pm_runtime_mark_last_busy(mcspi->dev);
> -	pm_runtime_put_autosuspend(mcspi->dev);
> +	pm_runtime_put_sync(mcspi->dev);
>  	pm_runtime_disable(&pdev->dev);
> =20
>  	spi_unregister_master(master);
> --=20
> 1.7.5.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--WChQLJJJfbwij+9x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM0+DAAoJEIaOsuA1yqRE/ZwP/2MZJ5PLpvsPiLsoXPhGhehj
0RCXvnpLWNdqowOqWOViwXEaKNS6lf9tJfOCM4b5KpPAWX1s6E6/YtBc4zA6OIQ4
iLxwKVf8tTshx6p0lyu9S5JE18C4hqYUrxItLutE2p1g3p+cxqeRu+c0q0gbzHQO
dxma5vT90JCRDlrgp1ZJLoEPz2pu/rIMrGqogOGyxDPP3XBVmCoDhAGkg4WhA/cM
iARJ2b+lGullOsUBFxrAlxprXQf9x8TwFL1FkfQph2On80UOWZNSqUQ9BwA8jSn8
V/oPqtcV8XQTHTmaa+fZl3yFemrsRCkCOVlQvna7by+cVc1fcRG1rH9DpxxtUERO
QCvXDYu1O9xvuKdJxS1UxzLNTl6iyb2jD8IwM37SShoQWnhDX1dt71eKlp7nBr1z
C4vj5Gs5a9CGT9FWi+xvGOd2w3l5+zVllup7Q7/4qO5cCXfCdkKar4/j8TtpqmMT
Bdi+uF2f1Vax7L0l0yEyQ+yclQxl3DDKI56Gg2VdfRISIqb04eTiazFvg8hd/q9p
dfVCYBDtqlqCXjkM73VDZXeB3ZhymN5ULS9ABFfgIvGUCwclcRrl6Mkx1WDqVr+j
myZmCpGHiKW8AcgRk9Tl9JthwwpNtn1YB0KD0XcIMw4GEbfEzXmSJgM9VINkKBde
toLeG9hiOomNvny80ekO
=AmdR
-----END PGP SIGNATURE-----

--WChQLJJJfbwij+9x--
