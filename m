Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab1IHKzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 06:55:18 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35949 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758153Ab1IHKzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 06:55:16 -0400
X-Sasl-enc: ZXZ0g1uYZOrjRxfHGuBW6YWq2uTBk1mLGkYA7oYh/YLh 1315479315
Message-ID: <4E689F2D.9030201@ladisch.de>
Date: Thu, 08 Sep 2011 12:55:41 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Corey Minyard <minyard@acm.org>, Mark Gross <mark.gross@intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>,
        openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH 31/62] driver/char: irq: Remove IRQF_DISABLED
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-32-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1315383059-3673-32-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Zhang wrote:
> This flag is a NOOP and can be removed now.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
>  drivers/char/hpet.c              |    2 +-
> ...
> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> index 0833896..10f3f04 100644
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -500,7 +500,7 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
>  
>  		sprintf(devp->hd_name, "hpet%d", (int)(devp - hpetp->hp_dev));
>  		irq_flags = devp->hd_flags & HPET_SHARED_IRQ
> -						? IRQF_SHARED : IRQF_DISABLED;
> +						? IRQF_SHARED : 0;
>  		if (request_irq(irq, hpet_interrupt, irq_flags,
>  				devp->hd_name, (void *)devp)) {
>  			printk(KERN_ERR "hpet: IRQ %d is not free\n", irq);
> ...

Acked-by: Clemens Ladisch <clemens@ladisch.de>


Regards,
Clemens
