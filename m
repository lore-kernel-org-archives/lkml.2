Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2BFLvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 06:51:25 -0500
Received: from mga03.intel.com ([143.182.124.21]:46191 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab2BFLvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 06:51:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="63711976"
Message-ID: <4F2FBEBB.20309@intel.com>
Date: Mon, 06 Feb 2012 13:51:23 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] dmaengine: intel_mid_dma: fix error status mask
References: <1328006940-9101-1-git-send-email-adrian.hunter@intel.com>  <1328006940-9101-2-git-send-email-adrian.hunter@intel.com> <1328528392.26182.81.camel@vkoul-udesk3>
In-Reply-To: <1328528392.26182.81.camel@vkoul-udesk3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/12 13:39, Vinod Koul wrote:
> On Tue, 2012-01-31 at 12:48 +0200, Adrian Hunter wrote:
>> The error status mask (MASK_ERR) has the same format as the other
>> masks (MASK_TFR, MASK_BLOCK etc) and must be cleared the same way.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  drivers/dma/intel_mid_dma.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
>> index 74f70aa..512e2ab 100644
>> --- a/drivers/dma/intel_mid_dma.c
>> +++ b/drivers/dma/intel_mid_dma.c
>> @@ -1056,7 +1056,8 @@ static irqreturn_t intel_mid_dma_interrupt(int irq, void *data)
>>  	}
>>  	err_status &= mid->intr_mask;
>>  	if (err_status) {
>> -		iowrite32(MASK_INTR_REG(err_status), mid->dma_base + MASK_ERR);
>> +		iowrite32((err_status << INT_MASK_WE),
>> +			  mid->dma_base + MASK_ERR);
> why not use the macro?

The parameter to the macro MASK_INTR_REG is the channel number.
err_status is not a channel number.

This is the same as the way it is done for MASK_TFR a few lines up.

>>  		call_tasklet = 1;
>>  	}
>>  	if (call_tasklet)
> 
> 

