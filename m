Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab2H3ORG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 10:17:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44641 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab2H3ORF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 10:17:05 -0400
Message-ID: <503F75C0.1050507@ti.com>
Date: Thu, 30 Aug 2012 19:46:32 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: <vinod.koul@intel.com>, <cjb@laptop.org>, <grant.likely@secretlab.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH v3 3/3] spi: spi-davinci: convert to DMA engine API
References: <1345684176-21472-1-git-send-email-mporter@ti.com> <1345684176-21472-4-git-send-email-mporter@ti.com>
In-Reply-To: <1345684176-21472-4-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On 8/23/2012 6:39 AM, Matt Porter wrote:
> Removes use of the DaVinci EDMA private DMA API and replaces
> it with use of the DMA engine API.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>

I tried testing this patch on my OMAP-L138 EVM, but SPI fails to 
initialize after applying the patch.

root@arago:~# dmesg | grep -i spi                                               
spi_davinci spi_davinci.1: request RX DMA channel failed                        

without these 3 patches, SPI flash is detected fine (same kernel 
configuration):

root@arago:~# dmesg | grep spi                                                  
spi_davinci spi_davinci.1: DMA: supported                                       
spi_davinci spi_davinci.1: DMA: RX channel: 18, TX channel: 19, event queue: 0  
spi_davinci spi_davinci.1: master is unqueued, this is deprecated               
m25p80 spi1.0: m25p64 (8192 Kbytes)                                             
spi_davinci spi_davinci.1: Controller at 0xfef0e000                             

Any idea what could be wrong? This is v3.6-rc3 kernel. I can provide 
full bootlogs or any other debug information if that helps.

Thanks,
Sekhar
