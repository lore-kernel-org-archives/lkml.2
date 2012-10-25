Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343Ab2JYK7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:59:14 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43004 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765Ab2JYK7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:59:12 -0400
MIME-Version: 1.0
In-Reply-To: <1351051550.5263.15.camel@vkoul-udesk3>
References: <1349432276-22919-1-git-send-email-inderpal.singh@linaro.org>
	<1349432276-22919-2-git-send-email-inderpal.singh@linaro.org>
	<1351051550.5263.15.camel@vkoul-udesk3>
Date: Thu, 25 Oct 2012 16:29:10 +0530
Message-ID: <CAG17yqQ83TQZaoS7wC7vDeSenR5sLz7vzLu2rsnTXFMDHVsWbQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] DMA: PL330: Free memory allocated for peripheral channels
From: Inderpal Singh <inderpal.singh@linaro.org>
To: Vinod Koul <vkoul@infradead.org>
Cc: vinod.koul@intel.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jassisinghbrar@gmail.com,
        boojin.kim@samsung.com, patches@linaro.org, kgene.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

Thanks for reviewing.

On 24 October 2012 09:35, Vinod Koul <vkoul@infradead.org> wrote:
> On Fri, 2012-10-05 at 15:47 +0530, Inderpal Singh wrote:
>> The allocated memory for peripheral channels is not being freed upon
>> failure in probe and in module's remove funtion. It will lead to memory
>> leakage. Hence free the allocated memory.
>>
>> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
>> ---
>>  drivers/dma/pl330.c |    5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
>> index 2ebd4cd..10c6b6a 100644
>> --- a/drivers/dma/pl330.c
>> +++ b/drivers/dma/pl330.c
>> @@ -2962,7 +2962,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>>       ret = dma_async_device_register(pd);
>>       if (ret) {
>>               dev_err(&adev->dev, "unable to register DMAC\n");
>> -             goto probe_err4;
>> +             goto probe_err5;
>>       }
>>
>>       dev_info(&adev->dev,
>> @@ -2975,6 +2975,8 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>>
>>       return 0;
>>
>> +probe_err5:
>> +     kfree(pdmac->peripherals);
>>  probe_err4:
>>       pl330_del(pi);
>>  probe_err3:
>> @@ -3025,6 +3027,7 @@ static int __devexit pl330_remove(struct amba_device *adev)
>>       res = &adev->res;
>>       release_mem_region(res->start, resource_size(res));
>>
>> +     kfree(pdmac->peripherals);
>>       kfree(pdmac);
>>
>>       return 0;
>
> This looks fine, but if you use devm_ functions then you dont need to do
> all this.
> Can you do that conversion instead?
>

Good point.
I will do the conversion and send it again.

Regards,
Inder

> --
> Vinod Koul
> Intel Corp.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
