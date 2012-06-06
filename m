Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab2FFSAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:00:20 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9779 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab2FFSAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:00:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 06 Jun 2012 11:00:18 -0700
Message-ID: <4FCF98DB.5050000@nvidia.com>
Date: Wed, 6 Jun 2012 23:22:27 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V5 2/2] dma: tegra: add dmaengine based dma driver
References: <1338960327-31453-1-git-send-email-ldewangan@nvidia.com> <1338960327-31453-2-git-send-email-ldewangan@nvidia.com> <4FCF97A5.5040008@wwwdotorg.org>
In-Reply-To: <4FCF97A5.5040008@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 June 2012 11:17 PM, Stephen Warren wrote:
> On 06/05/2012 11:25 PM, Laxman Dewangan wrote:
>> Add dmaengine based NVIDIA's Tegra APB DMA driver.
>> This driver support the slave mode of data transfer from
>> peripheral to memory and vice versa.
>> The driver supports for the cyclic and non-cyclic mode
>> of data transfer.
> Acked-by: Stephen Warren<swarren@wwwdotorg.org>
>
> Laxman, what are you plans for enabling this and replacing the existing
> non-dmaengine APB DMA driver? We will need to convert:
>
> * The fuse WAR stuff in arch/arm/mach-tegra
> * The ASoC driver in sound/soc/tegra
>
> This will require some thought and dependency management between the
> various subsystems.
Currently following drive using the non-dmanegine apb dma driver:
fuse
SPI
ASoc.

I want to first have this dma driver in the tree and then I will have 
the series of patches to use this dmaengine dma driver and delete the 
old apb dma driver.

So just waiting for this driver to be in.


> Vinod,
>
> It may be best to apply this series along in a topic branch that you
> merge into the dmaengine branch, and I can pull into Tegra if/when I
> need. Or, if you ack it, I can take it all through the Tegra tree if you
> want. That wouldn't allow patch 1 to be use by others though.
>

I like this series to be taken by Vinod. And then pull the change in to 
Tegra tree for further dependency change.
Reason is:
- If there is any dmaengine driver change/enhancement, then tegra dma 
driver will also be inline.
- Taking on tegra tree help to implement the clock framework which is 
going on.
- Also fuse related changes will be in tegra tree.
- Asoc and SPI can be also taken in the tegra tree or may be their 
corresponding tree based on how much other changes are there,
-Deletion of old driver is in Tegra tree.

> Thanks.

