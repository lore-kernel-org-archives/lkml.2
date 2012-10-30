Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2J3F6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 01:58:09 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2344 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab2J3F6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 01:58:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 29 Oct 2012 22:57:58 -0700
Message-ID: <508F6C09.4070104@nvidia.com>
Date: Tue, 30 Oct 2012 11:26:25 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2] spi: tegra: add spi driver for SLINK controller
References: <1351531104-1604-1-git-send-email-ldewangan@nvidia.com> <508ED5A5.3000703@wwwdotorg.org>
In-Reply-To: <508ED5A5.3000703@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2012 12:44 AM, Stephen Warren wrote:
> On 10/29/2012 11:18 AM, Laxman Dewangan wrote:
>> Tegra20/Tegra30 supports the spi interface through its SLINK
>> controller. Add spi driver for SLINK controller.
>> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
>> +config SPI_TEGRA20_SLINK
>> +	tristate "Nvidia Tegra20/Tegra30 SLINK Controller"
>> +	depends on ARCH_TEGRA&&  TEGRA20_APB_DMA
> I think it depends on DMAENGINE, not the specific driver now, doesn't it?

I saw in MFD where the dependent driver depends on the actual drver, not 
on core. Also this driver need apb dma and hence if there is other dma 
driver based on dmaengine, not apb dma then this driver should not get 
invoked.

>> +			tegra_slink_writel(tspi, x, SLINK_TX_FIFO);
>> +		}
>> +	}
> The if and the else there are basically identical now. Can't the else
> branch simply be replaced by the if branch? At most I think the
> difference comes down to max_n_32bit v.s. fifo_words_left calculations
> being slight different; everything else is the same.
>
> I suppose this isn't a big deal though; we could clean it up later if
> necessary.
>

I like to do later.


>> +		tegra_slink_writel(tspi, val, SLINK_DMA_CTL);
>> +		udelay(1);
>> +		wmb();
> Why the udelay() and wmb()?

Udelay() is required as suggested by ASIC.
wmb() is lying in our downstream code and hence it is here but I think 
it is not require now.

>> +	return tegra_slink_clk_prepare(tspi);
>> +}
> Why not move the body of tegra_slink_clk_{un,prepare} inside those
> functions, since they're only called from those functions?
>

Fine, I will do.

>> +MODULE_ALIAS("platform:tegra_slink-slink");
> I think that's a typo.
I will fix this typo.

Thanks,
Laxman

