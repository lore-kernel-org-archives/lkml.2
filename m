Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934347Ab0HMNPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:15:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47039 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934270Ab0HMNPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:15:35 -0400
Message-ID: <4C654544.5010002@ru.mvista.com>
Date: Fri, 13 Aug 2010 17:14:44 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Maxim Levitsky'" <maximlevitsky@gmail.com>, ben-linux@fluff.org
Subject: Re: undefined reference to `mmc_pm_notify' when selected MMC without
 PM.
References: <009301cb3ad3$77c8a620$6759f260$%kim@samsung.com>
In-Reply-To: <009301cb3ad3$77c8a620$6759f260$%kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Kukjin Kim wrote:

> Following is build error when selected MMC without PM.

> drivers/built-in.o: In function `mmc_alloc_host':
> drivers/mmc/core/host.c:108: undefined reference to `mmc_pm_notify'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [sub-make] Error 2

> That is added from Maxim's ' mmc: fix all hangs related to mmc/sd card
> insert/removal during suspend/resume '
> (commit ID: 4c2ef25fe0b847d2ae818f74758ddb0be1c27d8e)

> Below is temporary patch for avoiding build error.
> But I'm not sure about this... :-(

> ---

> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index 0efe631..d80cfdc 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -86,7 +86,9 @@ struct mmc_host *mmc_alloc_host(int extra, struct device
> *dev)
>         init_waitqueue_head(&host->wq);
>         INIT_DELAYED_WORK(&host->detect, mmc_rescan);
>         INIT_DELAYED_WORK_DEFERRABLE(&host->disable,
> mmc_host_deeper_disable);

    Looks like your patch is line-wrapped...

> +#ifdef CONFIG_PM
>         host->pm_notify.notifier_call = mmc_pm_notify;
> +#endif

WBR, Sergei

