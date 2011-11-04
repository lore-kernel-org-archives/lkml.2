Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab1KDSUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 14:20:03 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:47416 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752708Ab1KDSUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 14:20:01 -0400
Message-ID: <4EB42CA2.2040000@xenotime.net>
Date: Fri, 04 Nov 2011 11:19:14 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mark Einon <mark.einon@gmail.com>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        gregkh@suse.de
Subject: Re: [PATCH] linux-next: et131x: Fix build error when CONFIG_PM_SLEEP
 not enabled
References: <4EB30C0B.8080200@xenotime.net> <1320429482-2332-1-git-send-email-mark.einon@gmail.com>
In-Reply-To: <1320429482-2332-1-git-send-email-mark.einon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2011 10:58 AM, Mark Einon wrote:
> Randy Dunlap reports that the ex131x driver doesn't build when CONFIG_PM_SLEEP is not enabled.
> This bug was introduced when moving code around to remove some forward declarations earlier, the #endif part of #ifdef CONFIG_PM_SLEEP was not moved at the same time. Now fixed by moving it to its proper place.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Mark Einon <mark.einon@gmail.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/staging/et131x/et131x.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
> index f5f44a0..0c1c6ca 100644
> --- a/drivers/staging/et131x/et131x.c
> +++ b/drivers/staging/et131x/et131x.c
> @@ -4469,6 +4469,12 @@ static int et131x_resume(struct device *dev)
>  	return 0;
>  }
>  
> +static SIMPLE_DEV_PM_OPS(et131x_pm_ops, et131x_suspend, et131x_resume);
> +#define ET131X_PM_OPS (&et131x_pm_ops)
> +#else
> +#define ET131X_PM_OPS NULL
> +#endif
> +
>  /* ISR functions */
>  
>  /**
> @@ -5470,12 +5476,6 @@ err_out:
>  	return result;
>  }
>  
> -static SIMPLE_DEV_PM_OPS(et131x_pm_ops, et131x_suspend, et131x_resume);
> -#define ET131X_PM_OPS (&et131x_pm_ops)
> -#else
> -#define ET131X_PM_OPS NULL
> -#endif
> -
>  static DEFINE_PCI_DEVICE_TABLE(et131x_pci_table) = {
>  	{ PCI_VDEVICE(ATT, ET131X_PCI_DEVICE_ID_GIG), 0UL},
>  	{ PCI_VDEVICE(ATT, ET131X_PCI_DEVICE_ID_FAST), 0UL},


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
