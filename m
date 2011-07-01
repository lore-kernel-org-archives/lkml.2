Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab1GAEFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 00:05:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62099 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab1GAEFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 00:05:33 -0400
X-AuditID: cbfee61a-b7c53ae000002dc1-24-4e0d478b3237
Date: Fri, 01 Jul 2011 13:05:31 +0900
From: =?ks_c_5601-1987?B?wPy9wr/4?= <tgih.jun@samsung.com>
Subject: RE: [PATCH] mmc: dw_mmc: Supply clocks for both host and card.
In-reply-to: <4E0C1DD0.2040202@samsung.com>
To: "'Jaehoon Chung'" <jh80.chung@samsung.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
Message-id: <008c01cc37a4$1ea4c1e0$5bee45a0$%jun@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acw28sRI/fvSwZqhRNyMFrHGRl2XHwApLJ1w
x-cr-hashedpuzzle: iQs= KHxR OGUB QJO0 R3wl X52C ahUY dK25 m0Uh npQ2 wkxp xK5W
 y3EC zLXR 0RT7
 0m2m;5;YwBqAGIAQABsAGEAcAB0AG8AcAAuAG8AcgBnADsAagBoADgAMAAuAGMAaAB1AG4AZwBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGsAeQB1AG4AZwBtAGkAbgAuAHAAYQByAGsAQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AbQBtAGMAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{B4086CF2-98A3-4824-9B64-DAE312094AF0};dABnAGkAaAAuAGoAdQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Fri,
 01 Jul 2011 04:05:22
 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAAbQBtAGMAOgAgAGQAdwBfAG0AbQBjADoAIABTAHUAcABwAGwAeQAgAGMAbABvAGMAawBzACAAZgBvAHIAIABiAG8AdABoACAAaABvAHMAdAAgAGEAbgBkACAAYwBhAHIAZAAuAA==
x-cr-puzzleid: {B4086CF2-98A3-4824-9B64-DAE312094AF0}
References: <1309402497-29191-1-git-send-email-tgih.jun@samsung.com>
 <4E0C1DD0.2040202@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mr Chung.

> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-
> owner@vger.kernel.org] On Behalf Of Jaehoon Chung
> Sent: Thursday, June 30, 2011 3:55 PM
> To: Seungwon Jeon
> Cc: linux-mmc@vger.kernel.org; cjb@laptop.org; linux-
> kernel@vger.kernel.org; Kyungmin Park
> Subject: Re: [PATCH] mmc: dw_mmc: Supply clocks for both host and card.
> 
> Hi Mr.Jeon
> 
> What means cclk_name/ cclk enable?
> Controlling card clock is possible?
> Sorry, i didn't understand...
> (My understanding is that if we set host clk, cclk is used with host_clk.)
> 
> Plz can you explain to me?

Yes, cclk is source clock for card I/O.
It can be different from Host operating clock(hclk).

Best regards,
Seunwgon.

 
> Regards,
> Jaehoon Chung
> 
> Seungwon Jeon wrote:
> > Add enabling clocks for both host controller and card.
> >
> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> > ---
> >  drivers/mmc/host/dw_mmc.c  |   33 ++++++++++++++++++++++++++++++++-
> >  include/linux/mmc/dw_mmc.h |    7 +++++++
> >  2 files changed, 39 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> > index 10b6979..a524416 100644
> > --- a/drivers/mmc/host/dw_mmc.c
> > +++ b/drivers/mmc/host/dw_mmc.c
> > @@ -1797,6 +1797,24 @@ static int dw_mci_probe(struct platform_device
> *pdev)
> >  		goto err_freehost;
> >  	}
> >
> > +	host->hclk = clk_get(&pdev->dev, pdata->hclk_name);
> > +	if (IS_ERR(host->hclk)) {
> > +		dev_err(&pdev->dev,
> > +			"Failed to get hclk\n");
> > +		ret = PTR_ERR(host->hclk);
> > +		goto err_freehost;
> > +	}
> > +	clk_enable(host->hclk);
> > +
> > +	host->cclk = clk_get(&pdev->dev, pdata->cclk_name);
> > +	if (IS_ERR(host->cclk)) {
> > +		dev_err(&pdev->dev,
> > +			"Failed to get cclk\n");
> > +		ret = PTR_ERR(host->cclk);
> > +		goto err_free_hclk;
> > +	}
> > +	clk_enable(host->cclk);
> > +
> >  	host->bus_hz = pdata->bus_hz;
> >  	host->quirks = pdata->quirks;
> >
> > @@ -1806,7 +1824,7 @@ static int dw_mci_probe(struct platform_device
> *pdev)
> >  	ret = -ENOMEM;
> >  	host->regs = ioremap(regs->start, regs->end - regs->start + 1);
> >  	if (!host->regs)
> > -		goto err_freehost;
> > +		goto err_free_cclk;
> >
> >  	host->dma_ops = pdata->dma_ops;
> >  	dw_mci_init_dma(host);
> > @@ -1945,6 +1963,13 @@ err_dmaunmap:
> >  		regulator_put(host->vmmc);
> >  	}
> >
> > +err_free_cclk:
> > +	clk_disable(host->cclk);
> > +	clk_put(host->cclk);
> > +
> > +err_free_hclk:
> > +	clk_disable(host->hclk);
> > +	clk_put(host->hclk);
> >
> >  err_freehost:
> >  	kfree(host);
> > @@ -1983,6 +2008,12 @@ static int __exit dw_mci_remove(struct
> platform_device *pdev)
> >  		regulator_put(host->vmmc);
> >  	}
> >
> > +	clk_disable(host->cclk);
> > +	clk_put(host->cclk);
> > +
> > +	clk_disable(host->hclk);
> > +	clk_put(host->hclk);
> > +
> >  	iounmap(host->regs);
> >
> >  	kfree(host);
> > diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
> > index f3f68ee..56b3f27 100644
> > --- a/include/linux/mmc/dw_mmc.h
> > +++ b/include/linux/mmc/dw_mmc.h
> > @@ -47,6 +47,8 @@ struct mmc_data;
> >   * @cmd: The command currently being sent to the card, or NULL.
> >   * @data: The data currently being transferred, or NULL if no data
> >   *	transfer is in progress.
> > + * @hclk: Clock for host.
> > + * @cclk: Clock for card.
> >   * @use_dma: Whether DMA channel is initialized or not.
> >   * @sg_dma: Bus address of DMA buffer.
> >   * @sg_cpu: Virtual address of DMA buffer.
> > @@ -118,6 +120,8 @@ struct dw_mci {
> >  	struct mmc_request	*mrq;
> >  	struct mmc_command	*cmd;
> >  	struct mmc_data		*data;
> > +	struct clk		*hclk;
> > +	struct clk		*cclk;
> >
> >  	/* DMA interface members*/
> >  	int			use_dma;
> > @@ -218,6 +222,9 @@ struct dw_mci_board {
> >  	/* delay in mS before detecting cards after interrupt */
> >  	u32 detect_delay_ms;
> >
> > +	char *hclk_name;
> > +	char *cclk_name;
> > +
> >  	int (*init)(u32 slot_id, irq_handler_t , void *);
> >  	int (*get_ro)(u32 slot_id);
> >  	int (*get_cd)(u32 slot_id);
> > --
> > 1.7.0.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

