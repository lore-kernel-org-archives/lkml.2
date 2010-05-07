Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab0EGKgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 06:36:14 -0400
Received: from crca.org.au ([74.207.252.120]:42646 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab0EGKgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 06:36:13 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BE3ED18.3050202@tuxonice.net>
Date: Fri, 07 May 2010 20:36:08 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Steven Liu <lingjiujianke@gmail.com>
CC: Linus WALLEIJ <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Check kmalloc return value before use the bigrxbuf_virtual
 	and kfree the bigtxbuf_virtual
References: <x2ybd0d95d71005070304wf9c7235eqedf0d0c37dffe316@mail.gmail.com>
In-Reply-To: <x2ybd0d95d71005070304wf9c7235eqedf0d0c37dffe316@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 07/05/10 20:04, Steven Liu wrote:
> Check kmalloc return value before use the bigrxbuf_virtual ,when
> bigrxbuf_virtual is NULL, kfree  bigtxbuf_virtual and out
>
> Signed-off-by: LiuQi<lingjiujianke@gmail.com>

Acked-by: Nigel Cunningham <nigel@tuxonice.net>

> ---
>   arch/arm/mach-u300/dummyspichip.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-u300/dummyspichip.c
> b/arch/arm/mach-u300/dummyspichip.c
> index 5f55012..df19f9b 100644
> --- a/arch/arm/mach-u300/dummyspichip.c
> +++ b/arch/arm/mach-u300/dummyspichip.c
> @@ -64,6 +64,11 @@ static ssize_t dummy_looptest(struct device *dev,
>   		goto out;
>   	}
>   	bigrxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
> +	if (bigrxbuf_virtual == NULL) {
> +		status = -ENOMEM;
> +		kfree(bigtxbuf_virtual);
> +		goto out;
> +	}
>
>   	/* Fill TXBUF with some happy pattern */
>   	memset(bigtxbuf_virtual, 0xAA, DMA_TEST_SIZE);

