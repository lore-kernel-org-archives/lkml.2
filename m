Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1AQKiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:38:54 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:57144 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab1AQKix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:38:53 -0500
Message-ID: <4D341C35.80506@bfs.de>
Date: Mon, 17 Jan 2011 11:38:45 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.14) Gecko/20101013 SUSE/3.0.9 Thunderbird/3.0.9
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: kernel-janitors@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: mach-omap2: potential NULL dereference
References: <1295258922-31242-1-git-send-email-segoon@openwall.com>
In-Reply-To: <1295258922-31242-1-git-send-email-segoon@openwall.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 17.01.2011 11:08, schrieb Vasiliy Kulikov:
> kzalloc() may fail, if so return -ENOMEM.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Cannot compile this driver, so it is not tested at all.
> 
>  arch/arm/mach-omap2/smartreflex.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
> index 77ecebf..871bca9 100644
> --- a/arch/arm/mach-omap2/smartreflex.c
> +++ b/arch/arm/mach-omap2/smartreflex.c
> @@ -260,7 +260,10 @@ static int sr_late_init(struct omap_sr *sr_info)
>  	if (sr_class->class_type == SR_CLASS2 &&
>  		sr_class->notify_flags && sr_info->irq) {
>  
> +		ret = -ENOMEM;
>  		name = kzalloc(SMARTREFLEX_NAME_LEN + 1, GFP_KERNEL);
> +		if (name == NULL)
> +			goto error;
>  		strcpy(name, "sr_");
>  		strcat(name, sr_info->voltdm->name);
>  		ret = request_irq(sr_info->irq, sr_interrupt,

maybe it is more readable to use:
	kasprint(&name,"sr_%s",sr_info->voltdm->name);

re,
 wh
