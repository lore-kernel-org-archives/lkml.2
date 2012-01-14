Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2ANOUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 09:20:32 -0500
Received: from void.printf.net ([89.145.121.20]:45364 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab2ANOUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 09:20:31 -0500
From: Chris Ball <cjb@laptop.org>
To: Steven Liu <lingjiujianke@gmail.com>
Cc: linux-mmc@vger.kernel.org, liuqi@thundersoft.com, qinjian@thundersoft.com,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] mmc: fix deadlock from mmc core when suspend the device
References: <CADxeRw=_Qx+dcZHJZnq1tAStvsuCWrsARgyxP=aKC0WfLWHZLw@mail.gmail.com>
Date: Sat, 14 Jan 2012 09:19:44 -0500
In-Reply-To: <CADxeRw=_Qx+dcZHJZnq1tAStvsuCWrsARgyxP=aKC0WfLWHZLw@mail.gmail.com>
	(Steven Liu's message of "Sat, 14 Jan 2012 13:05:08 +0800")
Message-ID: <m2r4z28iyn.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jan 14 2012, Steven Liu wrote:
> Hi Chris Ball & Greg KH,
>
> This patch can fix the mmc deadlock when suspen the mmc devices.
>
> when mmc_pm_notify to do the host->bus_ops->remove, there is deadlock,
> because it was locked at mmc_claim_host, so it modify the mmc_claim_host
> after the host->bus_ops->remove.
> the problem can reproduce at lots of the emmc/sd devices when create
> multi partitions,and I have tested this modify at lots of the platform.
>
> Can this patch fixed?
>
> Signed-off-by: LiuQi <liuqi@thundersoft.com>
> Signed-off-by: Jack Qin <qinjian@thundersoft.com>
>
> ---
>  drivers/mmc/core/core.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 950b97d..e68a0e8 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -2431,11 +2431,10 @@ int mmc_pm_notify(struct notifier_block *notify_block,
>                 if (!host->bus_ops || host->bus_ops->suspend)
>                         break;
>
> -               mmc_claim_host(host);
> -
>                 if (host->bus_ops->remove)
>                         host->bus_ops->remove(host);
>
> +               mmc_claim_host(host);
>                 mmc_detach_bus(host);
>                 mmc_power_off(host);
>                 mmc_release_host(host);

Another version of this patch has already gone to Linus, for 3.3-rc1.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
