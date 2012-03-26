Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab2CZG4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 02:56:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33654 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab2CZG4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 02:56:07 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6660"; a="175694829"
Message-ID: <4F7012FC.10203@codeaurora.org>
Date: Mon, 26 Mar 2012 12:25:56 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: Ravi Kumar V <kumarrav@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>, linux-arm-msm@vger.kernel.or,
        linux-kernel@vger.kernel.org, Zhang Wei <zw@zh-kernel.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Barry Song <baohua.song@csr.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Dan Williams <dan.j.williams@intel.com>, Li Yang <leoli@freescale.com>,
        linuxppc-dev@lists.ozlabs.org, David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 1/2] dmaengine: Add context parameter to prep_dma_sg
 and prep_interleaved_dma
References: <1332426167-25213-1-git-send-email-kumarrav@codeaurora.org> <1332743073.19804.26.camel@vkoul-udesk3>
In-Reply-To: <1332743073.19804.26.camel@vkoul-udesk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/2012 11:54 AM, Vinod Koul wrote:
> On Thu, 2012-03-22 at 19:52 +0530, Ravi Kumar V wrote:
>> Add new context parameter to DMA SG and Interleaveid mode for passing
> Typo					  ^^^^^^^^^^^^

Sorry, we will fix this.

>> diff --git a/drivers/misc/carma/carma-fpga-program.c b/drivers/misc/carma/carma-fpga-program.c
>> index a2d25e4..3739a12 100644
>> --- a/drivers/misc/carma/carma-fpga-program.c
>> +++ b/drivers/misc/carma/carma-fpga-program.c
>> @@ -530,7 +530,7 @@ static noinline int fpga_program_dma(struct fpga_dev *priv)
>>   	}
>>
>>   	/* setup and submit the DMA transaction */
>> -	tx = chan->device->device_prep_dma_sg(chan,
>> +	tx = chan->device->dmaengine_prep_dma_sg(chan,
>>   					      table.sgl, num_pages,
>>   					      vb->sglist, vb->sglen, 0);
> No the idea is that clients will not know anything about additionlay
> parameter hence avoiding abuse. You need to reread the patches sent by
> Alexandre.
>
> You need to
> 1) add wrappers over interleaved api which dont expose this additional
> parameter
> 2) move existing users to use these wrappers

Above two steps would be exactly same as 
https://lkml.org/lkml/2012/3/8/401 - [PATCH 1/2 V2] dmaengine/dma_slave: 
introduce inline wrappers, right?

> 3) add a new API which has your additional argument (not an opaque
> object) and this calls .device_xx callback with additional arg.
> 4. Above can be under conditional of your specific subsystem where these
> parameters are valid.

Now, this would be different from what Alexandre had submitted, since he 
had added "void *context" parameter directly to existing callbacks 
dma_slave_sg and and cyclic under struct dma_device.

And you prefer that we add new callbacks under "struct dma_device" for 
our specific requirement with new name and with that extra non-opaque 
object. After that add wrappers for these two new callbacks say
dmaengine_prep_dma_sg_ext and dmagengine_prep_interleaved_dma_ext (same
name goes for callback).

---Trilok Soni

-- 
--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
