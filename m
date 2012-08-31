Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2HaQbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:31:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33102 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab2HaQbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:31:37 -0400
Message-ID: <5040E6C7.6030106@ti.com>
Date: Fri, 31 Aug 2012 22:01:03 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Vinod Koul <vkoul@infradead.org>
CC: <vinod.koul@intel.com>, Matt Porter <mporter@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <grant.likely@secretlab.ca>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 3/3] spi: spi-davinci: convert to DMA engine API
References: <1345684176-21472-1-git-send-email-mporter@ti.com>  <1345684176-21472-4-git-send-email-mporter@ti.com>  <503F75C0.1050507@ti.com> <20120830144307.GA26737@beef>  <5040E00A.3080600@ti.com> <1346430709.15463.15.camel@vkoul-mobl4>
In-Reply-To: <1346430709.15463.15.camel@vkoul-mobl4>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/31/2012 10:01 PM, Vinod Koul wrote:
> On Fri, 2012-08-31 at 21:32 +0530, Sekhar Nori wrote:
>> Hi Matt,
>>
>> On 8/30/2012 8:13 PM, Matt Porter wrote:
>>> On Thu, Aug 30, 2012 at 07:46:32PM +0530, Sekhar Nori wrote:
>>>> Hi Matt,
>>>>
>>>> On 8/23/2012 6:39 AM, Matt Porter wrote:
>>>>> Removes use of the DaVinci EDMA private DMA API and replaces
>>>>> it with use of the DMA engine API.
>>>>>
>>>>> Signed-off-by: Matt Porter <mporter@ti.com>
>>>>
>>>> I tried testing this patch on my OMAP-L138 EVM, but SPI fails to 
>>>> initialize after applying the patch.
>>>>
>>>> root@arago:~# dmesg | grep -i spi                                               
>>>> spi_davinci spi_davinci.1: request RX DMA channel failed                        
>>>
>>> Hi Sekhar,
>>>
>>> Most likely CONFIG_TI_EDMA is off as it defaults to off in the v3
>>> series. Try enabling this and if it's the problem then this error
>>> path can be fixed to properly fallback to PIO only or fail to
>>> initialize as needed.
>>
>> Yes, this was the problem. Since the SPI driver now depends on
>> CONFIG_TI_EDMA for basic operation may be select CONFIG_TI_EDMA in
>> Kconfig if SPI is enabled? That should do until the fallback to PIO is
>> implemented.
> Then this should be enabled for SPI. Care to send a patch

By 'this' you mean the Kconfig select? Then there should be no need of a
new patch for this. It can be part of this patch itself, no?

Thanks,
Sekhar
