Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1KPUeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 15:34:31 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:48615 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953Ab1KPUe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 15:34:29 -0500
Date: Wed, 16 Nov 2011 22:34:24 +0200
From: Felipe Balbi <balbi@ti.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Kevin Cernekee <cernekee@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH] ahci: platform support for suspend/resume
Message-ID: <20111116203422.GA29581@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1321475279-29930-1-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <1321475279-29930-1-git-send-email-computersforpeace@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 16, 2011 at 12:27:59PM -0800, Brian Norris wrote:
> Add platform hooks for custom suspend() and resume() functions. The
> generic suspend/resume code in drivers/ata/ahci_platform.c is adapted
> from the PCI version in drivers/ata/ahci.c.
>=20
> Note that in order to suspend, we require that both suspend() and
> resume() functions be supplied.
>=20
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> ---
> Based on:
>     git://github.com/jgarzik/libata-dev.git ALL
>=20
>  drivers/ata/ahci_platform.c   |   72 +++++++++++++++++++++++++++++++++++=
++++++
>  include/linux/ahci_platform.h |    2 +
>  2 files changed, 74 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index ec55595..98bf5e9 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -202,6 +202,75 @@ static int __devexit ahci_remove(struct platform_dev=
ice *pdev)
>  	return 0;
>  }
> =20
> +#ifdef CONFIG_PM
> +static int ahci_suspend(struct device *dev)
> +{
> +	struct ahci_platform_data *pdata =3D dev_get_platdata(dev);
> +	struct ata_host *host =3D dev_get_drvdata(dev);
> +	struct ahci_host_priv *hpriv =3D host->private_data;
> +	void __iomem *mmio =3D hpriv->mmio;
> +	u32 ctl;
> +	int rc;
> +
> +	/* Does platform support suspend/resume? */
> +	if (!pdata->suspend || !pdata->resume)
> +		return -EINVAL;

should you really prevent suspend is platform doesn't provide
->suspend() ?

I mean, we could some platform where all clocks are autogated and
there's no need for platform to do anything. Would it be better to only
call pdata->suspend if it exists but still let the AHCI-specific part go
through ?

--=20
balbi

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOxB5OAAoJEIaOsuA1yqREJFcP/0FA7HAzplQZet1EPeBipT6d
NghtI9OjnIjWw6viyaS4f7xPAsvkgtluO+oZivrrRW4g3kbaUBQOabxXEY149fs1
U3ezR1j4vqSOI3e8Vt2mhGtO/vW3zoPLVDgLpkgc/kdLis4rXyD1IDCrmy4+seLL
WkS1e5yT7p34KZWP8J106Bj9OUCSeCTwR2IaqTwwMSeRmGF9NAz7NmU1G8WmBS3n
lzyiGgraoD3LAikEVYijl/U4wX5dRKKPUcoEeFrQFP3GLESZJyR2eWN/OH561BCy
wz03NTTPHUl5TL5UYcVI9jEsC9h2cOOqKF0HzFTfTTJkJFvfx3C3xZgImG4koSxU
Rh7GAIEsQNG/pGsr1FB+l2JqCJf2+VbRqM1fWKwgqBxVyjDCqxEzIjOKejn30yv8
HbRw87+JNqotnwIK8HN8xDmx/ZXPOn1Y1A+kDDUPuIAjjh5ZkSN/AtgeOkqwpvJg
kn/tSIuLMVRBGbq4EWKnOShDZikHWQ2JHSa8K7GyvnIG+1IwiSr7y8IMOpe9bItt
cHyhmtrDlhQiAiqP0QSwJxebZwraWqIcVLwjii8JoPfndXEn1TvX3wdM5GpiNjTo
0eyi3qFGyy6jDPxI4DZ/Sp//6gcDCfiiadUM0MgCOm+BzzXlYgqVNJi7hZjSykGJ
CNezvrYpRmwf7/Knww1q
=wRro
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
