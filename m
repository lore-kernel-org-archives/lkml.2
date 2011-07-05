Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab1GEN5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:57:54 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:57622 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292Ab1GEN5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:57:52 -0400
Date: Tue, 5 Jul 2011 16:57:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v2 2/5] input: twl6040-vibra: Do not use wrapper for irq
 request
Message-ID: <20110705135745.GN2820@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309873775-17927-1-git-send-email-peter.ujfalusi@ti.com>
 <1309873775-17927-3-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i1d8offQF8oqidLm"
Content-Disposition: inline
In-Reply-To: <1309873775-17927-3-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i1d8offQF8oqidLm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 05, 2011 at 04:49:32PM +0300, Peter Ujfalusi wrote:
> The twl6040_request_irq/free_irq inline functions are going
> to be removed, so replace them with direct calls.
> The irq number is provided by the core driver via resource.
>=20
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/input/misc/twl6040-vibra.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6=
040-vibra.c
> index dbf745d..50e09b0 100644
> --- a/drivers/input/misc/twl6040-vibra.c
> +++ b/drivers/input/misc/twl6040-vibra.c
> @@ -47,6 +47,7 @@ struct vibra_info {
>  	struct workqueue_struct *workqueue;
>  	struct work_struct play_work;
>  	struct mutex mutex;
> +	int irq;
> =20
>  	bool enabled;
>  	int weak_speed;
> @@ -277,6 +278,13 @@ static int __devinit twl6040_vibra_probe(struct plat=
form_device *pdev)
>  		goto err_kzalloc;
>  	}
> =20
> +	info->irq =3D platform_get_irq(pdev, 0);
> +	if (!info->irq) {

this is wrong. platform_get_irq() will return -ENXIO if it can't find
the IRQ you requested:

  55 /**
  56  * platform_get_irq - get an IRQ for a device
  57  * @dev: platform device
  58  * @num: IRQ number index
  59  */
  60 int platform_get_irq(struct platform_device *dev, unsigned int num)
  61 {
  62         struct resource *r =3D platform_get_resource(dev, IORESOURCE_I=
RQ, num);
  63=20
  64         return r ? r->start : -ENXIO;
  65 }
  66 EXPORT_SYMBOL_GPL(platform_get_irq);

--=20
balbi

--i1d8offQF8oqidLm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOExhYAAoJEAv8Txj19kN1G+kH/1qI6/OHKhJ5djo5usGbTobl
mOiwPBV/dAC+P47EZgNT4reVURaGPGIZJGWhAA/Yfoi714KJ8AniC26pSvudx4JH
98gbxNbOeb4kDrcGWhKBCpRupPMcw80CB6/lCweIBzXNKur/ed3L2118j2xW87yM
HQQppbQ2gmQZ6EFk/fT1F0+fL3fiIuSZIB1eu1hXMsTl2zoVkzZ7fJAJAgkqoR48
w18b46Xlfu20u2+Hwlv4Ik79x9nFTvrbKCaA1i/OfpkzI5oCSkLTu+AKgOe1HT/V
yTHXNSMgFnN/EOWOlh+NoHcYZRLJQZoiw4ljlmzFmPQg4sSuafKEik+kkEJF2bA=
=RIKz
-----END PGP SIGNATURE-----

--i1d8offQF8oqidLm--
