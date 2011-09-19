Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab1ISJ5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:57:31 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:33856 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab1ISJ5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:57:30 -0400
From: Barry Song <Barry.Song@csr.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: "21cnbao@gmail.com" <21cnbao@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <Workgroup.Linux@csr.com>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
Thread-Topic: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
Thread-Index: AQHMdFbdVdy3M8u+O0iH2Esxb4MbWpVT5hwAgACLI2D//4CFgIAAiOvQ
Date: Mon, 19 Sep 2011 09:56:10 +0000
Message-ID: <5EB3BFCD089AD643B9BB63439F5FD5E9840F3B18@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1316166960-20964-1-git-send-email-Baohua.Song@csr.com>
	 <1316422774.26662.30.camel@vkoul-udesk3>
	 <5EB3BFCD089AD643B9BB63439F5FD5E9840F3A8D@SHAASIEXM01.ASIA.ROOT.PRI>
 <1316425277.26662.41.camel@vkoul-udesk3>
In-Reply-To: <1316425277.26662.41.camel@vkoul-udesk3>
Accept-Language: zh-CN, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.125.36.58]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8J9vcbh014195



> -----Original Message-----
> From: Vinod Koul [mailto:vinod.koul@intel.com]
> Sent: 2011å¹´9æœˆ19æ—¥ 17:41
> To: Barry Song
> Cc: 21cnbao@gmail.com; Arnd Bergmann; Jassi Brar; Linus Walleij;
> linux-kernel@vger.kernel.org; DL-SHA-WorkGroupLinux; Rongjun Ying;
> linux-arm-kernel@lists.infradead.org
> Subject: RE: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
> 
> On Mon, 2011-09-19 at 09:23 +0000, Barry Song wrote:
> > Hi Vinod,
> > Thanks!
> >
> > > -----Original Message-----
> > > From: Vinod Koul [mailto:vinod.koul@intel.com]
> > > Sent: 2011å¹´9æœˆ19æ—¥ 17:00
> > > To: Barry Song
> > > Cc: Arnd Bergmann; Jassi Brar; Linus Walleij; linux-kernel@vger.kernel.org;
> > > DL-SHA-WorkGroupLinux; Rongjun Ying;
> linux-arm-kernel@lists.infradead.org
> > > Subject: Re: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
> > >
> > > On Fri, 2011-09-16 at 02:56 -0700, Barry Song wrote:
> > > > From: Rongjun Ying <rongjun.ying@csr.com>
> > > >
> > > > Cc: Jassi Brar <jaswinder.singh@linaro.org>
> > > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > > Cc: Linus Walleij <linus.walleij@linaro.org>
> > > > Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
> > > > Signed-off-by: Barry Song <Baohua.Song@csr.com>
> > > > ---
> > > >  -v2:
> > > >  use generic xfer API from jassi;
> > > >  delete sirf self-defined slave config;
> > > >  fix feedback from vinod;
> > > >  fix filter function: we have two dmac, clients drivers think the chan id as
> > > 0~31;
> > > >  rename regs to base;
> > > >  delete redundant chan_id initialization in probe since dmaengine core
> will
> > > >  re-write it, refer to my patch too:
> > > >  [PATCH] dmaengine: delete redundant chan_id and chancnt initialization
> in
> > > dma drivers
> > > >  http://www.spinics.net/lists/kernel/msg1237455.html
> > > >
> > > >  this patch doesn't provide a common way for filter and doesn't use the
> > > jassi's v2 patch.
> > > > +
> > > > +static int sirfsoc_dma_slave_config(struct sirfsoc_dma_chan *schan,
> > > > +	struct dma_slave_config *config)
> > > > +{
> > > > +	u32 addr, direction;
> > > > +	unsigned long flags;
> > > > +
> > > > +	switch (config->direction) {
> > > > +	case DMA_FROM_DEVICE:
> > > > +		direction = 0;
> > > > +		addr = config->dst_addr;
> > > > +		break;
> > > > +
> > > > +	case DMA_TO_DEVICE:
> > > > +		direction = 1;
> > > > +		addr = config->src_addr;
> > > > +		break;
> > > > +
> > > > +	default:
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	if ((config->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES) ||
> > > > +		(config->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES))
> > > > +		return -EINVAL;
> > > > +
> > > > +	spin_lock_irqsave(&schan->lock, flags);
> > > > +	schan->addr = addr;
> > > > +	schan->direction = direction;
> > > > +	schan->mode = (config->src_maxburst == 4 ? 1 : 0);
> > > > +	spin_unlock_irqrestore(&schan->lock, flags);
> > > Not sure why you support this, there seem to be no DMA_SLAVE support in
> > > this version ate least
> >
> > Not. I support dma_slave. But I have no prep_slave_sg function since I can
> use the gen xfer to replace it.
> Yes thats okay...
> 
> Then I have questions on genxfer function...
> where are you copying either src or dstn_start address, you seem to
> completely ignore them?

Since I only support memory->device or device ->memory, and channel number is fixed to every device. Then I actually don't care device address at all. Either src or dst is fixed to the device's address.

> 
> Do you support only slave transfers or M2M as well for this driver?
> If only slave you might want to check if dma_config_slave is set for
> this channel or not.

I support only slave transfer. Actually I have dma_config_slave. do you mean I need to check whether slave config cmd is really called before executing dma?

> 
> --
> ~Vinod

-barry



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
