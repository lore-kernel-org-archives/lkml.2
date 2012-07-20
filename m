Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab2GTGNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 02:13:25 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17064 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2GTGNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 02:13:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 19 Jul 2012 23:13:19 -0700
Message-ID: <5008F4D8.9070108@nvidia.com>
Date: Fri, 20 Jul 2012 11:34:08 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] dma: tegra: enable/disable dma clock
References: <1342601769-13852-1-git-send-email-ldewangan@nvidia.com> <1342764141.1726.199.camel@vkoul-udesk3>
In-Reply-To: <1342764141.1726.199.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2012 11:32 AM, Vinod Koul wrote:
> On Wed, 2012-07-18 at 14:26 +0530, Laxman Dewangan wrote:
>> Enable the DMA clock when registering DMA driver and
>> disable clock when removing the DMA driver.
>>
>> The failure was observed on Tegra20 based system by
>> Stephen Warren. However, it is working fine on tegra30
>> based system and probably becasue uboot enable the clock
>> on Tegra30.
> Don't know much about the clock subsystem, but shouldn't the clocks be
> enabled runtime..... when you actually start using the controller??

Yes, this is the plan and I am going to implement dynamic clock 
management but it will take some time to complete and have testing 
throughly. some of the issue which I am seeing and analyzing on this 
approach is that
  - clock disable can be called from isr context or not?
  - how much complexity will be added in dma driver to implement this?
  - What power benefit we will get on this.
  - Is there any user which generally use dma and always keep dma on 
requested state like UART RX always ready etc.

So keeping that in mind, it will take some time to complete this and 
meanwhile, I want to make it work for Tegra20 based system which is not 
working on current driver.
and hence this is the change.

Thanks,
Laxman

