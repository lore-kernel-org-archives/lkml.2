Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab2HaQYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:24:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:48013 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab2HaQYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:24:46 -0400
Message-ID: <1346430709.15463.15.camel@vkoul-mobl4>
Subject: Re: [PATCH v3 3/3] spi: spi-davinci: convert to DMA engine API
From: Vinod Koul <vkoul@infradead.org>
To: Sekhar Nori <nsekhar@ti.com>
Cc: vinod.koul@intel.com, Matt Porter <mporter@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        grant.likely@secretlab.ca,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        cjb@laptop.org,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Date: Fri, 31 Aug 2012 22:01:49 +0530
In-Reply-To: <5040E00A.3080600@ti.com>
References: <1345684176-21472-1-git-send-email-mporter@ti.com>
	 <1345684176-21472-4-git-send-email-mporter@ti.com>
	 <503F75C0.1050507@ti.com> <20120830144307.GA26737@beef>
	 <5040E00A.3080600@ti.com>
Organization: 
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-31 at 21:32 +0530, Sekhar Nori wrote:
> Hi Matt,
> 
> On 8/30/2012 8:13 PM, Matt Porter wrote:
> > On Thu, Aug 30, 2012 at 07:46:32PM +0530, Sekhar Nori wrote:
> >> Hi Matt,
> >>
> >> On 8/23/2012 6:39 AM, Matt Porter wrote:
> >>> Removes use of the DaVinci EDMA private DMA API and replaces
> >>> it with use of the DMA engine API.
> >>>
> >>> Signed-off-by: Matt Porter <mporter@ti.com>
> >>
> >> I tried testing this patch on my OMAP-L138 EVM, but SPI fails to 
> >> initialize after applying the patch.
> >>
> >> root@arago:~# dmesg | grep -i spi                                               
> >> spi_davinci spi_davinci.1: request RX DMA channel failed                        
> > 
> > Hi Sekhar,
> > 
> > Most likely CONFIG_TI_EDMA is off as it defaults to off in the v3
> > series. Try enabling this and if it's the problem then this error
> > path can be fixed to properly fallback to PIO only or fail to
> > initialize as needed.
> 
> Yes, this was the problem. Since the SPI driver now depends on
> CONFIG_TI_EDMA for basic operation may be select CONFIG_TI_EDMA in
> Kconfig if SPI is enabled? That should do until the fallback to PIO is
> implemented.
Then this should be enabled for SPI. Care to send a patch
> 
> With that fixed, I tested SPI on OMAP-L138 EVM and it works great.
> Tested a JFFS2 mount as well as some raw chardev read/write tests.
> 
> Tested-by: Sekhar Nori <nsekhar@ti.com>
> 
> Thanks,
> Sekhar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
~Vinod Koul
Intel Corp.

