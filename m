Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab2I0HzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:55:19 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:53203 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550Ab2I0HzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:55:16 -0400
Date: Thu, 27 Sep 2012 10:50:18 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCHv3 6/7] dma: move dw_dmac driver to an own directory
Message-ID: <20120927075017.GL12592@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348731121-2515-7-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+svXpSx+RSEd8UhP"
Content-Disposition: inline
In-Reply-To: <1348731121-2515-7-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+svXpSx+RSEd8UhP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 27, 2012 at 10:32:00AM +0300, Andy Shevchenko wrote:
> The dw_dmac driver contains multiple files. To make a managment of them m=
ore

typo: 'management'

> convenient move it to an own directory.
>=20
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/Makefile                |    3 +--
>  drivers/dma/dw/Makefile             |    2 ++
>  drivers/dma/{ =3D> dw}/dw_dmac.c      |    2 +-
>  drivers/dma/{ =3D> dw}/dw_dmac_pci.c  |    0
>  drivers/dma/{ =3D> dw}/dw_dmac_regs.h |    0
>  5 files changed, 4 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/dma/dw/Makefile
>  rename drivers/dma/{ =3D> dw}/dw_dmac.c (99%)
>  rename drivers/dma/{ =3D> dw}/dw_dmac_pci.c (100%)
>  rename drivers/dma/{ =3D> dw}/dw_dmac_regs.h (100%)
>=20
> diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
> index 15eef5f..122a48a 100644
> --- a/drivers/dma/Makefile
> +++ b/drivers/dma/Makefile
> @@ -11,8 +11,7 @@ obj-$(CONFIG_INTEL_IOP_ADMA) +=3D iop-adma.o
>  obj-$(CONFIG_FSL_DMA) +=3D fsldma.o
>  obj-$(CONFIG_MPC512X_DMA) +=3D mpc512x_dma.o
>  obj-$(CONFIG_MV_XOR) +=3D mv_xor.o
> -obj-$(CONFIG_DW_DMAC) +=3D dw_dmac.o
> -obj-$(CONFIG_DW_DMAC_PCI) +=3D dw_dmac_pci.o
> +obj-$(CONFIG_DW_DMAC) +=3D dw/
>  obj-$(CONFIG_AT_HDMAC) +=3D at_hdmac.o
>  obj-$(CONFIG_MX3_IPU) +=3D ipu/
>  obj-$(CONFIG_TXX9_DMAC) +=3D txx9dmac.o
> diff --git a/drivers/dma/dw/Makefile b/drivers/dma/dw/Makefile
> new file mode 100644
> index 0000000..2edfb24
> --- /dev/null
> +++ b/drivers/dma/dw/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_DW_DMAC) +=3D dw_dmac.o
> +obj-$(CONFIG_DW_DMAC_PCI) +=3D dw_dmac_pci.o
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw/dw_dmac.c
> similarity index 99%
> rename from drivers/dma/dw_dmac.c
> rename to drivers/dma/dw/dw_dmac.c
> index 9f0129d..fa0471a 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw/dw_dmac.c
> @@ -24,8 +24,8 @@
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
> =20
> +#include "../dmaengine.h"
>  #include "dw_dmac_regs.h"
> -#include "dmaengine.h"
> =20
>  /*
>   * This supports the Synopsys "DesignWare AHB Central DMA Controller",
> diff --git a/drivers/dma/dw_dmac_pci.c b/drivers/dma/dw/dw_dmac_pci.c
> similarity index 100%
> rename from drivers/dma/dw_dmac_pci.c
> rename to drivers/dma/dw/dw_dmac_pci.c
> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw/dw_dmac_regs.h
> similarity index 100%
> rename from drivers/dma/dw_dmac_regs.h
> rename to drivers/dma/dw/dw_dmac_regs.h
> --=20
> 1.7.10.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--+svXpSx+RSEd8UhP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQZAU5AAoJEIaOsuA1yqREdokP/2Tv70zcCt5E2kScnXJXvPDh
MCaVFLrXGU+WYT2yiN7+WxJBHYiH5imoFg3M7s8u0ybMaEF8flWzf6U2QCcqPipO
Ytmf9E9SoVt0yO8bzjjCGZfU6sI0JyZzEsrfuEqp2b1PfLgM/cJlj4WoEGhLeMqe
mFaT/6XFRcOyAzbyNfzefrDZihOGo6E7JiJdCG0L8xz2uCRMiFnYtU2KF7ngVed5
nyyr1XRbRaK62j2jMi4WUzypdYdT4EvVk3yxvaVoYGFBRSDr5pv8fk+cNPlAXguQ
Yd25vsiudRbtn2Bhi+RpcjEhZuoX64tYsLs0JTxQNiyIvBzIwB1s8KMe/ndcgrAG
TKXIB+S8JjKZLzw9B3g7umApu3gLCcnk/w5laz2mn2rMJ3CkR6IjdmgDBVlXyQVZ
hZKaAE13wjPhjL4NizfxSZJjblHvHeM0p6OtcpDjduXaU2SiZJ/vuHlGamVDq1cX
fL4Rzh3ZU0EIinp5HhEUNcJZvX8SaxFDVP+/lrJoCqkmj7+XLYIMQKDg1hzn6Guw
LyxkFm8EeF+BHKGloQ0kPatfZb4yi32fdx2ycOBUHke6iCVruLC///cTIRVNx2tK
ocLXojCI4k5snktNy2hrQcENdbF+MyKnGAmJsZ28E7vKj8etGokzrGl274ZWXG89
PvA/r2jMfVbF8uLMJTbp
=gbXA
-----END PGP SIGNATURE-----

--+svXpSx+RSEd8UhP--
