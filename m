Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0IVMSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 08:18:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44542 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab0IVMSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 08:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jCbwKPPjVN/z+EMq5HR0jOb2XM819722JAkQxXvv3BLrNAQkQhS9rMOsBEhMRuhk/h
         x67szINblpZc0P/C9zl1nBFMQu/XcFTOQ5pl6pYu8tZ1LRaKDsFL/kVqNmdSuPrdra8p
         H6II+nMhCL8qMpItz0ZUGdXuke+UQnR9e5WAI=
Date: Wed, 22 Sep 2010 16:18:45 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Balaji Rao <balajirrao@openmoko.org>,
        Paul Fertser <fercerpav@gmail.com>
Subject: Re: [PATCH] drivers/power: add missing sysfs_remove_group() in
 pcf50633_mbc_remove()
Message-ID: <20100922121658.GA24829@oksana.dev.rtsoft.ru>
References: <1285058157.26315.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1285058157.26315.1.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 04:35:57PM +0800, Axel Lin wrote:
> sysfs entries should be removed when unload the module.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks!

> ---
>  drivers/power/pcf50633-charger.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
> index 066f994..4fa52e1 100644
> --- a/drivers/power/pcf50633-charger.c
> +++ b/drivers/power/pcf50633-charger.c
> @@ -456,6 +456,7 @@ static int __devexit pcf50633_mbc_remove(struct platform_device *pdev)
>  	for (i = 0; i < ARRAY_SIZE(mbc_irq_handlers); i++)
>  		pcf50633_free_irq(mbc->pcf, mbc_irq_handlers[i]);
>  
> +	sysfs_remove_group(&pdev->dev.kobj, &mbc_attr_group);
>  	power_supply_unregister(&mbc->usb);
>  	power_supply_unregister(&mbc->adapter);
>  	power_supply_unregister(&mbc->ac);

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
