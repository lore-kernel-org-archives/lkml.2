Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab0DPDyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 23:54:44 -0400
Received: from mail.perches.com ([173.55.12.10]:1506 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757702Ab0DPDym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 23:54:42 -0400
Subject: Re: [PATCH] mac8390: fix pr_info() calls, was Re: another cleanup
 patch gone wrong
From: Joe Perches <joe@perches.com>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: David Miller <davem@davemloft.net>, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
In-Reply-To: <alpine.OSX.2.00.1004161323340.271@localhost>
References: <alpine.OSX.2.00.1004161214270.271@localhost>
	 <20100415.200113.215578006.davem@davemloft.net>
	 <alpine.OSX.2.00.1004161323340.271@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 20:54:40 -0700
Message-ID: <1271390080.2298.25.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-16 at 13:45 +1000, Finn Thain wrote:
> Here's a patch, both uncalled-for and untested.
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> 
> --- a/drivers/net/mac8390.c	2010-04-16 13:31:04.000000000 +1000
> +++ b/drivers/net/mac8390.c	2010-04-16 13:35:06.000000000 +1000
> @@ -643,8 +643,8 @@
>  {
>  	__ei_open(dev);
>  	if (request_irq(dev->irq, __ei_interrupt, 0, "8390 Ethernet", dev)) {
> -		pr_info("%s: unable to get IRQ %d.\n", dev->name, dev->irq);
> -		return -EAGAIN;
> +		pr_err("%s: unable to get IRQ %d.\n", dev->name, dev->irq);
> +		return -EBUSY;

You should document this in the changelog.

>  	}
>  	return 0;
>  }
> @@ -660,7 +660,7 @@
>  {
>  	ei_status.txing = 0;
>  	if (ei_debug > 1)
> -		pr_info("reset not supported\n");
> +		pr_debug("reset not supported\n");

You'll need to add
#define DEBUG
for this to print.

> -		pr_info("Need to reset the NS8390 t=%lu...", jiffies);
> +		pr_debug("Need to reset the NS8390 t=%lu...", jiffies);

This also now doesn't print.

cheers, Joe

