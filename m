Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2KMJxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:53:41 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35225 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab2KMJxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:53:40 -0500
Date: Tue, 13 Nov 2012 11:47:22 +0200
From: Felipe Balbi <balbi@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH] usb: otg: twl4030: Change TWL4030_MODULE_* ids to
 TWL_MODULE_*
Message-ID: <20121113094722.GB10395@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1352799818-22363-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Content-Disposition: inline
In-Reply-To: <1352799818-22363-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 13, 2012 at 10:43:38AM +0100, Peter Ujfalusi wrote:
> To facilitate upcoming cleanup in twl stack.
> No functional changes.
>=20
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

I guess this one must go together with the rest of your series...

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/otg/twl4030-usb.c | 46 ++++++++++++++++++++-----------------=
------
>  1 file changed, 21 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
> index f0d2e75..11b2a12 100644
> --- a/drivers/usb/otg/twl4030-usb.c
> +++ b/drivers/usb/otg/twl4030-usb.c
> @@ -123,10 +123,10 @@
>  #define PHY_CLK_CTRL_STS		0xFF
>  #define PHY_DPLL_CLK			(1 << 0)
> =20
> -/* In module TWL4030_MODULE_PM_MASTER */
> +/* In module TWL_MODULE_PM_MASTER */
>  #define STS_HW_CONDITIONS		0x0F
> =20
> -/* In module TWL4030_MODULE_PM_RECEIVER */
> +/* In module TWL_MODULE_PM_RECEIVER */
>  #define VUSB_DEDICATED1			0x7D
>  #define VUSB_DEDICATED2			0x7E
>  #define VUSB1V5_DEV_GRP			0x71
> @@ -195,14 +195,14 @@ static int twl4030_i2c_write_u8_verify(struct twl40=
30_usb *twl,
>  }
> =20
>  #define twl4030_usb_write_verify(twl, address, data)	\
> -	twl4030_i2c_write_u8_verify(twl, TWL4030_MODULE_USB, (data), (address))
> +	twl4030_i2c_write_u8_verify(twl, TWL_MODULE_USB, (data), (address))
> =20
>  static inline int twl4030_usb_write(struct twl4030_usb *twl,
>  		u8 address, u8 data)
>  {
>  	int ret =3D 0;
> =20
> -	ret =3D twl_i2c_write_u8(TWL4030_MODULE_USB, data, address);
> +	ret =3D twl_i2c_write_u8(TWL_MODULE_USB, data, address);
>  	if (ret < 0)
>  		dev_dbg(twl->dev,
>  			"TWL4030:USB:Write[0x%x] Error %d\n", address, ret);
> @@ -227,7 +227,7 @@ static inline int twl4030_readb(struct twl4030_usb *t=
wl, u8 module, u8 address)
> =20
>  static inline int twl4030_usb_read(struct twl4030_usb *twl, u8 address)
>  {
> -	return twl4030_readb(twl, TWL4030_MODULE_USB, address);
> +	return twl4030_readb(twl, TWL_MODULE_USB, address);
>  }
> =20
>  /*----------------------------------------------------------------------=
---*/
> @@ -264,8 +264,7 @@ static enum omap_musb_vbus_id_status
>  	 * signal is active, the OTG module is activated, and
>  	 * its interrupt may be raised (may wake the system).
>  	 */
> -	status =3D twl4030_readb(twl, TWL4030_MODULE_PM_MASTER,
> -			STS_HW_CONDITIONS);
> +	status =3D twl4030_readb(twl, TWL_MODULE_PM_MASTER, STS_HW_CONDITIONS);
>  	if (status < 0)
>  		dev_err(twl->dev, "USB link status err %d\n", status);
>  	else if (status & (BIT(7) | BIT(2))) {
> @@ -372,8 +371,7 @@ static void twl4030_phy_power(struct twl4030_usb *twl=
, int on)
>  		 * SLEEP. We work around this by clearing the bit after usv3v1
>  		 * is re-activated. This ensures that VUSB3V1 is really active.
>  		 */
> -		twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0,
> -							VUSB_DEDICATED2);
> +		twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB_DEDICATED2);
>  		regulator_enable(twl->usb1v5);
>  		__twl4030_phy_power(twl, 1);
>  		twl4030_usb_write(twl, PHY_CLK_CTRL,
> @@ -419,50 +417,48 @@ static void twl4030_phy_resume(struct twl4030_usb *=
twl)
>  static int twl4030_usb_ldo_init(struct twl4030_usb *twl)
>  {
>  	/* Enable writing to power configuration registers */
> -	twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
> -			TWL4030_PM_MASTER_KEY_CFG1,
> -			TWL4030_PM_MASTER_PROTECT_KEY);
> +	twl_i2c_write_u8(TWL_MODULE_PM_MASTER, TWL4030_PM_MASTER_KEY_CFG1,
> +			 TWL4030_PM_MASTER_PROTECT_KEY);
> =20
> -	twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
> -			TWL4030_PM_MASTER_KEY_CFG2,
> -			TWL4030_PM_MASTER_PROTECT_KEY);
> +	twl_i2c_write_u8(TWL_MODULE_PM_MASTER, TWL4030_PM_MASTER_KEY_CFG2,
> +			 TWL4030_PM_MASTER_PROTECT_KEY);
> =20
>  	/* Keep VUSB3V1 LDO in sleep state until VBUS/ID change detected*/
> -	/*twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB_DEDICATED2);*/
> +	/*twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB_DEDICATED2);*/
> =20
>  	/* input to VUSB3V1 LDO is from VBAT, not VBUS */
> -	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0x14, VUSB_DEDICATED1);
> +	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0x14, VUSB_DEDICATED1);
> =20
>  	/* Initialize 3.1V regulator */
> -	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB3V1_DEV_GRP);
> +	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB3V1_DEV_GRP);
> =20
>  	twl->usb3v1 =3D regulator_get(twl->dev, "usb3v1");
>  	if (IS_ERR(twl->usb3v1))
>  		return -ENODEV;
> =20
> -	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB3V1_TYPE);
> +	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB3V1_TYPE);
> =20
>  	/* Initialize 1.5V regulator */
> -	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V5_DEV_GRP);
> +	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB1V5_DEV_GRP);
> =20
>  	twl->usb1v5 =3D regulator_get(twl->dev, "usb1v5");
>  	if (IS_ERR(twl->usb1v5))
>  		goto fail1;
> =20
> -	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V5_TYPE);
> +	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB1V5_TYPE);
> =20
>  	/* Initialize 1.8V regulator */
> -	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V8_DEV_GRP);
> +	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB1V8_DEV_GRP);
> =20
>  	twl->usb1v8 =3D regulator_get(twl->dev, "usb1v8");
>  	if (IS_ERR(twl->usb1v8))
>  		goto fail2;
> =20
> -	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V8_TYPE);
> +	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB1V8_TYPE);
> =20
>  	/* disable access to power configuration registers */
> -	twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0,
> -			TWL4030_PM_MASTER_PROTECT_KEY);
> +	twl_i2c_write_u8(TWL_MODULE_PM_MASTER, 0,
> +			 TWL4030_PM_MASTER_PROTECT_KEY);
> =20
>  	return 0;
> =20
> --=20
> 1.8.0
>=20

--=20
balbi

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQohcqAAoJEIaOsuA1yqRErNQP/RIwnYrD8POcAeEvoEdsijH1
2NQXQ6L1mV53rSe9JtWNhhF/J/kikbkhaG3VyGbDiApfuOw7TKBSq+iVKiFNLdKv
PufetH7AwcVfDKxIekAhUrchQPg9FVFj53Zd5pqYTki5aqwwlQhtv4rFo8sWjUxV
xJ5YDwprBpO9U3XPQJgnBfnF/dkaBZS2GfaIxVea9xOBV+UI5FVZi0Wf1zAEUzq0
YAojOsCod6+aFJRgIS0zFBEwZtfQNDai52iRKT3GYPq+a9GcO6lfP81VyEvBFkPz
kIZw0BM3W4UzwQNPykEKhXiO5Oh5PBxzCXE5991Xa03IDkFsA0xC3+2qqqmfLI6W
dL5upM416wCUI58K28tzi29nOAiE8PijZP7XHVu/Q6vzLinKtB2xM59DRZFt3UFb
zq3MY1Nlic5757lJEc+O+j3Zmi+LG9PAkYJc2ykISRBPTNufZFTc51JjyTNZyRfV
2tbusRZ7a+rdBrdVE7mvLfk5pe9CtwA0Yans7qrJ7o3Ry5P+RjE/HvFFPKydt9kz
76bwp4IbRXS2aprk1b3X6oMNyzSUkDuQFuc/C3yby45qQC+bM1Q25F/ZM4hjpIgo
8HnJICxYMDekOwA8e28sQXUxO5b1TEv+2fVqI97KGYoku0oyAlTj/OWtElijUvCE
ctiMdZnLlXc8MLI43Qqu
=/nvN
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
