Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab2HaQCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:02:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35961 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab2HaQCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:02:45 -0400
Message-ID: <5040E00A.3080600@ti.com>
Date: Fri, 31 Aug 2012 21:32:18 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        <vinod.koul@intel.com>, Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <grant.likely@secretlab.ca>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 3/3] spi: spi-davinci: convert to DMA engine API
References: <1345684176-21472-1-git-send-email-mporter@ti.com> <1345684176-21472-4-git-send-email-mporter@ti.com> <503F75C0.1050507@ti.com> <20120830144307.GA26737@beef>
In-Reply-To: <20120830144307.GA26737@beef>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On 8/30/2012 8:13 PM, Matt Porter wrote:
> On Thu, Aug 30, 2012 at 07:46:32PM +0530, Sekhar Nori wrote:
>> Hi Matt,
>>
>> On 8/23/2012 6:39 AM, Matt Porter wrote:
>>> Removes use of the DaVinci EDMA private DMA API and replaces
>>> it with use of the DMA engine API.
>>>
>>> Signed-off-by: Matt Porter <mporter@ti.com>
>>
>> I tried testing this patch on my OMAP-L138 EVM, but SPI fails to 
>> initialize after applying the patch.
>>
>> root@arago:~# dmesg | grep -i spi                                               
>> spi_davinci spi_davinci.1: request RX DMA channel failed                        
> 
> Hi Sekhar,
> 
> Most likely CONFIG_TI_EDMA is off as it defaults to off in the v3
> series. Try enabling this and if it's the problem then this error
> path can be fixed to properly fallback to PIO only or fail to
> initialize as needed.

Yes, this was the problem. Since the SPI driver now depends on
CONFIG_TI_EDMA for basic operation may be select CONFIG_TI_EDMA in
Kconfig if SPI is enabled? That should do until the fallback to PIO is
implemented.

With that fixed, I tested SPI on OMAP-L138 EVM and it works great.
Tested a JFFS2 mount as well as some raw chardev read/write tests.

Tested-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
