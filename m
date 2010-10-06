Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab0JFNqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 09:46:32 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54729 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758743Ab0JFNqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 09:46:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WxyjgxHF0jJBsdL1d1i4IDhLrgXfCLFSQIcvA7r88UpG8c4bsLgOW2cRBQyqKoe+8q
         b3rxF4LwovIocLRZ1w/9BYXzzb5HP63mdbCm+PMf3eU0+5M9L1iIIdmeTKnOr1+6G4eu
         hSZlUdRySmm9Z6tt6uy0Gvz6hVTesVxQ1xZS4=
Date: Wed, 6 Oct 2010 17:46:24 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH] drivers/power: add missing kfree(di->bus) in
 bq27x00_battery_remove()
Message-ID: <20101006134624.GB16839@oksana.dev.rtsoft.ru>
References: <1286244334.16819.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1286244334.16819.2.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 10:05:34AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---

Applied, thanks.

>  drivers/power/bq27x00_battery.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index 3ec9c6a..eff0273 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -418,6 +418,7 @@ static int bq27x00_battery_remove(struct i2c_client *client)
>  
>  	power_supply_unregister(&di->bat);
>  
> +	kfree(di->bus);
>  	kfree(di->bat.name);
>  
>  	mutex_lock(&battery_mutex);

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
