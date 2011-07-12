Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab1GLH4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:56:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47694 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1GLH4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:56:01 -0400
X-AuditID: cbfee61b-b7bfdae000006d51-bf-4e1bfe0f8a2f
Date: Tue, 12 Jul 2011 16:55:56 +0900
From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH] mmc: dw_mmc: Supply clocks for both host and card.
In-reply-to: <4E16C313.4000804@samsung.com>
To: "'Jaehoon Chung'" <jh80.chung@samsung.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
Message-id: <006001cc4069$236fe060$6a4fa120$%jun@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=utf-8
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acw9SxFcz+Td/lLvRBGFeRvD5YtccgDFtVpA
References: <1309402497-29191-1-git-send-email-tgih.jun@samsung.com>
 <4E0C1DD0.2040202@samsung.com>
 <008c01cc37a4$1ea4c1e0$5bee45a0$%jun@samsung.com>
 <000101cc3d3b$928b28a0$b7a179e0$%jun@samsung.com>
 <4E16C313.4000804@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Jaehoon Chung wrote:
> Hi
> 
> Seungwon Jeon wrote:
> > Hi, Mr Chung.
> >
> > Do you have any feedback?
> > I want to know how to manipulate clock for host or card on your test
> situation.
> 
> Yes. i used clock for them.
> 
> > I think there is no code for these clock in dw_mmc.
> > Who do you think is responsible for enabling clock? Driver or platform?
> >
> Right. there is no code for clock. So if we use that controller, need to
> add clock.
> But i didn't sure that we need to get clock's name from platdata.
> 
> If we can define the clock source, it's good that define standard clksrc
> name.("dw_mmc").

Yes, it is possible to define clock name in dwmmc driver.
And I understand that you agree to add clock for host running.
How about clock for card(SDCLK)?
Actually, Samsung Exynos4 distinguishes host clock and card clock.
I wonder whether clocks(host, card) are using separately in other system or not.
Then, it may need to add clock source for card similarly.

Beset regards,
Seungwon Jeon.

> Regards,
> Jaehoon Chung
> 
> > Any opinion/advice are welcome.
> >
> > Best regards,
> > Seungwon Jeon.
> >
> >
> > Seungwon Jeon wrote:
> >> Hi, Mr Chung.
> >>
> >>> -----Original Message-----
> >>> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-
> >>> owner@vger.kernel.org] On Behalf Of Jaehoon Chung
> >>> Sent: Thursday, June 30, 2011 3:55 PM
> >>> To: Seungwon Jeon
> >>> Cc: linux-mmc@vger.kernel.org; cjb@laptop.org; linux-
> >>> kernel@vger.kernel.org; Kyungmin Park
> >>> Subject: Re: [PATCH] mmc: dw_mmc: Supply clocks for both host and card.
> >>>
> >>> Hi Mr.Jeon
> >>>
> >>> What means cclk_name/ cclk enable?
> >>> Controlling card clock is possible?
> >>> Sorry, i didn't understand...
> >>> (My understanding is that if we set host clk, cclk is used with
> >> host_clk.)
> >>> Plz can you explain to me?
> >> Yes, cclk is source clock for card I/O.
> >> It can be different from Host operating clock(hclk).
> >>
> >> Best regards,
> >> Seunwgon.
> >>
> >>
> >>> Regards,
> >>> Jaehoon Chung
> >>>
> >>> Seungwon Jeon wrote:
> >>>> Add enabling clocks for both host controller and card.
> >>>>
> >>>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> >>>> ---
> >>>>  drivers/mmc/host/dw_mmc.c  |   33 ++++++++++++++++++++++++++++++++-
> >>>>  include/linux/mmc/dw_mmc.h |    7 +++++++
> >>>>  2 files changed, 39 insertions(+), 1 deletions(-)
> >>>>
> >>>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> >>>> index 10b6979..a524416 100644
> >>>> --- a/drivers/mmc/host/dw_mmc.c
> >>>> +++ b/drivers/mmc/host/dw_mmc.c
> >>>> @@ -1797,6 +1797,24 @@ static int dw_mci_probe(struct platform_device
> >>> *pdev)
> >>>>  		goto err_freehost;
> >>>>  	}
> >>>>
> >>>> +	host->hclk = clk_get(&pdev->dev, pdata->hclk_name);
> >>>> +	if (IS_ERR(host->hclk)) {
> >>>> +		dev_err(&pdev->dev,
> >>>> +			"Failed to get hclk\n");
> >>>> +		ret = PTR_ERR(host->hclk);
> >>>> +		goto err_freehost;
> >>>> +	}
> >>>> +	clk_enable(host->hclk);
> >>>> +
> >>>> +	host->cclk = clk_get(&pdev->dev, pdata->cclk_name);
> >>>> +	if (IS_ERR(host->cclk)) {
> >>>> +		dev_err(&pdev->dev,
> >>>> +			"Failed to get cclk\n");
> >>>> +		ret = PTR_ERR(host->cclk);
> >>>> +		goto err_free_hclk;
> >>>> +	}
> >>>> +	clk_enable(host->cclk);
> >>>> +
> >>>>  	host->bus_hz = pdata->bus_hz;
> >>>>  	host->quirks = pdata->quirks;
> >>>>
> >>>> @@ -1806,7 +1824,7 @@ static int dw_mci_probe(struct platform_device
> >>> *pdev)
> >>>>  	ret = -ENOMEM;
> >>>>  	host->regs = ioremap(regs->start, regs->end - regs->start + 1);
> >>>>  	if (!host->regs)
> >>>> -		goto err_freehost;
> >>>> +		goto err_free_cclk;
> >>>>
> >>>>  	host->dma_ops = pdata->dma_ops;
> >>>>  	dw_mci_init_dma(host);
> >>>> @@ -1945,6 +1963,13 @@ err_dmaunmap:
> >>>>  		regulator_put(host->vmmc);
> >>>>  	}
> >>>>
> >>>> +err_free_cclk:
> >>>> +	clk_disable(host->cclk);
> >>>> +	clk_put(host->cclk);
> >>>> +
> >>>> +err_free_hclk:
> >>>> +	clk_disable(host->hclk);
> >>>> +	clk_put(host->hclk);
> >>>>
> >>>>  err_freehost:
> >>>>  	kfree(host);
> >>>> @@ -1983,6 +2008,12 @@ static int __exit dw_mci_remove(struct
> >>> platform_device *pdev)
> >>>>  		regulator_put(host->vmmc);
> >>>>  	}
> >>>>
> >>>> +	clk_disable(host->cclk);
> >>>> +	clk_put(host->cclk);
> >>>> +
> >>>> +	clk_disable(host->hclk);
> >>>> +	clk_put(host->hclk);
> >>>> +
> >>>>  	iounmap(host->regs);
> >>>>
> >>>>  	kfree(host);
> >>>> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
> >>>> index f3f68ee..56b3f27 100644
> >>>> --- a/include/linux/mmc/dw_mmc.h
> >>>> +++ b/include/linux/mmc/dw_mmc.h
> >>>> @@ -47,6 +47,8 @@ struct mmc_data;
> >>>>   * @cmd: The command currently being sent to the card, or NULL.
> >>>>   * @data: The data currently being transferred, or NULL if no data
> >>>>   *	transfer is in progress.
> >>>> + * @hclk: Clock for host.
> >>>> + * @cclk: Clock for card.
> >>>>   * @use_dma: Whether DMA channel is initialized or not.
> >>>>   * @sg_dma: Bus address of DMA buffer.
> >>>>   * @sg_cpu: Virtual address of DMA buffer.
> >>>> @@ -118,6 +120,8 @@ struct dw_mci {
> >>>>  	struct mmc_request	*mrq;
> >>>>  	struct mmc_command	*cmd;
> >>>>  	struct mmc_data		*data;
> >>>> +	struct clk		*hclk;
> >>>> +	struct clk		*cclk;
> >>>>
> >>>>  	/* DMA interface members*/
> >>>>  	int			use_dma;
> >>>> @@ -218,6 +222,9 @@ struct dw_mci_board {
> >>>>  	/* delay in mS before detecting cards after interrupt */
> >>>>  	u32 detect_delay_ms;
> >>>>
> >>>> +	char *hclk_name;
> >>>> +	char *cclk_name;
> >>>> +
> >>>>  	int (*init)(u32 slot_id, irq_handler_t , void *);
> >>>>  	int (*get_ro)(u32 slot_id);
> >>>>  	int (*get_cd)(u32 slot_id);
> >>>> --
> >>>> 1.7.0.4
> >>>>
> >>>> --
> >>>> To unsubscribe from this list: send the line "unsubscribe linux-mmc"
> >> in
> >>>> the body of a message to majordomo@vger.kernel.org
> >>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-mmc"
> in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

