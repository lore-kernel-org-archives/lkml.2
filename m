Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab2IFNZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:25:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49609 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2IFNZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:25:30 -0400
Message-ID: <5048A441.3010109@gmail.com>
Date: Thu, 06 Sep 2012 15:25:21 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: vinod.koul@intel.com, cjb@laptop.org, grant.likely@secretlab.ca,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH v3 0/3] DaVinci DMA engine conversion
References: <1345684176-21472-1-git-send-email-mporter@ti.com> <503B933F.2030803@gmail.com>
In-Reply-To: <503B933F.2030803@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On 27.08.2012 17:33, Daniel Mack wrote:
> On 23.08.2012 03:09, Matt Porter wrote:
>> This series begins the conversion of the DaVinci private EDMA API
>> implementation to a DMA engine driver and converts two of the three
>> in-kernel users of the private EDMA API to DMA engine.
>>
>> The approach taken is similar to the recent OMAP DMA Engine
>> conversion. The EDMA DMA Engine driver is a wrapper around the existing
>> private EDMA implementation and registers the platform device within
>> the driver.  This allows the conversion series to stand alone with just
>> the drivers and no changes to platform code. It also allows peripheral
>> drivers to continue to use the private EDMA implementation until they
>> are converted.
>>
>> The EDMA DMA Engine driver supports slave transfers only at this time. It
>> is planned to add cyclic transfers in support of audio peripherals.
>>
>> There are three users of the private EDMA API in the kernel now:
>> davinci_mmc, spi-davinci, and davinci-mcasp.  This series provides DMA
>> Engine conversions for the davinci_mmc and spi-davinci drivers which
>> use the supported slave transfers.
>>
>> This series has been tested on an AM18x EVM and Hawkboard with
>> driver performance comparable to that of the private EDMA API
>> implementations. Both MMC0 and MMC1 are tested which handles the
>> DA850/OMAP-L138/AM18x specific case where MMC1 uses DMA channels on
>> a second EDMA channel controller.  All other platforms have a simpler
>> design with just a single EDMA channel controller.
>>
>> For those wanting to easily test this series, I've pushed a branch for
>> each version to my github tree at https://github.com/ohporter/linux. The
>> current branch is edma-dmaengine-v3.
>>
>> After this series, the current plan is to complete the mcasp driver
>> conversion which includes adding cyclic dma support. This will then
>> enable the removal and refactoring of the private EDMA API functionality
>> into the EDMA DMA Engine driver.  Since EDMA is also used on the AM33xx
>> family of parts in mach-omap2/, the plan is to enable this driver on
>> that platform as well.
> 
> Once you have a patch for the McASP driver conversion, I can happily
> test this on a AM33xx board, together with Gururaja's latest McASP
> refactoring series. Let me know how I can help you here.

Did you find some time yet to continue on this side? I don't want to
appear pushy, but as I need to finish some DT transition on a
AM33xx-based board, I would much like to help out here, in case I can do
anything to help speed things along.


Many thanks for your work!

Daniel
