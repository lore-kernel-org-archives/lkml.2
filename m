Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445Ab1F3Gdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 02:33:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14502 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab1F3Gdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 02:33:32 -0400
X-AuditID: cbfee61a-b7c53ae000002dc1-61-4e0c18baba90
Date: Thu, 30 Jun 2011 15:33:33 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
Subject: Re: [PATCH] mmc: dw_mmc: Add the function call for board-specific
 initialization.
In-reply-to: <1309402665-29228-1-git-send-email-tgih.jun@samsung.com>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, linux-kernel@vger.kernel.org
Message-id: <4E0C18BD.8000608@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (X11/20100623)
References: <1309402665-29228-1-git-send-email-tgih.jun@samsung.com>
X-OriginalArrivalTime: 30 Jun 2011 06:33:45.0501 (UTC)
 FILETIME=[A9751CD0:01CC36EF]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mr.Jeon

This patch is the compiler error.

didn't find host->card_work..

do you want this
queue_work(dw_mci_card_workqueue, &slot->host->card_work); ?


Regards,
Jaehoon Chung


Seungwon Jeon wrote:
> Need to call init() function of dw_mci_board.
> It seems to be omitted to call this function.
> 
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
>  drivers/mmc/host/dw_mmc.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index a524416..073c420 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1585,6 +1585,15 @@ static void dw_mci_work_routine_card(struct work_struct *work)
>  	}
>  }
> 
> +static irqreturn_t dw_mci_detect_interrupt(int irq, void *dev_id)
> +{
> +	struct dw_mci_slot *slot = dev_id;
> +
> +	queue_work(dw_mci_card_workqueue, &host->card_work);
> +
> +	return IRQ_HANDLED;
> +}
> +
>  static int __init dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  {
>  	struct mmc_host *mmc;
> @@ -1657,6 +1666,8 @@ static int __init dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  	} else
>  		regulator_enable(host->vmmc);
> 
> +	host->pdata->init(id, dw_mci_detect_interrupt, host);
> +
>  	if (dw_mci_get_cd(mmc))
>  		set_bit(DW_MMC_CARD_PRESENT, &slot->flags);
>  	else
> --
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

