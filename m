Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1G0Q0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:26:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:53036 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab1G0Q0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:26:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,277,1309762800"; 
   d="scan'208";a="32926401"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Date: Wed, 27 Jul 2011 21:55:44 +0530
Subject: RE: linux-next: manual merge of the slave-dma tree with Linus' tree
Thread-Topic: linux-next: manual merge of the slave-dma tree with Linus' tree
Thread-Index: AcxMedXalqaISmyyRlmSgL2oQtkrcA==
Message-ID: <438BB0150E931F4B9CE701519A4463010871EAC8BD@bgsmsx502.gar.corp.intel.com>
References: <20110727120826.ea1227276707790e162dee18@canb.auug.org.au>
 <1311736331.1536.45.camel@vkoul-udesk3>
In-Reply-To: <1311736331.1536.45.camel@vkoul-udesk3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6RGQKr7007810

> 
> On Wed, 2011-07-27 at 12:08 +1000, Stephen Rothwell wrote:
> > Hi Vinod,
> >
> > Today's linux-next merge of the slave-dma tree got a conflict in
> > drivers/spi/spi-pl022.c (called drivers/spi/amba-pl022.c in the sleav-dma
> > tree) between commit 083be3f05371 ("spi/pl022: initialize burstsize from
> > FIFO trigger level") from Linus' tree and commit 001b0585ff16 ("Improve
> > slave/cyclic DMA engine documentation") from the slave-dma tree.
> >
> > I fixed it up (see below) anc acn carry the fix as necessary.
> 
> The correct fix would be:
> 
> diff --cc drivers/spi/spi-pl022.c
> index eba88c7,99e7880..0000000
> --- a/drivers/spi/spi-pl022.c
> +++ b/drivers/spi/spi-pl022.c
> @@@ -910,11 -908,11 +910,9 @@@ static int configure_dma(struct pl022 *
>   {
>         struct dma_slave_config rx_conf = {
>                 .src_addr = SSP_DR(pl022->phybase),
> +			.direction = DMA_TO_DEVICE,
>         };
>         struct dma_slave_config tx_conf = {
>                 .dst_addr = SSP_DR(pl022->phybase),
>                 .direction = DMA_TO_DEVICE,
>  -              .dst_maxburst = pl022->vendor->fifodepth >> 1,
>         };
>         unsigned int pages;
>         int ret;
> 
Grant, Russell,
Can you please ack this fix before I apply in my tree to resolve this conflict

~Vinod


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
