Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab2GXFKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 01:10:41 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1853 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab2GXFKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 01:10:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 23 Jul 2012 22:06:14 -0700
Message-ID: <500E2BE0.7060602@nvidia.com>
Date: Tue, 24 Jul 2012 10:30:16 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] dma: tegra: enable/disable dma clock
References: <1342771268-5252-1-git-send-email-ldewangan@nvidia.com> <1343106498.1726.5974.camel@vkoul-udesk3>
In-Reply-To: <1343106498.1726.5974.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2012 10:38 AM, Vinod Koul wrote:
> On Fri, 2012-07-20 at 13:31 +0530, Laxman Dewangan wrote:
>> Enable the DMA clock when allocating channel and
>> disable clock when freeing channels.
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
>> ---
>> +	clk_disable_unprepare(tdma->dma_clk);
> What if another channel is active, disabling clock can cause bad
> behavior. You should check here if all channels are idle and then
> disable, or is this handled by clock API?

Yes, clock driver keeps the reference count and so client driver need 
not to take care.

Thanks,
Laxman


