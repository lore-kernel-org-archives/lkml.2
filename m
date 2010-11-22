Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab0KVXyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 18:54:24 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22848 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab0KVXyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 18:54:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6175"; a="63935302"
Message-ID: <4CEB02AE.4060509@codeaurora.org>
Date: Mon, 22 Nov 2010 15:54:22 -0800
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] msm: iommu: Clock control for the IOMMU driver
References: <1290222154-11096-1-git-send-email-stepanm@codeaurora.org>	 <1290222154-11096-3-git-send-email-stepanm@codeaurora.org> <1290468761.4258.26.camel@m0nster>
In-Reply-To: <1290468761.4258.26.camel@m0nster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2010 3:32 PM, Daniel Walker wrote:
> On Fri, 2010-11-19 at 19:02 -0800, Stepan Moskovchenko wrote:
>> +	int ret;
>> +
>> +	ret = clk_enable(drvdata->pclk);
> You don't need to check if pclk is null ?
>
Nope. If we are here, the pclk will always be non-null, which is 
something that may not necessarily be said for for AXI clock.

>>   		iommu_drvdata = dev_get_drvdata(ctx_drvdata->pdev->dev.parent);
>> +		if (!iommu_drvdata)
>> +			BUG();
> Just do,
>
> BUG_ON(!iommu_drvdata);
Will fix in v2.

>> -	__flush_iotlb(domain);
>> +	ret = __flush_iotlb(domain);
> What the relationship between this __flush_iotlb() and turning the
> clocks on/off.
>
The flush_iotlb function needs to handle clock control as well, which 
means it can now fail. As a result, we now need to check its return 
value, instead of assuming it succeeded.
>> -	pr_err("===== WOAH! =====\n");
> Cleanup right? It doesn't need it's own patch, but you could mention in
> the description that you've done "minor cleanups" or something to that
> effect.
>
Will fix in v2.

