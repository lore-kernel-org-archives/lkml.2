Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab2HXLao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 07:30:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:59565 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab2HXLak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 07:30:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,304,1344236400"; 
   d="asc'?scan'208";a="184921170"
Message-ID: <1345808104.2848.285.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] drivers/mtd/devices/spear_smi.c: use devm_ functions
 consistently
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <Julia.Lawall@lip6.fr>, Stefan Roese <sr@denx.de>,
        Shiraz Hashim <shiraz.hashim@st.com>
Cc: David Woodhouse <dwmw2@infradead.org>, kernel-janitors@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 24 Aug 2012 14:35:04 +0300
In-Reply-To: <1344112598-1051-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1344112598-1051-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Clpew83sEk/hjVAkQmpY"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Clpew83sEk/hjVAkQmpY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[See here for the original patch:
 http://lists.infradead.org/pipermail/linux-mtd/2012-August/043112.html]

Julia, sorry for long delay,

aiaiai gives says that this patch introduced 3 warnings:

---------------------------------------------------------------------------=
-----

Successfully built configuration "arm-spear6xx_defconfig,arm,arm-unknown-li=
nux-gnueabi-", results:

--- before_patching.log
+++ after_patching.log
@@ @@
-drivers/mtd/devices/spear_smi.c: In function 'spear_smi_remove':
-drivers/mtd/devices/spear_smi.c:1022:30: warning: variable 'pdata' set but=
 not used [-Wunused-but-set-variable]
+drivers/mtd/devices/spear_smi.c: In function 'spear_smi_remove':
+drivers/mtd/devices/spear_smi.c:1026:9: warning: variable 'irq' set but no=
t used [-Wunused-but-set-variable]
+drivers/mtd/devices/spear_smi.c:1022:30: warning: variable 'pdata' set but=
 not used [-Wunused-but-set-variable]
+drivers/mtd/devices/spear_smi.c:1024:19: warning: variable 'smi_base' set =
but not used [-Wunused-but-set-variable]

---------------------------------------------------------------------------=
-----


On Sat, 2012-08-04 at 22:36 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Use devm_kzalloc for all calls to kzalloc and not just the first.  Use de=
vm
> functions for other allocations as well.
>=20
> Move the call to platform_get_resource(pdev, IORESOURCE_MEM, 0) closer to
> where its result is passed to devm_request_and_ioremap to make the lack o=
f
> need for a NULL test more evident.
>=20
> The semantic match that finds the inconsistency is as follows:
> (http://coccinelle.lip6.fr/)

...

> @@ -1073,21 +1043,13 @@ static int __devexit spear_smi_remove(struct plat=
form_device *pdev)
>  		ret =3D mtd_device_unregister(&flash->mtd);
>  		if (ret)
>  			dev_err(&pdev->dev, "error removing mtd\n");
> -
> -		iounmap(flash->base_addr);
> -		kfree(flash);
>  	}
> =20
>  	irq =3D platform_get_irq(pdev, 0);
> -	free_irq(irq, dev);

I guess 'platform_get_irq()' should be killed as well? Stefan, this is
strange code - we get irq, without checking for error, and then free it?
What is the rationale?

>  	clk_disable_unprepare(dev->clk);
> -	clk_put(dev->clk);
> -	iounmap(dev->io_base);
> -	kfree(dev);
> =20
>  	smi_base =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(smi_base->start, resource_size(smi_base));
>  	platform_set_drvdata(pdev, NULL);

Why do we set platform data to NULL, is this needed?


--=20
Best Regards,
Artem Bityutskiy

--=-Clpew83sEk/hjVAkQmpY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQN2boAAoJECmIfjd9wqK0lMcQAIqFtZ4Z/O7w3FW3mRE6zddO
yYfIdL+F5687ZHQvr7DHOO3CzrRl4z8tZ+n8CRN9Dnf/xB6zewe/wXDxdNz7yKGL
62xoS4+gPSadkry8BNmDv3II2k+5F56Lc4ouU5MGJlPLdhHVq/trQIPTtV9NWxDQ
jDOU91GgR2KscyswQeDKP2ScuTgtO3LIPCk7njDKOZqM2YX2qbpb2Sg0IRXAR++z
V4IkaUHaEMx5jpo90S8kNwHL9zgf1Dz4tPhCt+UiI4K/TFqs9UYpkF9w2LG17wcu
Wsov+YlIrcmY9zYVUGfgcPAm4aVvjKof9b/nlWcQHlhp8qqMwV12lqRSX4lmfJw2
bbKLpg2HroYYEQAooOuDvbdxR/d2ETi+ZXVJTXMrwI/ObfGeFadNJVYi1fywTlYI
Jk3JPak4+P4KBGngI4F7kHryNjZwqhdyna6pl7wKm/952YU6SX1ylyP3y97J/Srt
VI+/GJ3GjnC2Qw2Zhl6e5KEcpbSbb1thxsB1JzYx3h+L4um6CzGkhieTFNUyhXJE
Axm0fFhVli/kg1HR8DfN5dfjGFLo/VGyBxF79zf2cAEbS79/janVhB8r/lC22EFQ
WoB2EC4CV2Ec0CTUnA3HFY1sBt1TML+Pnf8tMWfYIP95EtCHy6Ey8Z3BJA9QN1O+
ZUgrAz2/bOl+saKrfPta
=L1km
-----END PGP SIGNATURE-----

--=-Clpew83sEk/hjVAkQmpY--

