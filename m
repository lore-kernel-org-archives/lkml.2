Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab2ATMeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 07:34:06 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33969 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2ATMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 07:34:04 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6594"; a="156595966"
Message-ID: <4F195F36.60901@codeaurora.org>
Date: Fri, 20 Jan 2012 18:03:58 +0530
From: Ravi Kumar V <kumarrav@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: dan.j.williams@intel.com, arnd@arndb.de, linux-arch@vger.kernel.org,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux@arm.linux.org.uk, tsoni@qualcomm.com, johlstei@qualcomm.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/2] dmaengine: Add support for per xfer specific privatedata
 & box dma
References: <1325854052-21402-1-git-send-email-kumarrav@codeaurora.org>  <1325854052-21402-2-git-send-email-kumarrav@codeaurora.org> <1326808388.1540.123.camel@vkoul-udesk3>
In-Reply-To: <1326808388.1540.123.camel@vkoul-udesk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/2012 7:23 PM, Vinod Koul wrote:
> On Fri, 2012-01-06 at 18:17 +0530, Ravi Kumar V wrote:
>>
>> diff --git a/include/asm-generic/scatterlist.h b/include/asm-generic/scatterlist.h
>> index 5de0735..e66dfcb 100644
>> --- a/include/asm-generic/scatterlist.h
>> +++ b/include/asm-generic/scatterlist.h
>> @@ -14,6 +14,7 @@ struct scatterlist {
>>   #ifdef CONFIG_NEED_SG_DMA_LENGTH
>>   	unsigned int	dma_length;
>>   #endif
>> +	unsigned long	private_data;
> what do you plan to pass here. Please keep in mind this is a generic
> scatterlist structure, and modifying it for your purposes doesn't seem
> to be a great one!
> Also why can't you pass this as addition argument in your new "BOX API"?
We are using DMA-Engine framework for both SG mode and BOX mode of our HW.
For SG mode we are using device_prep_dma_sg API but the problem we are 
facing is we need to pass command configuration parameter along with 
each descriptor to our HW, we did not find any suitable API/structure in 
framework to support this.
So thought of adding new element in struct scatterlist.
please can you suggest a way to pass private parameter with
every descriptor.
>
>>   };
>>
>>   /*
>> +
>> +struct dma_box_list {
>> +	dma_addr_t dma_row_address;
>> +	unsigned int dma_row_len;
>> +	unsigned int dma_row_num;
>> +	unsigned int dma_row_offset;
>> +	unsigned long private_data;
>> +};
> again a private data here?
> is this some kind of interleaved pattern?
Yes this interleaved pattern.
>> +
>>   /**
>>    * struct dma_device - info on the entity supplying DMA services
>>    * @chancnt: how many DMA channels are supported
>> @@ -497,6 +507,11 @@ struct dma_device {
>>   	struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
>>   		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
>>   		size_t period_len, enum dma_data_direction direction);
>> +	struct dma_async_tx_descriptor *(*device_prep_dma_box)(
>> +		struct dma_chan *chan, struct dma_box_list *dst_box,
>> +		struct dma_box_list *src_box, unsigned int num_list,
>> +		unsigned long flags);
> still not clean what kind of transfer do you want to do here
We are doing interleaved pattern of data transfer between source and 
destination boxs, num_list is number of box mode commands
Please can you refer patch 0/2 I have replied explaining about box mode 
transfer clearly.
>> +
>>   	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>>   		unsigned long arg);
>>
>
>


-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
