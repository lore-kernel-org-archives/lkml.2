Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab1F3ILr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:11:47 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54489 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab1F3ILo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:11:44 -0400
MIME-Version: 1.0
X-Originating-IP: [87.194.181.195]
In-Reply-To: <4E0C18BD.8000608@samsung.com>
References: <1309402665-29228-1-git-send-email-tgih.jun@samsung.com>
	<4E0C18BD.8000608@samsung.com>
Date: Thu, 30 Jun 2011 09:04:30 +0100
Message-ID: <BANLkTikhwh5M1XB9zRiLzMd7dL18kA_o0g@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Add the function call for board-specific initialization.
From: James Hogan <james@albanarts.com>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Seungwon Jeon <tgih.jun@samsung.com>, linux-mmc@vger.kernel.org,
        cjb@laptop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 June 2011 07:33, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> Hi Mr.Jeon
>
> This patch is the compiler error.
>
> didn't find host->card_work..
>
> do you want this
> queue_work(dw_mci_card_workqueue, &slot->host->card_work); ?

I think the patch is based on mmc-next, which has the following commit:
35ba9d8 mmc: dw_mmc: convert card tasklet to workqueue

Cheers
James

>
>
> Regards,
> Jaehoon Chung
>
>
> Seungwon Jeon wrote:
>> Need to call init() function of dw_mci_board.
>> It seems to be omitted to call this function.
>>
>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
>> ---
>>  drivers/mmc/host/dw_mmc.c |   11 +++++++++++
>>  1 files changed, 11 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>> index a524416..073c420 100644
>> --- a/drivers/mmc/host/dw_mmc.c
>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -1585,6 +1585,15 @@ static void dw_mci_work_routine_card(struct work_struct *work)
>>       }
>>  }
>>
>> +static irqreturn_t dw_mci_detect_interrupt(int irq, void *dev_id)
>> +{
>> +     struct dw_mci_slot *slot = dev_id;
>> +
>> +     queue_work(dw_mci_card_workqueue, &host->card_work);
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>>  static int __init dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>>  {
>>       struct mmc_host *mmc;
>> @@ -1657,6 +1666,8 @@ static int __init dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>>       } else
>>               regulator_enable(host->vmmc);
>>
>> +     host->pdata->init(id, dw_mci_detect_interrupt, host);
>> +
>>       if (dw_mci_get_cd(mmc))
>>               set_bit(DW_MMC_CARD_PRESENT, &slot->flags);
>>       else
>> --
>> 1.7.0.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
James Hogan
