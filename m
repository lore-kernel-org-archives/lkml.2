Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab2ITJkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:40:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38308 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2ITJkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:40:17 -0400
MIME-Version: 1.0
In-Reply-To: <1348133748.13371.33.camel@smile>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1347867577-13170-4-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x==MwD6RVnShoD0zJaAPZ814bAGDx6BEjGsK=9M+LxMxBA@mail.gmail.com>
	<1348133748.13371.33.camel@smile>
Date: Thu, 20 Sep 2012 15:10:17 +0530
X-Google-Sender-Auth: qyq4y1hrsk2_igT-HIZ-eKB495M
Message-ID: <CAOh2x=n-26MSV4yxse=+iT=3ATa2Qd858QuWmRiRmjwnzxmFhA@mail.gmail.com>
Subject: Re: [PATCH 3/7] dw_dmac: get number of channels from hardware if possible
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 3:05 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Tue, 2012-09-18 at 12:20 +0530, viresh kumar wrote:
>> > @@ -1392,23 +1396,32 @@ static int __devinit dw_probe(struct platform_device *pdev)
>> > +       dw_params = dma_raw_readl(regs, DW_PARAMS);
>>
>> Is this valid for every SoC implementation. What if this configuration
>> is not valid
>> for a particular SoC and it is invalid to access this address? Or this
>> gives a invalid
>> value instead of returning 0?

> Actually I didn't get it clearly from the documentation. We have only
> one test report from Hein until now.

@Shiraz: Can you please verify reading this register from u-boot? This
is important before we apply this patch to linux-next.

>> > diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
>> > index 4633d39..0f96965 100644
>> > --- a/drivers/dma/dw_dmac_regs.h
>> > +++ b/drivers/dma/dw_dmac_regs.h
>> > @@ -104,6 +104,10 @@ struct dw_dma_regs {
>> >  #define dma_raw_writel(addr, name, val) \
>> >         writel((val), (addr) + offsetof(struct dw_dma_regs, name))
>> >
>> > +/* Bitfields in DW_PARAMS */
>> > +#define DW_PARAMS_NR_CHAN      8               /* number of channels */
>> > +#define DW_PARAMS_EN           28              /* encoded parameters */
>> > +
>>
>> Can you make this part of patch 2/7?
> Do you mean to combine patch 2 and 3 together or only the parts related
> to dw_dmac_regs.h?

Only the new register definition macros in dmac_regs.h. :)

--
viresh
