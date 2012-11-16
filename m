Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab2KPP0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:26:10 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46078 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab2KPP0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:26:08 -0500
MIME-Version: 1.0
In-Reply-To: <20121116142104.GT17774@intel.com>
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1353074360-1903-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<20121116142104.GT17774@intel.com>
Date: Fri, 16 Nov 2012 17:26:07 +0200
Message-ID: <CAHp75Vevs1NYkE_Js7m9gAxqO=j9UuJZk-KgOsvEp6Svd3FwmQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] dmaengine: introduce is_slave_xfer function
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        spear-devel <spear-devel@list.st.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 4:21 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Fri, Nov 16, 2012 at 03:59:14PM +0200, Andy Shevchenko wrote:
>> This function helps to distinguish the slave type of transfer by checking the
>> direction parameter.
>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> ---
>>  include/linux/dmaengine.h |    5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
>> index 6402b18..3e1a9026 100644
>> --- a/include/linux/dmaengine.h
>> +++ b/include/linux/dmaengine.h
>> @@ -618,6 +618,11 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
>>                       (unsigned long)config);
>>  }
>>
>> +static inline bool is_slave_xfer(enum dma_transfer_direction direction)
>> +{
>> +     return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
>> +}
>
> I wonder if the above function need some prefix like
> dmaengine_is_slave_xfer()?

is_dma_slave_xfer seems more consistent with other helper functions.

But is_slave_xfer is vacant anyway. I like shorter names.

>
> Otherwise looks fine to me.



-- 
With Best Regards,
Andy Shevchenko
