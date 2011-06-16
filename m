Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab1FPTpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:45:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38699 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758009Ab1FPTpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:45:14 -0400
Date: Thu, 16 Jun 2011 13:45:11 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: gpio-ml-ioh: fix off-by-one for displaying
 variable i in dev_err
Message-ID: <20110616194511.GA3697@ponder.secretlab.ca>
References: <1308049977.2671.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308049977.2671.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 07:12:57PM +0800, Axel Lin wrote:
> with the "for (; i != 0; i--)" sytax, i-- will be executed after the iteration.
> thus dev_err shows wrong i value.
> Switch to "while(--i >= 0)" which is better in readability.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Merged, thanks.

g.

> ---
>  drivers/gpio/gpio-ml-ioh.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
> index 1bc621a..a9016f5 100644
> --- a/drivers/gpio/gpio-ml-ioh.c
> +++ b/drivers/gpio/gpio-ml-ioh.c
> @@ -233,7 +233,7 @@ static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
>  	return 0;
>  
>  err_gpiochip_add:
> -	for (; i != 0; i--) {
> +	while (--i >= 0) {
>  		chip--;
>  		ret = gpiochip_remove(&chip->gpio);
>  		if (ret)
> -- 
> 1.7.4.1
> 
> 
> 
