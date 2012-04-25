Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab2DYJCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 05:02:54 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16256 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab2DYJCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 05:02:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 25 Apr 2012 02:02:51 -0700
Message-ID: <4F97BD67.1050300@nvidia.com>
Date: Wed, 25 Apr 2012 14:31:27 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Vinod Koul <vinod.koul@linux.intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] dmaengine: tegra: add dma driver
References: <1334912896-4614-1-git-send-email-ldewangan@nvidia.com> <1334920487.31825.98.camel@vkoul-udesk3> <4F9153AF.7020901@nvidia.com> <1335170491.31825.104.camel@vkoul-udesk3> <4F95483F.5020005@nvidia.com> <20120423130659.GA22186@n2100.arm.linux.org.uk> <4F95567E.3090605@nvidia.com>
In-Reply-To: <4F95567E.3090605@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Monday 23 April 2012 06:47 PM, Laxman Dewangan wrote:
> On Monday 23 April 2012 06:36 PM, Russell King - ARM Linux wrote:
>> On Mon, Apr 23, 2012 at 05:47:03PM +0530, Laxman Dewangan wrote:
>>> Hi Russell,
>>> On Monday 23 April 2012 02:11 PM, Vinod Koul wrote:
>>>> On Fri, 2012-04-20 at 17:46 +0530, Laxman Dewangan wrote:
>>>>> Thanks Vinod for quick review.
>>>> Since I was on vacation, I hadn't noticed Russell has already sent the
>>>> patches for omap dma support.
>>>> http://permalink.gmane.org/gmane.linux.ports.arm.omap/75034
>>>>
>>>> It would be nice if both the efforts are coordinated.
>>>>
>>>> Btw I like the virtual channel support introduced by Russell
>>>>
>>> Can you please point me the virtual channel related change? I am not
>>> able to locate this like search for function vchan_* ().
>>> My driver is also on same line but not used vchan_* and also having
>>> support for cyclic transfer.
>> It's only been posted in RFC form on linux-arm-kernel and linux-omap
>> lists.  The specific patch is:
>>
>> http://lists.arm.linux.org.uk/lurker/message/20120418.101116.082b350f.en.html
>>
>> I wouldn't call it perfected yet, but usable.  It doesn't have any
>> knowledge about cyclic transfers either.
> For simple dma, it is straight to use the virt_chan and it reduce lots
> of code from tegra_dma as most of it moved to the virt_dma.
>
> Some points which I am looking are:
> 1. Extending this for cyclic support:
> In cyclic mode, we need to call callback after period_len but do not
> want to free descriptors. So either I need to add flag on the desctiptor
> to no delet and so when vc->desc_free(vd); is called from callback, it
> will not delete the descriptor.
>
> 2. With very prep call, we are allocating descriptor. Is it is possible
> to allocate some desc in advance and then keep using them. The
> complexity is that if we allocate the desc in advance, we need to
> allocate the desc and sq_req list and maintain the two different lists
> as we dont know the sg_len in advance.
>
> 3. vchan_cookie_complete()  is not possible in the cyclic mode as we
> dont want to call dma_cookie_complete() but just want to do following
> two thing:
>
> list_add_tail(&vd->node,&vc->desc_completed);
> tasklet_schedule(&vc->task);
>
> if we extend this function to bypass dma_cookie_complete(&vd->tx); or
> rather than calling this api, directly call the above apis.
>


I had a  communication with Russell on another change thread and 
understand that some more work need to be done in virt_chan to support 
cyclic one.

I want to have the cyclic dma support in my driver so I want to go on 
following steps:
1. I will post the patch for tegra dma which will not use the virt_dma 
so that my driver will be independent of Russel's change.
2. Once the tegra dma is part of tree, I can move all my dma client to 
use the dmaengine based driver and remove old style dma.
3. Till that time Russell's will have already virt_dma support for 
cyclic one and so I will change tegra_dma.c to use virt_dma.


Let me know your opinion so that I can plan my patch/change accordingly.

Thanks,
Laxman

