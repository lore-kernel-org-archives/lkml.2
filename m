Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab0KSTCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:02:18 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:44527 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754970Ab0KSTCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:02:17 -0500
Message-ID: <4CE6C9A4.4090307@metafoo.de>
Date: Fri, 19 Nov 2010 20:01:56 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: kernel-janitors@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: gpio-charger: fix potential NULL dereference
References: <1290192114-11659-1-git-send-email-segoon@openwall.com>
In-Reply-To: <1290192114-11659-1-git-send-email-segoon@openwall.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasiliy Kulikov wrote:
> kzalloc() result is not compared with NULL.  It might lead to NULL
> pointer dereference in OOM situation.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Compile tested only.
> 
>  drivers/power/gpio-charger.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
> index fccbe99..b07a71c 100644
> --- a/drivers/power/gpio-charger.c
> +++ b/drivers/power/gpio-charger.c
> @@ -87,6 +87,10 @@ static int __devinit gpio_charger_probe(struct platform_device *pdev)
>  	}
>  
>  	gpio_charger = kzalloc(sizeof(*gpio_charger), GFP_KERNEL);
> +	if (!gpio_charger) {
> +		dev_err(&pdev->dev, "kzalloc failed\n");
> +		return -ENOMEM;
> +	}
>  
>  	charger = &gpio_charger->charger;
>  

Hi

I already send a similar patch yesterday.
See http://lkml.org/lkml/2010/11/18/632

- Lars
