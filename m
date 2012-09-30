Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab2I3EHk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 00:07:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58195 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2I3EHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 00:07:38 -0400
Subject: Re: [PATCH] extcon: adc-jack: Fix checking return value of
 request_any_context_irq
From: anish kumar <anish198519851985@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        anish kumar <anish.singh@samsung.com>
In-Reply-To: <1348788977.8055.1.camel@phoenix>
References: <1348788977.8055.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Sep 2012 09:37:29 +0530
Message-ID: <1348978049.7492.0.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 07:36 +0800, Axel Lin wrote:
> On failure, request_any_context_irq() returns a negative value.
> On success, it returns either IRQC_IS_HARDIRQ or IRQC_IS_NESTED.
> 
> Also ensure adc_jack_probe() return 0 on success.
this patch makes sense.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/extcon/extcon-adc-jack.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
> index 725eb5a..2cc6bec 100644
> --- a/drivers/extcon/extcon-adc-jack.c
> +++ b/drivers/extcon/extcon-adc-jack.c
> @@ -161,13 +161,12 @@ static int __devinit adc_jack_probe(struct platform_device *pdev)
>  	err = request_any_context_irq(data->irq, adc_jack_irq_thread,
>  			pdata->irq_flags, pdata->name, data);
>  
> -	if (err) {
> +	if (err < 0) {
>  		dev_err(&pdev->dev, "error: irq %d\n", data->irq);
> -		err = -EINVAL;
>  		goto err_irq;
>  	}
>  
> -	goto out;
> +	return 0;
>  
>  err_irq:
>  	extcon_dev_unregister(&data->edev);


