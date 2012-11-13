Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab2KMSpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:45:14 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9847 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab2KMSpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:45:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 13 Nov 2012 10:44:59 -0800
Message-ID: <50A29489.5090606@nvidia.com>
Date: Wed, 14 Nov 2012 00:12:17 +0530
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
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] spi: tegra: add spi driver for sflash controller
References: <1352782854-25351-1-git-send-email-ldewangan@nvidia.com> <50A28299.6080809@wwwdotorg.org>
In-Reply-To: <50A28299.6080809@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2012 10:55 PM, Stephen Warren wrote:
> On 11/12/2012 10:00 PM, Laxman Dewangan wrote:
>
>> +static int tegra_sflash_resume(struct device *dev)
>> +{
>> +	struct spi_master *master = dev_get_drvdata(dev);
>> +	struct tegra_sflash_data *tsd = spi_master_get_devdata(master);
>> +	int ret;
>> +
>> +	ret = pm_runtime_get_sync(dev);
>> +	if (ret<  0) {
>> +		dev_err(dev, "pm runtime failed, e = %d\n", ret);
>> +		return ret;
>> +	}
>> +	tegra_sflash_writel(tsd, tsd->command_reg, SPI_COMMAND);
>> +	pm_runtime_put(dev);
> Can we avoid this whole function simply by programming SPI_COMMAND at
> the start of each transaction? That seems simpler. I assume that
> shouldn't e.g. leave any chip-selects in some bad state, or at least if
> it does, that shouldn't be a problem, because before the driver probes()
> at kernel boot, SPI_COMMAND won't have been programmed either.
>
> Aside from that,

I am not sure about the side effect of moving this to transfer but I can 
suspect:
When client driver is active, it need the proper state of CS. If we move 
this to transfer then probbaly CS is not in proper state until client 
calls the transfer function and this is not correct. The CS should be 
inactive state for all devices in non-transfer states.

> Acked-by: Stephen Warren<swarren@nvidia.com>
> Tested-by: Stephen Warren<swarren@nvidia.com>

Thanks for testing. I will respin patch V2 for taking care of above 
comments.
