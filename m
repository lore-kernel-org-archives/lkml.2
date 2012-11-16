Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab2KPPcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:32:14 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:63514 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2KPPcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:32:12 -0500
MIME-Version: 1.0
In-Reply-To: <20121116135651.GB18920@arwen.pp.htv.fi>
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1353074360-1903-6-git-send-email-andriy.shevchenko@linux.intel.com>
	<20121116135651.GB18920@arwen.pp.htv.fi>
Date: Fri, 16 Nov 2012 17:32:10 +0200
Message-ID: <CAHp75VeUhZfSUZi5NC4d-W8OchFmRjbSf0qw+t8-Li9gB_1LSQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] dma: ipu_idmac: reuse is_slave_xfer helper
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: balbi@ti.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        spear-devel <spear-devel@list.st.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 3:56 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Fri, Nov 16, 2012 at 03:59:18PM +0200, Andy Shevchenko wrote:
>
> -ENOCOMMITLOG ??

I don't see much sense to add anything here, but I will do for the patch v2.

>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> ---
>>  drivers/dma/ipu/ipu_idmac.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
>> index 6585537..c8d0254 100644
>> --- a/drivers/dma/ipu/ipu_idmac.c
>> +++ b/drivers/dma/ipu/ipu_idmac.c
>> @@ -1347,7 +1347,7 @@ static struct dma_async_tx_descriptor *idmac_prep_slave_sg(struct dma_chan *chan
>>           chan->chan_id != IDMAC_IC_7)
>>               return NULL;
>>
>> -     if (direction != DMA_DEV_TO_MEM && direction != DMA_MEM_TO_DEV) {
>> +     if (!is_slave_xfer(direction)) {
>>               dev_err(chan->device->dev, "Invalid DMA direction %d!\n", direction);
>>               return NULL;
>>       }
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> balbi



-- 
With Best Regards,
Andy Shevchenko
