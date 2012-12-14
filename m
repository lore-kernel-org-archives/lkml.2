Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab2LNHGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 02:06:07 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:54920 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab2LNHGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 02:06:05 -0500
MIME-Version: 1.0
In-Reply-To: <20121213153437.b8b0198d.akpm@linux-foundation.org>
References: <1355139464-6855-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1355139464-6855-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<20121213153437.b8b0198d.akpm@linux-foundation.org>
Date: Fri, 14 Dec 2012 09:06:03 +0200
Message-ID: <CAHp75VfxyyqaAOTsXQfEaiQm8tPetG2JZUm-XrezzdL01qoYiA@mail.gmail.com>
Subject: Re: [PATCH 2/2] dmatest: check for dma mapping error
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 1:34 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 10 Dec 2012 13:37:44 +0200
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
>
>> We get a warning if CONFIG_DMA_API_DEBUG=y
>>
>> [   28.150631] WARNING: at lib/dma-debug.c:933 check_unmap+0x5d6/0x6ac()
>> [   28.157058] dw_dmac dw_dmac.0: DMA-API: device driver failed to check map error[device address=0x0000000035698305] [size=14365 bytes] [mapped as single]

>> --- a/drivers/dma/dmatest.c
>> +++ b/drivers/dma/dmatest.c
>> @@ -378,15 +378,35 @@ static int dmatest_func(void *data)
>>
>>                       dma_srcs[i] = dma_map_single(dev->dev, buf, len,
>>                                                    DMA_TO_DEVICE);
>> +                     ret = dma_mapping_error(dev->dev, dma_srcs[i]);
>> +                     if (ret) {
>> +                             unmap_src(dev->dev, dma_srcs, len, i);
>> +                             pr_warn("%s: #%u: mapping error %d with "
>> +                                     "src_off=0x%x len=0x%x\n",
>> +                                     thread_name, total_tests - 1, ret,
>> +                                     src_off, len);
>> +                             failed_tests++;
>> +                             continue;
>> +                     }
>
> The changelog and the code don't match.  Which one is out of date?

I'm afraid I didn't get what is wrong.

dmatest maps memory via dma_map_single() call. And it asks dmaengine
(at the end the DMA controller driver) to unmap them after usage.
Exactly at that time user gets a warning. And this warning is
independent of DMA controller in use.

-- 
With Best Regards,
Andy Shevchenko
