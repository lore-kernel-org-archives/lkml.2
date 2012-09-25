Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab2IYUQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 16:16:42 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47728 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab2IYUQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 16:16:41 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6846"; a="238755496"
Message-ID: <50621128.5040805@codeaurora.org>
Date: Tue, 25 Sep 2012 13:16:40 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/10] msm: iommu: Convert to clk_prepare/unprepare
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org> <1348194419-11486-4-git-send-email-sboyd@codeaurora.org> <5060DF7D.9000305@codeaurora.org>
In-Reply-To: <5060DF7D.9000305@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/12 15:32, Saravana Kannan wrote:
>> @@ -275,8 +275,11 @@ static int msm_iommu_remove(struct
>> platform_device *pdev)
>>
>>       drv = platform_get_drvdata(pdev);
>>       if (drv) {
>> -        if (drv->clk)
>> +        if (drv->clk) {
>> +            clk_unprepare(drv->clk);
>>               clk_put(drv->clk);
>> +        }
>> +        clk_unprepare(drv->pclk);
>
>
> Are these changes right? Every other clk API change in this patch is
> using the combined prepare_enable/disable_unprepare() calls. So, when
> would we end up at this location with the clocks prepared but not
> enabled?
>
> Also, what if the device gets probed and then immediately removed.
> Will it work correctly?
>

It should work correctly. If you look at the bottom of msm_iommu_probe()
you see that it call clk_disable() and doesn't unprepare the clock. So
if the driver is unbound the clocks should be disabled but still prepared.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

