Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab1ITDqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 23:46:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:64122 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab1ITDqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 23:46:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,408,1312182000"; 
   d="scan'208";a="50701729"
Subject: Re: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vinod.koul@intel.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <Barry.Song@csr.com>, Arnd Bergmann <arnd@arndb.de>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <Workgroup.Linux@csr.com>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <CAGsJ_4y0F7JTwFwesVvbgq1Lupw+a_-EpiTwW9GtXxOauohdVQ@mail.gmail.com>
References: <1316166960-20964-1-git-send-email-Baohua.Song@csr.com>
	 <1316422774.26662.30.camel@vkoul-udesk3>
	 <5EB3BFCD089AD643B9BB63439F5FD5E9840F3A8D@SHAASIEXM01.ASIA.ROOT.PRI>
	 <1316425277.26662.41.camel@vkoul-udesk3>
	 <5EB3BFCD089AD643B9BB63439F5FD5E9840F3B18@SHAASIEXM01.ASIA.ROOT.PRI>
	 <1316430878.26662.46.camel@vkoul-udesk3>
	 <CAGsJ_4y0F7JTwFwesVvbgq1Lupw+a_-EpiTwW9GtXxOauohdVQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 09:12:01 +0530
Message-ID: <1316490121.31295.2.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 19:25 +0800, Barry Song wrote:
> 2011/9/19 Vinod Koul <vinod.koul@intel.com>:
> > On Mon, 2011-09-19 at 09:56 +0000, Barry Song wrote:
> >> > > > Not sure why you support this, there seem to be no DMA_SLAVE
> >> support in
> >> > > > this version ate least
> >> > >
> >> > > Not. I support dma_slave. But I have no prep_slave_sg function
> >> since I can
> >> > use the gen xfer to replace it.
> >> > Yes thats okay...
> >> >
> >> > Then I have questions on genxfer function...
> >> > where are you copying either src or dstn_start address, you seem to
> >> > completely ignore them?
> >>
> >> Since I only support memory->device or device ->memory, and channel
> >> number is fixed to every device. Then I actually don't care device
> >> address at all. Either src or dst is fixed to the device's address.
> > peripheral address can be fixed, not the memory, where do you copy the
> > memory address?
> 
> +static int sirfsoc_dma_slave_config(struct sirfsoc_dma_chan *schan,
> +       struct dma_slave_config *config)
> +{
> +       u32 addr, direction;
> +       unsigned long flags;
> +
> +       switch (config->direction) {
> +       case DMA_FROM_DEVICE:
> +               direction = 0;
> +               addr = config->dst_addr;
> +               break;
> +
> +       case DMA_TO_DEVICE:
> +               direction = 1;
> +               addr = config->src_addr;
> +               break;
> +
> +       default:
> +               return -EINVAL;
> +       }
> +  ...
This is wrong. You are treating addresses passed in dma_slave_config as
memory address. These should be treating this as peripheral address
(destination in DMA_TO_DEVICE....) and take the memory address from your
prepare function.

-- 
~Vinod

