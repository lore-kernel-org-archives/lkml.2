Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab1BYWKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 17:10:00 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15461 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab1BYWJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 17:09:59 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6268"; a="76772390"
Message-ID: <4D6828B5.6050608@codeaurora.org>
Date: Fri, 25 Feb 2011 14:09:57 -0800
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Trilok Soni <tsoni@codeaurora.org>
CC: davidb@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] msm: iommu: Rework clock logic and add IOMMU bus
 clock control
References: <1298599242-21971-1-git-send-email-stepanm@codeaurora.org> <1298599242-21971-2-git-send-email-stepanm@codeaurora.org> <4D675A42.9090803@codeaurora.org>
In-Reply-To: <4D675A42.9090803@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/24/2011 11:29 PM, Trilok Soni wrote:
> Hi Steve,

Hello

>> @@ -130,117 +131,134 @@ static int msm_iommu_probe(struct platform_device *pdev)
>>   {
>>   	struct resource *r, *r2;
>>   	struct clk *iommu_clk;
>> +	struct clk *iommu_pclk;
>>   	struct msm_iommu_drvdata *drvdata;
>>   	struct msm_iommu_dev *iommu_dev = pdev->dev.platform_data;
> const please.
>

I am not clear on what you mean. Please be more specific here.

>> +	iommu_pclk = clk_get(NULL, "smmu_pclk");
>> +	if (IS_ERR(iommu_pclk)) {
>> +		ret = -ENODEV;
>> +		goto fail;
>> +	}
> I am not a big fan of this when you have the "device" around. You should just do
>
> iommu_pclk = clk_get(&pdev->dev, NULL);
>
> ...error logic...
>
> iommu_clk = clk_get(&pdev->dev, "iommu_clk");
>
> ...error logic...
>

The pclk is a "special" bus clock and does not have a specific device 
instance associated with it, so passing a device would not be 
appropriate in this case. I pass the device for other clocks that are 
indeed associated with devices, but this is not one of them. I suppose 
we could create 11 or 12 aliases for the pclk and associate it with all 
the IOMMU devices, but I would prefer to avoid doing that as I believe 
the current approach is cleaner.

>> -			ret = -EBUSY;
>> -			goto fail;
>> -		}
>> +	len = r->end - r->start + 1;
>
> resource_size please.
>

Ok


