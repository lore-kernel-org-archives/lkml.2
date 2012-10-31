Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935610Ab2JaNwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:52:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58080 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422754Ab2JaNwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:52:41 -0400
Date: Wed, 31 Oct 2012 15:46:37 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <arnd@arndb.de>, <olof@lixom.net>, <rdunlap@xenotime.net>,
        <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] drivers: bus: ocp2scp: add pdata support
Message-ID: <20121031134637.GA10998@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1351344956-22868-1-git-send-email-kishon@ti.com>
 <1351344956-22868-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bc2iwAtkAaXP8cWF"
Content-Disposition: inline
In-Reply-To: <1351344956-22868-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bc2iwAtkAaXP8cWF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 27, 2012 at 07:05:54PM +0530, Kishon Vijay Abraham I wrote:
> ocp2scp was not having pdata support which makes *musb* fail for non-dt
> boot in OMAP platform. The pdata will have information about the devices
> that is connected to ocp2scp. ocp2scp driver will now make use of this
> information to create the devices that is attached to ocp2scp.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

just one small comment below. Other than that:

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/bus/omap-ocp2scp.c                 |   67 ++++++++++++++++++++++=
++++--
>  include/linux/platform_data/omap_ocp2scp.h |   31 +++++++++++++
>  2 files changed, 95 insertions(+), 3 deletions(-)
>  create mode 100644 include/linux/platform_data/omap_ocp2scp.h
>=20
> diff --git a/drivers/bus/omap-ocp2scp.c b/drivers/bus/omap-ocp2scp.c
> index ff63560..5db8297 100644
> --- a/drivers/bus/omap-ocp2scp.c
> +++ b/drivers/bus/omap-ocp2scp.c
> @@ -22,6 +22,26 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
> +#include <linux/platform_data/omap_ocp2scp.h>
> +
> +/**
> + * _count_resources - count for the number of resources
> + * @res: struct resource *
> + *
> + * Count and return the number of resources populated for the device tha=
t is
> + * connected to ocp2scp.
> + */
> +static unsigned _count_resources(struct resource *res)
> +{
> +	int cnt	=3D 0;
> +
> +	while (res->start !=3D res->end) {
> +		cnt++;
> +		res++;
> +	}
> +
> +	return cnt;
> +}
> =20
>  static int ocp2scp_remove_devices(struct device *dev, void *c)
>  {
> @@ -34,20 +54,61 @@ static int ocp2scp_remove_devices(struct device *dev,=
 void *c)
> =20
>  static int __devinit omap_ocp2scp_probe(struct platform_device *pdev)
>  {
> -	int			ret;
> -	struct device_node	*np =3D pdev->dev.of_node;
> +	int ret;
> +	unsigned res_cnt, i;
> +	struct device_node *np =3D pdev->dev.of_node;
> +	struct platform_device *pdev_child;
> +	struct omap_ocp2scp_platform_data *pdata =3D pdev->dev.platform_data;
> +	struct omap_ocp2scp_dev *dev;
> =20
>  	if (np) {
>  		ret =3D of_platform_populate(np, NULL, NULL, &pdev->dev);
>  		if (ret) {
> -			dev_err(&pdev->dev, "failed to add resources for ocp2scp child\n");
> +			dev_err(&pdev->dev,
> +			    "failed to add resources for ocp2scp child\n");
>  			goto err0;
>  		}
> +	} else if (pdata) {
> +		for (i =3D 0, dev =3D *pdata->devices; i < pdata->dev_cnt; i++,
> +		    dev++) {
> +			res_cnt =3D _count_resources(dev->res);
> +
> +			pdev_child =3D platform_device_alloc(dev->drv_name, -1);

please use PLATFORM_DEVID_AUTO instead.

--=20
balbi

--bc2iwAtkAaXP8cWF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkSu9AAoJEIaOsuA1yqRETFsQAJh4MKzM+pzPyV11dOvCu0Md
RW4XOjIWxvu6m6ScXHpqj5N/CCd6BkbZxTE2RpXoBgm2vAFfi86ebWXgqM13zzMB
0xuRV56qrBpP9oP8m45qxcz9E7YeJA4p9b7FFdOf48TKUX9wN8uLKVDQqQ9C55JZ
EMY72WGkTFZHT7El7p798+Ix6CnJilsg7OinK12vnkUaHQ8oNNYeSxFKWdVmj3Rm
2Y/zS0IEpaoF/QvsYTLnN8+quz2pq2+FGJKg+unQrZ4QeGaInlTIl9ak9ypRIaWb
IUvuODF6N3OEjbxZ6Fy7HH+U50VlOzH8hPDOreziQ6o4sdHwuOTwxUwg6wB6lf57
qRLqBwfLXklCf0CVbgV4hxUnvM2V5HHEo/NSwXx9x70kUz2tuMUZP12LQ5fgpgAE
YspGEtgw2uB20VhuIuJNuj6FYLFIDJXFUQ3JaCyCasEHkUlUjwKedtNNbx5PjcDf
t+k83X9ZTAyVG2ztHI/98QGR6zucE0wYe36F+IEXme1ZW5E2mbLLwHEQg19bfMDd
rWZr1mmiq5NqFfHYl0oJLg32d9BSmxPaQar6yhPXmlt1J9fQO3WF29FsgjHVH43y
zofN6nFLznFv7I9p6Jx2RrkEutfgUYoU6Ihu1TnqRXkxvhrcgRt5ZF/7yeHHpR/H
nK3iOSBQ6xGhfI+aEA4S
=uTsB
-----END PGP SIGNATURE-----

--bc2iwAtkAaXP8cWF--
