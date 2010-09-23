Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab0IWNi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 09:38:26 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42337 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab0IWNiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 09:38:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NxPLKcbmhioo/+bZYMPAC76jQtYtsgOsYk41R5ks+7J1PnYpKz9GuaXQHFOUcyRTtQ
         SXsw+siJAzBlm7F+rQ2Dl2mzraibb+3sLikDCZF1YyQH66uia0B0cmzqRozdtNq7QAOs
         zJrYp9iZ1wcsDibOKAhI1IgTv2hxegqa6rhBk=
Date: Thu, 23 Sep 2010 17:38:18 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ds2760_battery: add HAS_IOMEM dependency
Message-ID: <20100923133818.GA8909@oksana.dev.rtsoft.ru>
References: <20100923124445.5309c100@mschwide.boeblingen.de.ibm.com>
 <20100923105727.GA22890@oksana.dev.rtsoft.ru>
 <20100923152136.07195b3b@mschwide.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100923152136.07195b3b@mschwide.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 03:21:36PM +0200, Martin Schwidefsky wrote:
[...]
> > I think the better fix would be to turn this into 'depends on W1',
> > and remove these selects.
> 
> That would work as well. Dunno what is better, W1 is a bus for a certain
> class of devices. The bus is only needed if at least one driver that uses
> it is configured. Which would argue for the select method but that has
> the dependency problem. Anyway, either method is fine with me. If you
> prefer the "depends on W1" lets do it that way.
> --
> [PATCH] ds2760_battery: fix W1 and W1_SLAVE_DS2760 dependency
> 
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Fix this Kconfig warning on allmodconfig for s390:
> 
> warning: (BATTERY_DS2760 && POWER_SUPPLY) selects W1 which has unmet direct dependencies (HAS_IOMEM)
> 
> Cc: Anton Vorontsov <cbou@mail.ru>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---

Applied, thanks!

>  drivers/power/Kconfig |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff -urpN linux-2.6/drivers/power/Kconfig linux-2.6-patched/drivers/power/Kconfig
> --- linux-2.6/drivers/power/Kconfig	2010-09-23 15:18:00.000000000 +0200
> +++ linux-2.6-patched/drivers/power/Kconfig	2010-09-23 15:18:46.000000000 +0200
> @@ -64,8 +64,7 @@ config TEST_POWER
>  
>  config BATTERY_DS2760
>  	tristate "DS2760 battery driver (HP iPAQ & others)"
> -	select W1
> -	select W1_SLAVE_DS2760
> +	depends on W1 && W1_SLAVE_DS2760
>  	help
>  	  Say Y here to enable support for batteries with ds2760 chip.
>  
> 
> -- 
> blue skies,
>    Martin.
> 
> "Reality continues to ruin my life." - Calvin.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
