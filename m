Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab2GMIps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:45:48 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36053 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2GMIpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:45:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAOh2x=k6MDt5arZfPgrn8_tPu_zgPsD2e5y0-JyUkrx71Z6BNQ@mail.gmail.com>
References: <1342166974-4490-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1342166974-4490-3-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=k6MDt5arZfPgrn8_tPu_zgPsD2e5y0-JyUkrx71Z6BNQ@mail.gmail.com>
Date: Fri, 13 Jul 2012 11:45:42 +0300
Message-ID: <CAHp75VfiyLJKdSogHRDqU1TC-3icKAhCXa0hWbfnWEcNmJosTQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] dw_dmac: set default alignment
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 11:26 AM, viresh kumar <viresh.kumar@linaro.org> wrote:
> It would be nice to keep spear-devel in cc, as this is the second
> platform that uses this driver.
I used to get the list of recipients via get_maintainer script. Will
try to not forget about that address in the future.

>> The default values are filled to support at least mem-to-mem tests provided by
>> dmatest module. It makes sense to choose the 4 bytes (2 least significant bits)
>> alignment by the default.

>> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
>> index 3d061c6..2a19ab6 100644
>> --- a/drivers/dma/dw_dmac.c
>> +++ b/drivers/dma/dw_dmac.c
>> @@ -1485,6 +1485,12 @@ static int __devinit dw_probe(struct platform_device *pdev)
>>         dw->dma.device_tx_status = dwc_tx_status;
>>         dw->dma.device_issue_pending = dwc_issue_pending;
>>
>> +       /* Set default alignment */
>> +       dw->dma.copy_align = 2;
>> +       dw->dma.xor_align = 2;
>> +       dw->dma.pq_align = 2;
>> +       dw->dma.fill_align = 2;
>
> To understand it more, what does this mean? We will not support
> transfers with unaligned
> addresses/length to word size?
The dmatest module uses those constants to get source, destination
addresses and length of the test data aligned. On the other hand we
can't use unaligned address in LLI because of the hardware restriction
(2 bits are used for choosing AHB master).


-- 
With Best Regards,
Andy Shevchenko
