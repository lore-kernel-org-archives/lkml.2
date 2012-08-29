Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab2H2CBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 22:01:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48369 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab2H2CA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 22:00:57 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Axel Lin <axel.lin@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] lp8727_charger: use IRQF_ONESHOT
Thread-Topic: [PATCH] lp8727_charger: use IRQF_ONESHOT
Thread-Index: AQHNgSRlnI1kj5ruAkSGxfb4PIUiRZdwEOgQ
Date: Wed, 29 Aug 2012 02:00:43 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF19C0@DQHE02.ent.ti.com>
References: <20120823114229.GA16789@localhost>
In-Reply-To: <20120823114229.GA16789@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ERROR: Threaded IRQ with no primary handler requested without
> IRQF_ONESHOT
> 
> Make sure threaded IRQs without a primary handler are always request
> with IRQF_ONESHOT
> 
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
> 
> Note: I don't really know much about the situation, feel free to
> ignore it if it's an false warning.
> 
>  cocci-output-25411-2ae2e0-lp8727_charger.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/power/lp8727_charger.c
> +++ b/drivers/power/lp8727_charger.c
> @@ -255,7 +255,7 @@ static int lp8727_intr_config(struct lp8
>  	return request_threaded_irq(pchg->client->irq,
>  				NULL,
>  				lp8727_isr_func,
> -				IRQF_TRIGGER_FALLING,
> +				IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
>  				"lp8727_irq",
>  				pchg);
>  }
Thanks for the update.

Acked-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Best Regards,
Milo



