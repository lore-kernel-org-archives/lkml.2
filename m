Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab2JZG4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:56:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59032 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab2JZG4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:56:10 -0400
Date: Fri, 26 Oct 2012 09:50:12 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <arnd@arndb.de>, <olof@lixom.net>, <rdunlap@xenotime.net>,
        <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ARM: OMAP: ocp2scp: create omap device for ocp2scp
Message-ID: <20121026065012.GC22206@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1349675983-23803-1-git-send-email-kishon@ti.com>
 <1349675983-23803-4-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Content-Disposition: inline
In-Reply-To: <1349675983-23803-4-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 08, 2012 at 11:29:43AM +0530, Kishon Vijay Abraham I wrote:
> Platfrom device for ocp2scp is created using omap_device_build in
> devices file. This is used for both omap4(musb) and omap5(dwc3).
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/mach-omap2/devices.c |   76 +++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 76 insertions(+)
>=20
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index c8c2117..ac2bfce 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -19,6 +19,7 @@
>  #include <linux/of.h>
>  #include <linux/pinctrl/machine.h>
>  #include <linux/platform_data/omap4-keypad.h>
> +#include <linux/platform_data/omap_ocp2scp.h>
> =20
>  #include <asm/mach-types.h>
>  #include <asm/mach/map.h>
> @@ -613,6 +614,80 @@ static void omap_init_vout(void)
>  static inline void omap_init_vout(void) {}
>  #endif
> =20
> +#if defined(CONFIG_OMAP_OCP2SCP) || defined(CONFIG_OMAP_OCP2SCP_MODULE)
> +static int count_ocp2scp_devices(struct omap_ocp2scp_dev *ocp2scp_dev)
> +{
> +	int cnt	=3D 0;
> +
> +	while (ocp2scp_dev->drv_name !=3D NULL) {
> +		cnt++;
> +		ocp2scp_dev++;
> +	}
> +
> +	return cnt;
> +}
> +
> +static void omap_init_ocp2scp(void)
> +{
> +	struct omap_hwmod	*oh;
> +	struct platform_device	*pdev;
> +	int			bus_id =3D -1, dev_cnt =3D 0, i;
> +	struct omap_ocp2scp_dev	*ocp2scp_dev;
> +	const char		*oh_name, *name;
> +	struct omap_ocp2scp_platform_data *pdata;
> +
> +	oh_name =3D "ocp2scp_usb_phy";
> +	name	=3D "omap-ocp2scp";

how about adding checks here to return early case we're not running on
OMAP4 or OMAP5 ??

--=20
balbi

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQijKkAAoJEIaOsuA1yqRE8cwQAKPGIKHMzRgKcRlqGvCNFY5S
AUjcTO+R5LUyk7kCYdM+WLgwyH0GZHQkiPdbGsGwb+dc2etW81GIztSTX1FKEkc1
iGr4DWwhJ3VpvdZcdX0ER6zBQg8Vy8JEKpvZ3HfIRq2OzBYxVRm93ngH7DAAejYz
kKKPrMfggCJfYo/yNko76BcNB6pAOOwRZF/N4gimrKwywqlAiduIiOMcgiCwBkWK
AFnDcoqBHfk/EkFCOt/ButaqjhzHyi0xqth64nkW67vSbdKyiksGXuco4AJ7EoyU
u5wVheD2QyavP3mcdpNm97By85cuQclgyp7TmsVGzF91U46yW1VRWIeZwymYwK3c
PXgzFRjYEhvvBZuEFIDcWLqsCKt7ZgvCgj5XDKEjx2gBa8XFRCvOPzUMCnx1q1qq
fo58Hcv/EzQSuhI/4KMRztWQ2PiRBxc3w8oCMyDVo86Dm6MLTAPlUhh32+PYVTBm
NMiocRMzybGU0L3UcbbjAiMl1uXyy6udkAgq73V17+s6SktscOsaOkjcqv6IFQ1E
Z/6HH5wVHqAi7WAHL3hBBzMVZmSe47J/dpUdC15jGzvdgD0OWiG7Lz4bsFdifLZF
Bkl5zIOu2Kyaan5EkpqLIeSrBy5eonrPuBo+nIdgHOkq3GwDw063xan3euYqbq1R
dq+SSkn9JMzDEE1KAVc1
=U99x
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
