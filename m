Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935300Ab2JYLFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:05:33 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51516 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935185Ab2JYLFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:05:31 -0400
MIME-Version: 1.0
In-Reply-To: <1351052379.5263.20.camel@vkoul-udesk3>
References: <1349432276-22919-1-git-send-email-inderpal.singh@linaro.org>
	<1349432276-22919-5-git-send-email-inderpal.singh@linaro.org>
	<1351052379.5263.20.camel@vkoul-udesk3>
Date: Thu, 25 Oct 2012 16:35:31 +0530
Message-ID: <CAG17yqQA01P42n-72T4GTYVo0WSaPJPAKV+N0V0kmA17UPyusA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] DMA: PL330: unregister dma_device in module's
 remove function
From: Inderpal Singh <inderpal.singh@linaro.org>
To: Vinod Koul <vkoul@infradead.org>
Cc: vinod.koul@intel.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jassisinghbrar@gmail.com,
        boojin.kim@samsung.com, patches@linaro.org, kgene.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 October 2012 09:49, Vinod Koul <vkoul@infradead.org> wrote:
> On Fri, 2012-10-05 at 15:47 +0530, Inderpal Singh wrote:
>> unregister dma_device in module's remove function.
>>
>> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
>> ---
>>  drivers/dma/pl330.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
>> index 4b7a34d..e7dc040 100644
>> --- a/drivers/dma/pl330.c
>> +++ b/drivers/dma/pl330.c
>> @@ -3017,6 +3017,8 @@ static int __devexit pl330_remove(struct amba_device *adev)
>>                       return -EBUSY;
>>       }
>>
>> +     dma_async_device_unregister(&pdmac->ddma);
>> +
>>       amba_set_drvdata(adev, NULL);
>>
>>       list_for_each_entry_safe(pch, _p, &pdmac->ddma.channels,
>
> Ok with this one :)
>
> Tried applying but didn't work out. You would need to regenerate this
> one.
>

I will regenerate this along with other patches and resend.

With Regards,
Inder

> Thanks
> --
> Vinod Koul
> Intel Corp.
>
