Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab2CNJSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 05:18:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30138 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760081Ab2CNJSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 05:18:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6648"; a="169995181"
Message-ID: <4F606270.1020709@codeaurora.org>
Date: Wed, 14 Mar 2012 14:48:40 +0530
From: Ravi Kumar V <kumarrav@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v3 1/2] dmaengine: Add support for per xfer specific privatedata
References: <1331548336-27802-1-git-send-email-kumarrav@codeaurora.org> <1331569796.1727.9.camel@vkoul-udesk3>
In-Reply-To: <1331569796.1727.9.camel@vkoul-udesk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/2012 9:59 PM, Vinod Koul wrote:
> On Mon, 2012-03-12 at 16:02 +0530, Ravi Kumar V wrote:
>> Add new argument to DMA SG and Interleave mode for passing
>> per transfer specific private data, using this it enables the
>> dma devices which needs to pass the parameters which changes per
>> each transfer.
>>
>> Signed-off-by: Ravi Kumar V<kumarrav@codeaurora.org>
>> ---
>>   include/linux/dmaengine.h |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
>> index 679b349..b8f0495 100644
>> --- a/include/linux/dmaengine.h
>> +++ b/include/linux/dmaengine.h
>> @@ -570,7 +570,7 @@ struct dma_device {
>>   		struct dma_chan *chan,
>>   		struct scatterlist *dst_sg, unsigned int dst_nents,
>>   		struct scatterlist *src_sg, unsigned int src_nents,
>> -		unsigned long flags);
>> +		unsigned long flags, void *context);
> Please follow the related discussion we had. Alexandre had already
> posted updated and this needs to follow.
> Also this way you break the existing drivers which use this API, not
> sure why you posted without fixing them?
>
I have gone through the discussion in
https://lkml.org/lkml/2012/2/6/300
As per my understanding
1.we need to add new transaction types DMA_SG_EXT & DMA_INTERLEAVE_EXT.
2.Add context parameter to existing API's.
3.Typecast the context parameter with architecture specific structure 
there by restricting client drivers to pass only arch specific parameter.
4.Fix existing code and client drivers for using new API.

My suggestion is instead of adding context parameter in existing API's, 
how it would be if we can add a new API for each DMA transaction types 
available in dmaengine for passing transaction specific parameter?
so that existing clients and dma drivers will not be disturbed.

>>   	struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
>>   		struct dma_chan *chan, struct scatterlist *sgl,
>> @@ -581,7 +581,7 @@ struct dma_device {
>>   		size_t period_len, enum dma_transfer_direction direction);
>>   	struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
>>   		struct dma_chan *chan, struct dma_interleaved_template *xt,
>> -		unsigned long flags);
>> +		unsigned long flags, void *context);
>>   	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>>   		unsigned long arg);
>>
>
>


-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
