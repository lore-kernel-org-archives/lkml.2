Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1FHIpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 04:45:34 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:6946 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab1FHIpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 04:45:32 -0400
Subject: Re: [PATCH] atmel_serial: keep the platform_device unchanged
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <1302724038-26236-1-git-send-email-plagnioj@jcrosoft.com>
References: <1302724038-26236-1-git-send-email-plagnioj@jcrosoft.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Wed, 08 Jun 2011 10:45:03 +0200
Message-ID: <1307522703.10626.9.camel@hcegtvedt.norway.atmel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jun 2011 08:45:06.0035 (UTC) FILETIME=[5D88AC30:01CC25B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 21:47 +0200, Jean-Christophe PLAGNIOL-VILLARD
wrote:
> specify the port num via platform_data this will allow to match the clock
> with the plaform_dev staticly

Sure this works as intended, now the platform device id is off, and at
least for my 3.0 testing it is no longer able to open the console,
unless I explicit set the id field again.

Example on NGW100 mkII I use USART instance 1 as serial console, if not
setting the platform device id to 0 (re-mapping), then I get a warning
about unable to open console.

Is you clock optimization an additional patch?

<snipp AT91 changes)

> diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> index bfc9d07..aa677e2 100644
> --- a/arch/avr32/mach-at32ap/at32ap700x.c
> +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> @@ -1014,6 +1014,7 @@ static struct platform_device *__initdata at32_usarts[4];
>  void __init at32_map_usart(unsigned int hw_id, unsigned int line, int flags)
>  {
>  	struct platform_device *pdev;
> +	struct atmel_uart_data *pdata;
>  
>  	switch (hw_id) {
>  	case 0:
> @@ -1042,7 +1043,8 @@ void __init at32_map_usart(unsigned int hw_id, unsigned int line, int flags)
>  		data->regs = (void __iomem *)pdev->resource[0].start;
>  	}
>  
> -	pdev->id = line;

AVR32 needs this to be present to work independent of which USART
peripheral the user chooses to use for console.

> +	pdata = pdev->dev.platform_data;
> +	pdata->num = portnr;
>  	at32_usarts[line] = pdev;
>  }
>  

<snipp>

-- 
Hans-Christian Egtvedt

