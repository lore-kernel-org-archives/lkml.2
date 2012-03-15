Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762025Ab2COStc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:49:32 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54571 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761283Ab2COSt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:49:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6650"; a="172833194"
Message-ID: <4F6239B0.6040507@codeaurora.org>
Date: Fri, 16 Mar 2012 00:19:20 +0530
From: Ravi Kumar V <kumarrav@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bryan Huntsman <bryanh@codeaurora.org>,
        gregkh@linuxfoundation.org, Daniel Walker <dwalker@fifo99.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/2] dmaengine: Add support for per xfer specific privatedata
References: <1331548336-27802-1-git-send-email-kumarrav@codeaurora.org> <1331569796.1727.9.camel@vkoul-udesk3> <4F606270.1020709@codeaurora.org>
In-Reply-To: <4F606270.1020709@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/2012 2:48 PM, Ravi Kumar V wrote:
> On 3/12/2012 9:59 PM, Vinod Koul wrote:
>> On Mon, 2012-03-12 at 16:02 +0530, Ravi Kumar V wrote:
>>> Add new argument to DMA SG and Interleave mode for passing
>>> per transfer specific private data, using this it enables the
>>> dma devices which needs to pass the parameters which changes per
>>> each transfer.
>>>
>>> Signed-off-by: Ravi Kumar V<kumarrav@codeaurora.org>
>>> ---
>>> include/linux/dmaengine.h | 4 ++--
>>> 1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
>>> index 679b349..b8f0495 100644
>>> --- a/include/linux/dmaengine.h
>>> +++ b/include/linux/dmaengine.h
>>> @@ -570,7 +570,7 @@ struct dma_device {
>>> struct dma_chan *chan,
>>> struct scatterlist *dst_sg, unsigned int dst_nents,
>>> struct scatterlist *src_sg, unsigned int src_nents,
>>> - unsigned long flags);
>>> + unsigned long flags, void *context);
>> Please follow the related discussion we had. Alexandre had already
>> posted updated and this needs to follow.
>> Also this way you break the existing drivers which use this API, not
>> sure why you posted without fixing them?
>>
I have gone through the discussion in
https://lkml.org/lkml/2012/2/6/300
As per my understanding
1.we need to add new transaction types DMA_SG_EXT & DMA_INTERLEAVE_EXT.
2.Add context parameter to existing API's.
3.Typecast the context parameter with architecture specific structure
there by restricting client drivers to pass only arch specific parameter.
4.Add inline functions as suggested by Russell
and then
5.Fix existing code and client drivers for using new API.

Hi Vinod,

I am ready to follow above steps and also suggested by Russell and 
submit new patch.
Please can you confirm me so that i will start work.

My suggestion is instead of adding context parameter in existing API's,
how it would be if we can add a new API for each DMA transaction types
available in dmaengine for passing transaction specific parameter?
so that existing clients and dma drivers will not be disturbed.

Thanks
Ravi Kumar
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
