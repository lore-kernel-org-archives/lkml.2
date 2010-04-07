Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab0DGFI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 01:08:26 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:44338 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab0DGFIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 01:08:20 -0400
X-Greylist: delayed 1502 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2010 01:08:20 EDT
Date: Wed, 7 Apr 2010 07:42:27 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] pl061: Trivial fix for offset value range checking
Message-ID: <20100407044225.GA4569@jasper.tkos.co.il>
References: <k2n427d64721004052233s314c7daj1f96a77061f6b836@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <k2n427d64721004052233s314c7daj1f96a77061f6b836@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Apr 06, 2010 at 01:33:09PM +0800, Axel Lin wrote:
> The valid offset value is 0..PL061_GPIO_NR-1,
> this patch corrects the offset value range checking.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Baruch Siach <baruch@tkos.co.il>

Thanks.

baruch

> ---
>  drivers/gpio/pl061.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/pl061.c b/drivers/gpio/pl061.c
> index 5ad8f77..8e0906a 100644
> --- a/drivers/gpio/pl061.c
> +++ b/drivers/gpio/pl061.c
> @@ -158,7 +158,7 @@ static int pl061_irq_type(unsigned irq, unsigned trigger)
>  	unsigned long flags;
>  	u8 gpiois, gpioibe, gpioiev;
> 
> -	if (offset < 0 || offset > PL061_GPIO_NR)
> +	if (offset < 0 || offset >= PL061_GPIO_NR)
>  		return -EINVAL;
> 
>  	spin_lock_irqsave(&chip->irq_lock, flags);
> -- 
> 1.5.4.3

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
