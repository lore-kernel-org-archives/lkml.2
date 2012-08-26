Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab2HZXyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 19:54:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24770 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab2HZXyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 19:54:22 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-9a-503ab72d8390
Message-id: <503AB72C.9020505@samsung.com>
Date: Mon, 27 Aug 2012 08:54:20 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] extcon: arizona: Free MICDET IRQ on error during probe
References: <1346014700-5912-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-reply-to: <1346014700-5912-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jAV3d7VYBBrPu81hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MO2+nMRW846i4t8KsgXETexcjJ4eEgInE8o65TBC2mMSFe+vZ
	uhi5OIQEFjFKfDw+kxHC6WKSePPoNBtIFa+AlsSn80fAbBYBVYnPl26BdbMBxfe/uAEU5+AQ
	FYiQ+NXPAVEuKPFj8j0WkLAI0LLf9ytBRjILLGaU2PRvFSNIjbCAt8SdeV3MILaQQIjEuxM7
	wOKcAqES8xsXgsWZBXQk9rdOY4Ow5SU2r3nLPIFRYBaSFbOQlM1CUraAkXkVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnD4PZPewbiqweIQowAHoxIPr0CpZYAQa2JZcWXuIUYJDmYlEd7v
	+4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEefn7DAOEBNITS1KzU1MLUotgskwcnFINjPEPr+37
	furjigafAo6LPlcZD/Au0jWoPzHPaAJrZ1Jy4t6XHxMinbZU7+X8llVzOt1w9X0rS6sZdUXc
	nzLM1uj/XHHlq4h3yOL3MQcXmuTOT755zo6jxNvrdOnk0xysVw57lkmX5+7el26QutPgkcs+
	gw4Toy3qLwoV9uXV/t6ksHil3qKomUosxRmJhlrMRcWJAIX9vHs7AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 05:58 AM, Mark Brown wrote:

> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index fa2114f..13eafcb 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -488,11 +488,13 @@ static int __devinit arizona_extcon_probe(struct platform_device *pdev)
>  	ret = input_register_device(info->input);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Can't register input device: %d\n", ret);
> -		goto err_fall_wake;
> +		goto err_micdet;
>  	}
>  
>  	return 0;
>  
> +err_micdet:
> +	arizona_free_irq(arizona, ARIZONA_IRQ_MICDET, info);
>  err_fall_wake:
>  	arizona_set_irq_wake(arizona, ARIZONA_IRQ_JD_FALL, 0);
>  err_fall:


Thanks much,

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

I will apply this patch to
http://10.90.51.51/cgi-bin/gitweb.cgi?p=linux-samsung;a=shortlog;h=refs/heads/extcon-for-next
and you can check it after some hours.
