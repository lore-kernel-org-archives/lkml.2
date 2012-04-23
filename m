Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2DWLP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:15:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42991 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2DWLPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:15:25 -0400
Date: Mon, 23 Apr 2012 13:15:07 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        David Daney <ddaney.cavm@gmail.com>
Subject: Re: [PATCH 1/2] i2c: mux: add device tree support
Message-ID: <20120423111507.GF19192@pengutronix.de>
References: <1334688545-8465-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s5/bjXLgkIwAv6Hi"
Content-Disposition: inline
In-Reply-To: <1334688545-8465-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s5/bjXLgkIwAv6Hi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 17, 2012 at 12:49:04PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> * Define core portions of the DT binding for I2C bus muxes.
> * Enhance i2c_add_mux_adapter():
> ** Add parameters required for DT support. Update all callers.
> ** Set the appropriate adap->dev.of_node for the child bus.
> ** Call of_i2c_register_devices() for the child bus.
>=20
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

David Daney (CCed) posted another variant [1]. Just looking at the
patches (and not really using them), I tend to like the approach using
<reg> better. But I am open for discussion, so I'd appreciate your
feedback.

Regards,

   Wolfram

[1] http://lkml.org/lkml/2012/4/12/423

> ---
> Note: This series depends on the 3 patches I just sent that affect
> of_find_i2c_device_by_node and implement of_find_i2c_adapter_by_node.
> It might be useful to put this patch (and the others I sent) in
> a separate tree so it can be merged into any SoC trees that wish to use
> this new feature.
>=20
>  Documentation/devicetree/bindings/i2c/i2cmux.txt |   45 ++++++++++++++++=
++++++
>  drivers/i2c/i2c-mux.c                            |   23 +++++++++++-
>  drivers/i2c/muxes/gpio-i2cmux.c                  |    5 +-
>  drivers/i2c/muxes/pca9541.c                      |    4 +-
>  drivers/i2c/muxes/pca954x.c                      |    4 +-
>  include/linux/i2c-mux.h                          |    4 +-
>  6 files changed, 77 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2cmux.txt
>=20
> diff --git a/Documentation/devicetree/bindings/i2c/i2cmux.txt b/Documenta=
tion/devicetree/bindings/i2c/i2cmux.txt
> new file mode 100644
> index 0000000..1e4e2bc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2cmux.txt
> @@ -0,0 +1,45 @@
> +Common I2C mux bindings
> +
> +An I2C mux is a device that connects a master I2C bus to one of a number=
 of
> +child I2C busses, under programmatic control.
> +
> +Each I2C mux may define the set of child busses it supports in a differe=
nt
> +way. Some devices may have a hard-coded set of child ports, whereas othe=
rs may
> +support a varying set of child busses (especially when the bus mux is
> +implemented using GPIOs or pin muxing). Any bindings required to represe=
nt
> +this are the domain of the individual mux device.
> +
> +For each child bus, there shall be a node within the I2C mux's own node =
for
> +that bus. This node will contain all the I2C devices on that bus, just l=
ike
> +any other I2C bus. Each child bus shall be identified by some name. The =
set
> +of child bus names is defined by the individual I2C mux's bindings. Bus =
names
> +are used to construct the name of the bus's child node using the format
> +i2c-bus-%s. Each child bus node needs the usual #address-cells and #size=
-cells
> +properties.
> +
> +Example:
> +
> +	i2cmux {
> +		// properties here omitted from the example.
> +
> +		i2c-bus-0 {
> +			#address-cells =3D <1>;
> +			#size-cells =3D <0>;
> +
> +			eeprom {
> +				compatible =3D "eeprom";
> +				reg =3D <0x50>;
> +			};
> +		};
> +
> +		i2c-bus-1 {
> +			#address-cells =3D <1>;
> +			#size-cells =3D <0>;
> +
> +			eeprom {
> +				compatible =3D "eeprom";
> +				reg =3D <0x50>;
> +			};
> +		};
> +	};
> +
> diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
> index d7a4833..8adeeec 100644
> --- a/drivers/i2c/i2c-mux.c
> +++ b/drivers/i2c/i2c-mux.c
> @@ -24,6 +24,7 @@
>  #include <linux/slab.h>
>  #include <linux/i2c.h>
>  #include <linux/i2c-mux.h>
> +#include <linux/of_i2c.h>
> =20
>  /* multiplexer per channel data */
>  struct i2c_mux_priv {
> @@ -86,8 +87,10 @@ static u32 i2c_mux_functionality(struct i2c_adapter *a=
dap)
>  	return parent->algo->functionality(parent);
>  }
> =20
> -struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
> +struct i2c_adapter *i2c_add_mux_adapter(struct device *dev,
> +				struct i2c_adapter *parent,
>  				void *mux_dev, u32 force_nr, u32 chan_id,
> +				const char *chan_name,
>  				int (*select) (struct i2c_adapter *,
>  					       void *, u32),
>  				int (*deselect) (struct i2c_adapter *,
> @@ -124,6 +127,22 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_a=
dapter *parent,
>  	priv->adap.algo_data =3D priv;
>  	priv->adap.dev.parent =3D &parent->dev;
> =20
> +	if (dev->of_node) {
> +		const char *name;
> +
> +		if (chan_name)
> +			name =3D kasprintf(GFP_KERNEL, "i2c-bus-%s",
> +					     chan_name);
> +		else
> +			name =3D kasprintf(GFP_KERNEL, "i2c-bus-%d",
> +					     chan_id);
> +
> +		priv->adap.dev.of_node =3D of_find_node_by_name(dev->of_node,
> +							      name);
> +
> +		kfree(name);
> +	}
> +
>  	if (force_nr) {
>  		priv->adap.nr =3D force_nr;
>  		ret =3D i2c_add_numbered_adapter(&priv->adap);
> @@ -141,6 +160,8 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_ad=
apter *parent,
>  	dev_info(&parent->dev, "Added multiplexed i2c bus %d\n",
>  		 i2c_adapter_id(&priv->adap));
> =20
> +	of_i2c_register_devices(&priv->adap);
> +
>  	return &priv->adap;
>  }
>  EXPORT_SYMBOL_GPL(i2c_add_mux_adapter);
> diff --git a/drivers/i2c/muxes/gpio-i2cmux.c b/drivers/i2c/muxes/gpio-i2c=
mux.c
> index e5fa695..7284c70 100644
> --- a/drivers/i2c/muxes/gpio-i2cmux.c
> +++ b/drivers/i2c/muxes/gpio-i2cmux.c
> @@ -105,8 +105,9 @@ static int __devinit gpiomux_probe(struct platform_de=
vice *pdev)
>  	for (i =3D 0; i < pdata->n_values; i++) {
>  		u32 nr =3D pdata->base_nr ? (pdata->base_nr + i) : 0;
> =20
> -		mux->adap[i] =3D i2c_add_mux_adapter(parent, mux, nr, i,
> -						   gpiomux_select, deselect);
> +		mux->adap[i] =3D i2c_add_mux_adapter(&pdev->dev, parent, mux, nr,
> +						   i, NULL, gpiomux_select,
> +						   deselect);
>  		if (!mux->adap[i]) {
>  			ret =3D -ENODEV;
>  			dev_err(&pdev->dev, "Failed to add adapter %d\n", i);
> diff --git a/drivers/i2c/muxes/pca9541.c b/drivers/i2c/muxes/pca9541.c
> index e0df9b6..e1777fb 100644
> --- a/drivers/i2c/muxes/pca9541.c
> +++ b/drivers/i2c/muxes/pca9541.c
> @@ -353,8 +353,8 @@ static int pca9541_probe(struct i2c_client *client,
>  	force =3D 0;
>  	if (pdata)
>  		force =3D pdata->modes[0].adap_id;
> -	data->mux_adap =3D i2c_add_mux_adapter(adap, client, force, 0,
> -					     pca9541_select_chan,
> +	data->mux_adap =3D i2c_add_mux_adapter(&client->dev, adap, client, forc=
e,
> +					     0, NULL, pca9541_select_chan,
>  					     pca9541_release_chan);
> =20
>  	if (data->mux_adap =3D=3D NULL) {
> diff --git a/drivers/i2c/muxes/pca954x.c b/drivers/i2c/muxes/pca954x.c
> index 0e37ef2..736a803 100644
> --- a/drivers/i2c/muxes/pca954x.c
> +++ b/drivers/i2c/muxes/pca954x.c
> @@ -226,8 +226,8 @@ static int pca954x_probe(struct i2c_client *client,
>  		}
> =20
>  		data->virt_adaps[num] =3D
> -			i2c_add_mux_adapter(adap, client,
> -				force, num, pca954x_select_chan,
> +			i2c_add_mux_adapter(&client->dev, adap, client,
> +				force, num, NULL, pca954x_select_chan,
>  				(pdata && pdata->modes[num].deselect_on_exit)
>  					? pca954x_deselect_mux : NULL);
> =20
> diff --git a/include/linux/i2c-mux.h b/include/linux/i2c-mux.h
> index 747f0cd..43fb11a 100644
> --- a/include/linux/i2c-mux.h
> +++ b/include/linux/i2c-mux.h
> @@ -33,8 +33,10 @@
>   * and deselect callback functions to perform hardware-specific
>   * mux control.
>   */
> -struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
> +struct i2c_adapter *i2c_add_mux_adapter(struct device *dev,
> +				struct i2c_adapter *parent,
>  				void *mux_dev, u32 force_nr, u32 chan_id,
> +				const char *chan_name,
>  				int (*select) (struct i2c_adapter *,
>  					       void *mux_dev, u32 chan_id),
>  				int (*deselect) (struct i2c_adapter *,
> --=20
> 1.7.0.4
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--s5/bjXLgkIwAv6Hi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+VObsACgkQD27XaX1/VRtwSQCglpSAAWKWcBAtcn+Tof/A900h
TjoAn255CABYfYWDHoMEdiZ3eMgSpYkz
=on/Y
-----END PGP SIGNATURE-----

--s5/bjXLgkIwAv6Hi--
