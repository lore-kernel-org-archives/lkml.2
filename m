Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0FCNum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:50:42 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:48632 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab0FCNuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:50:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TkinfFiozvwyK61qPuE82deE+7cAXdm4WcaYz6jVUnzwrdwjY7Y0CnMEYc5/x3CrLK
         wERzcEyX/ccLKcVHEdUrn62efeMkWZwKpT+Ezwap5DTuKXBSYW5i1Nj+c80AFDPvvoCu
         umN5VcPaU7Z5yM3HpC5bTsxCPh0EW4DBuzBbU=
Date: Thu, 3 Jun 2010 17:50:31 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc1 ahci regression
Message-ID: <20100603135031.GA9964@oksana.dev.rtsoft.ru>
References: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>
 <20100603075402.GA11093@oksana.dev.rtsoft.ru>
 <AANLkTil6k_4YwdvLai_VUlVjgz030ctu7djVGHu0qgd2@mail.gmail.com>
 <20100603084104.GA17431@oksana.dev.rtsoft.ru>
 <AANLkTilSNOgD1HrvYBMEsza5-IIeBS1U7AHChO1vJKuf@mail.gmail.com>
 <AANLkTima_jbwafiHQsncQzdX04ZcjO_8QIpq5UOohi3x@mail.gmail.com>
 <20100603093923.GA25856@oksana.dev.rtsoft.ru>
 <AANLkTim8TALR8Ev9KDX4tteXUrQ3oKOcnyMHk9WOdUvG@mail.gmail.com>
 <20100603131414.GA23520@oksana.dev.rtsoft.ru>
 <20100603132319.GA4889@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100603132319.GA4889@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 05:23:19PM +0400, Anton Vorontsov wrote:
[...]
> Oh. It seems I found it. It must be the module order loading
> thing.
> 
> Can you try the patch down below?

OTOH... libahci is a link-time dependency. And the order doesn't
matter here. So you should just have the libahci module in
the initrd (actually, mkinitrd or whatever you use should
have included this automatically).

So, normally, this patch should be unnecessary.

> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> index 20c5251..092d9e0 100644
> --- a/drivers/ata/Makefile
> +++ b/drivers/ata/Makefile
> @@ -1,7 +1,7 @@
>  
>  obj-$(CONFIG_ATA)		+= libata.o
>  
> -obj-$(CONFIG_SATA_AHCI)		+= ahci.o libahci.o
> +obj-$(CONFIG_SATA_AHCI)		+= libahci.o ahci.o
>  obj-$(CONFIG_SATA_SVW)		+= sata_svw.o
>  obj-$(CONFIG_ATA_PIIX)		+= ata_piix.o
>  obj-$(CONFIG_SATA_PROMISE)	+= sata_promise.o

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
