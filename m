Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab0LVAFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:05:51 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:32931 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0LVAFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:05:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y2ilScR0w1HTrlf8n6P5WOMmBfBL8DpTt+6jVKoGIGCkoElAw6imITDb4Zthy/aWwB
         gyqAN8SoeutXHYvmqzl46JK75HCo6V98EtnJgBFrtzo+OAaqTjq5Z4YQe0eodtFQGPwU
         JuBkQ6VE58o+gT0Zulv3JqqMk5ICDzz+WFj6Q=
Date: Wed, 22 Dec 2010 03:05:45 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: power_supply_core: fix use after free and
 memory leak
Message-ID: <20101222000545.GC24834@oksana.dev.rtsoft.ru>
References: <1290192119-11704-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1290192119-11704-1-git-send-email-segoon@openwall.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 09:41:58PM +0300, Vasiliy Kulikov wrote:
> device_unregister() might free its argument.  This leads to freed
> memory use in kfree().  Also use put_device() instead of kfree()
> as dev may be already used in another layer after call to device_add().
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Applied, thanks!

> ---
>  Compile tested only.
> 
>  drivers/power/power_supply_core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
> index 91606bb..f06bad0 100644
> --- a/drivers/power/power_supply_core.c
> +++ b/drivers/power/power_supply_core.c
> @@ -190,10 +190,10 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
>  	goto success;
>  
>  create_triggers_failed:
> -	device_unregister(psy->dev);
> +	device_del(dev);
>  kobject_set_name_failed:
>  device_add_failed:
> -	kfree(dev);
> +	put_device(dev);
>  success:
>  	return rc;
>  }
> -- 
> 1.7.0.4

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
