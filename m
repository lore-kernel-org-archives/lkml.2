Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab0IWK5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 06:57:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47545 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0IWK5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 06:57:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KQ6WMyu+8edWuMQZ0gu3o33oKejATW5/flbqsa3OwYzN729aFuG4pk0Xlkq/ERZB+Z
         R2/5Hd+g/5aBGJLvZ3DASWbUhy1g6C22pFn57RBgLyUEX1u3WS0iFQemNrYOth9v3GTR
         LsT06SaiHYXjtWWkgzQAGwHHdmXvXv+9n2PxU=
Date: Thu, 23 Sep 2010 14:57:27 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ds2760_battery: add HAS_IOMEM dependency
Message-ID: <20100923105727.GA22890@oksana.dev.rtsoft.ru>
References: <20100923124445.5309c100@mschwide.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100923124445.5309c100@mschwide.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 12:44:45PM +0200, Martin Schwidefsky wrote:
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Fix this Kconfig warning on allmodconfig for s390:
> 
> warning: (BATTERY_DS2760 && POWER_SUPPLY) selects W1 which has unmet direct dependencies (HAS_IOMEM)
> 
> Cc: Anton Vorontsov <cbou@mail.ru>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
> 
>  drivers/power/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff -urpN linux-2.6/drivers/power/Kconfig linux-2.6-patched/drivers/power/Kconfig
> --- linux-2.6/drivers/power/Kconfig	2010-09-23 08:47:36.000000000 +0200
> +++ linux-2.6-patched/drivers/power/Kconfig	2010-09-23 08:47:39.000000000 +0200
> @@ -64,6 +64,7 @@ config TEST_POWER
>  
>  config BATTERY_DS2760
>  	tristate "DS2760 battery driver (HP iPAQ & others)"
> +	depends on HAS_IOMEM
>  	select W1
>  	select W1_SLAVE_DS2760

I think the better fix would be to turn this into 'depends on W1',
and remove these selects.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
