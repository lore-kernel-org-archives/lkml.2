Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab1F3InK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:43:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43802 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab1F3InF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:43:05 -0400
MIME-Version: 1.0
X-Originating-IP: [87.194.181.195]
In-Reply-To: <4E0C31DF.5090200@samsung.com>
References: <1309402665-29228-1-git-send-email-tgih.jun@samsung.com>
	<4E0C18BD.8000608@samsung.com>
	<BANLkTikhwh5M1XB9zRiLzMd7dL18kA_o0g@mail.gmail.com>
	<4E0C31DF.5090200@samsung.com>
Date: Thu, 30 Jun 2011 09:43:04 +0100
Message-ID: <BANLkTi=r3x81sPVLG9yRAG9hHnjQuqTHCg@mail.gmail.com>
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

Hi,

On 30 June 2011 09:20, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> Hi James
>
> James Hogan wrote:
>> On 30 June 2011 07:33, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>>> Hi Mr.Jeon
>>>
>>> This patch is the compiler error.
>>>
>>> didn't find host->card_work..
>>>
>>> do you want this
>>> queue_work(dw_mci_card_workqueue, &slot->host->card_work); ?
>>
>> I think the patch is based on mmc-next, which has the following commit:
>> 35ba9d8 mmc: dw_mmc: convert card tasklet to workqueue
>
> I also tested this patch based on mmc-next.
> But my mean is that there is not host structure in dw_mci_detect_interrupt().
>
> drivers/mmc/host/dw_mmc.c: In function 'dw_mci_detect_interrupt':
> drivers/mmc/host/dw_mmc.c:1592: error: 'host' undeclared (first use in this function)
> drivers/mmc/host/dw_mmc.c:1592: error: (Each undeclared identifier is reported only once
> drivers/mmc/host/dw_mmc.c:1592: error: for each function it appears in.)
> drivers/mmc/host/dw_mmc.c:1590: warning: unused variable 'slot'
> make[3]: *** [drivers/mmc/host/dw_mmc.o] Error 1
> make[2]: *** [drivers/mmc/host] Error 2

Sorry, I misunderstood. You are correct.

Cheers
James

>
> Did you really compile fine?
>
> Regards,
> Jaehoon Chung
>
>>
>> Cheers
>> James
>>
>>>
>>> Regards,
>>> Jaehoon Chung
>>>
>>>
>>> Seungwon Jeon wrote:
>>>> Need to call init() function of dw_mci_board.
>>>> It seems to be omitted to call this function.
>>>>
>>>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
>>>> ---
>>>>  drivers/mmc/host/dw_mmc.c |   11 +++++++++++
>>>>  1 files changed, 11 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>>>> index a524416..073c420 100644
>>>> --- a/drivers/mmc/host/dw_mmc.c
>>>> +++ b/drivers/mmc/host/dw_mmc.c
>>>> @@ -1585,6 +1585,15 @@ static void dw_mci_work_routine_card(struct work_struct *work)
>>>>       }
>>>>  }
>>>>
>>>> +static irqreturn_t dw_mci_detect_interrupt(int irq, void *dev_id)
>>>> +{
>>>> +     struct dw_mci_slot *slot = dev_id;
>>>> +
>>>> +     queue_work(dw_mci_card_workqueue, &host->card_work);
>>>> +
>>>> +     return IRQ_HANDLED;
>>>> +}
>>>> +
>>>>  static int __init dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>>>>  {
>>>>       struct mmc_host *mmc;
>>>> @@ -1657,6 +1666,8 @@ static int __init dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>>>>       } else
>>>>               regulator_enable(host->vmmc);
>>>>
>>>> +     host->pdata->init(id, dw_mci_detect_interrupt, host);
>>>> +
>>>>       if (dw_mci_get_cd(mmc))
>>>>               set_bit(DW_MMC_CARD_PRESENT, &slot->flags);
>>>>       else
>>>> --
>>>> 1.7.0.4
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>>
>
>



-- 
James Hogan
