Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab3AIPHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 10:07:50 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:37518 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab3AIPHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 10:07:49 -0500
MIME-Version: 1.0
In-Reply-To: <20130109141826.GP19691@intel.com>
References: <20130108155423.GJ19691@intel.com>
	<1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1357719435-29955-17-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130109141826.GP19691@intel.com>
Date: Wed, 9 Jan 2013 17:07:47 +0200
Message-ID: <CAHp75VfPzZf2qBw5Mz_quMEZC_zKoLE6Cpswi9srMQ4egosEiw@mail.gmail.com>
Subject: Re: [resend][PATCH 16/16] dma: dw_dmac: clear suspend bit during termination
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 4:18 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Wed, Jan 09, 2013 at 10:17:15AM +0200, Andy Shevchenko wrote:
>> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>>
>> The DMA transfer could not be established if previously it was paused and
>> terminated. In that case the channel's suspend bit remains set that prevents to
>> transfer anything until channel is resumed.
>>
>> The patch adds a code that clears the DWC_CFGL_CH_SUSP bit during termination.
> No this patch calls resume to do so... Can you update the change log

Updated. Will occur in patch v2.

>>
>> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>  drivers/dma/dw_dmac.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
>> index 6a8f8c7..c6ebea1 100644
>> --- a/drivers/dma/dw_dmac.c
>> +++ b/drivers/dma/dw_dmac.c
>> @@ -1059,7 +1059,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>>
>>               dwc_chan_disable(dw, dwc);
>>
>> -             dwc->paused = false;
>> +             dwc_chan_resume(dwc);
>>
>>               /* active_list entries will end up before queued entries */
>>               list_splice_init(&dwc->queue, &list);
>> --
>> 1.7.10.4
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With Best Regards,
Andy Shevchenko
