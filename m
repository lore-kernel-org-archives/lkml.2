Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab2EXFEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 01:04:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35911 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2EXFEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 01:04:12 -0400
MIME-Version: 1.0
In-Reply-To: <4FBDB812.9060407@linaro.org>
References: <1337771851-3431-1-git-send-email-tushar.behera@linaro.org>
	<4FBDB812.9060407@linaro.org>
Date: Thu, 24 May 2012 10:34:10 +0530
Message-ID: <CAJe_ZhfV6F-X7+M+NYoH4cG1WWU45MTpHsUiWtK406nhjLPHRg@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: pl330: dont complete descriptor for cyclic dma
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, patches@linaro.org,
        Thomas Abraham <thomas.abraham@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 May 2012 09:54, Tushar Behera <tushar.behera@linaro.org> wrote:
> Forgot to add driver author in the original mail, adding now.
>
> On 05/23/2012 04:47 PM, Tushar Behera wrote:
>> Commit eab215855803 ("dmaengine: pl330: dont complete descriptor for
>> cyclic dma") wrongly completes descriptor for cyclic dma, hence following
>> BUG_ON is still hit with cyclic DMA operations.
>>
>> kernel BUG at drivers/dma/dmaengine.h:53!
>>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> ---
>>  drivers/dma/pl330.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
>> index fa3fb21..8c44f17 100644
>> --- a/drivers/dma/pl330.c
>> +++ b/drivers/dma/pl330.c
>> @@ -2322,7 +2322,7 @@ static void pl330_tasklet(unsigned long data)
>>       /* Pick up ripe tomatoes */
>>       list_for_each_entry_safe(desc, _dt, &pch->work_list, node)
>>               if (desc->status == DONE) {
>> -                     if (pch->cyclic)
>> +                     if (!pch->cyclic)
>>                               dma_cookie_complete(&desc->txd);
>>                       list_move_tail(&desc->node, &list);
>>               }
>
Acked-by: Jassi Brar <jaswinder.singh@linaro.org>

Obviously a typo, but the commit eab2158 had a tested-by, so I hope
this doesn't break something else.
