Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab2JQNPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:15:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35309 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756853Ab2JQNOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:14:52 -0400
Date: Wed, 17 Oct 2012 16:09:18 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>, spear-devel <spear-devel@list.st.com>,
        <balbi@ti.com>
Subject: Re: [PATCHv2 3/4] dw_dmac: change {dev_}printk() to corresponding
 macros
Message-ID: <20121017130918.GD11394@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350469879-16018-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1350469879-16018-4-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Gf/FFewwPeBMqCJ"
Content-Disposition: inline
In-Reply-To: <1350469879-16018-4-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3Gf/FFewwPeBMqCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 17, 2012 at 01:31:17PM +0300, Andy Shevchenko wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |   15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index c27c125..60b172a 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -456,9 +456,8 @@ static void dwc_scan_descriptors(struct dw_dma *dw, s=
truct dw_dma_chan *dwc)
> =20
>  static inline void dwc_dump_lli(struct dw_dma_chan *dwc, struct dw_lli *=
lli)
>  {
> -	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
> -			"  desc: s0x%x d0x%x l0x%x c0x%x:%x\n",
> -			lli->sar, lli->dar, lli->llp, lli->ctlhi, lli->ctllo);
> +	dev_crit(chan2dev(&dwc->chan), "  desc: s0x%x d0x%x l0x%x c0x%x:%x\n",
> +		 lli->sar, lli->dar, lli->llp, lli->ctlhi, lli->ctllo);

is this really critical ? To me it looks more like a debugging message.

>  }
> =20
>  static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
> @@ -492,10 +491,8 @@ static void dwc_handle_error(struct dw_dma *dw, stru=
ct dw_dma_chan *dwc)
>  	 * controller flagged an error instead of scribbling over
>  	 * random memory locations.
>  	 */
> -	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
> -			"Bad descriptor submitted for DMA!\n");
> -	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
> -			"  cookie: %d\n", bad_desc->txd.cookie);
> +	dev_crit(chan2dev(&dwc->chan), "Bad descriptor submitted for DMA!\n");
> +	dev_crit(chan2dev(&dwc->chan), "  cookie: %d\n", bad_desc->txd.cookie);

now this is critical, indeed. I would suggest using dev_WARN_ONCE() so
that it's noisy enough to catch the failing user.

>  	dwc_dump_lli(dwc, &bad_desc->lli);
>  	list_for_each_entry(child, &bad_desc->tx_list, desc_node)
>  		dwc_dump_lli(dwc, &child->lli);
> @@ -1625,8 +1622,8 @@ static int __devinit dw_probe(struct platform_devic=
e *pdev)
> =20
>  	dma_writel(dw, CFG, DW_CFG_DMA_EN);
> =20
> -	printk(KERN_INFO "%s: DesignWare DMA Controller, %d channels\n",
> -			dev_name(&pdev->dev), nr_channels);
> +	pr_info("%s: DesignWare DMA Controller, %d channels\n",
> +		dev_name(&pdev->dev), nr_channels);

you have a struct device available in platform_device, please use
dev_info() or dev_dbg().

>  	dma_async_device_register(&dw->dma);
> =20
> --=20
> 1.7.10.4
>=20

--=20
balbi

--3Gf/FFewwPeBMqCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQfq3+AAoJEIaOsuA1yqREqMUP/0H1QctAUGtBXWe8/7EXS49A
BG+Dzp49r0UQaueucAQxsJ+iho+uWDCFxwLAYfcnMIawTXjOayfQf3SqOK0jx6GN
wh45axFmbTOLXpI+k9Kj3VEBfwApyKlmbJ8eNsFdH/EiS7TAgAUzQRfJUR+N8Lu8
Jqpd/EZhai4ad1pg4knJoF2GeDDVAnxTcTO9VuDt1SCMRaTSKteqrOO7VBU+H/W2
RtqVylh2YGwwr9Gw8ieHdWiiE2Z6PkSHDAEfn9n6tpeHXDkGVeOfPWuADIJq3ZNT
qcKpo11146b+Wcad3TXgwlRsNnEp+UBPEXfDbx/3FX4pbzJlvQRQWLNXBJZK3g5e
0VKy6hZJBAcWxZWa68tK6nDYHqw0DgevTl+0/8mpG6hmdppUMi7QzcYkQD/DZmEf
6wPKmMa0YOzoht5vLGNb4agw91yqRcOAU6adDplCEZo/chuoNrWJ6gDHd9jv4UrL
cF+XV4bq5A8cKNgpSLQChKu1OQuE2wo1hThmQl/uLBrD+fHkCxVMsm17AuiqvAC2
kyE9Mqd28GhsSJ8Upr9McQfRog8WRK0DVgrqveWui0iTwwTnRQK0LIpqyl1jvtqm
7yNqN+cL7ve/jQtiG4MuLjPnoQqFE3sBnhXTTq+/Rq4MV+lEoCcbCFe97a1mYEu7
zUVbqhysxpAchv9rF4Gf
=lW9H
-----END PGP SIGNATURE-----

--3Gf/FFewwPeBMqCJ--
