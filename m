Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab2GIKaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:30:06 -0400
Received: from void.printf.net ([89.145.121.20]:54987 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112Ab2GIKaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:30:00 -0400
From: Chris Ball <cjb@laptop.org>
To: "Liu\, Chuansheng" <chuansheng.liu@intel.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "Yanmin Zhang \<yanmin_zhang\@linux.intel.com\>
	\(yanmin_zhang\@linux.intel.com\)" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] sdio: Change pr_warning to pr_warn_ratelimited
References: <27240C0AC20F114CBF8149A2696CBE4A0DD517@SHSMSX101.ccr.corp.intel.com>
Date: Mon, 09 Jul 2012 06:29:52 -0400
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A0DD517@SHSMSX101.ccr.corp.intel.com>
	(Chuansheng Liu's message of "Thu, 14 Jun 2012 10:49:17 +0000")
Message-ID: <87mx39ut0f.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 14 2012, Liu, Chuansheng wrote:
> From: liu chuansheng <chuansheng.liu@intel.com>
> Subject: [PATCH] sdio: Change pr_warning to pr_warn_ratelimited
>
> When debug one bad issue, got lots of pr_warning messages
> "queuing unknown CIS tuple" which caused the printk storm
> and flooded the console.
>
> This patch is changing the pr_warning api to pr_warn_ratelimited.
>
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  drivers/mmc/core/sdio_cis.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
> index f1c7ed8..8e94e55 100644
> --- a/drivers/mmc/core/sdio_cis.c
> +++ b/drivers/mmc/core/sdio_cis.c
> @@ -313,7 +313,7 @@ static int sdio_read_cis(struct mmc_card *card, struct sdio_func *func)
>  
>                         if (ret == -ENOENT) {
>                                 /* warn about unknown tuples */
> -                               pr_warning("%s: queuing unknown"
> +                               pr_warn_ratelimited("%s: queuing unknown"
>                                        " CIS tuple 0x%02x (%u bytes)\n",
>                                        mmc_hostname(card->host),
>                                        tpl_code, tpl_link);

Thanks, pushed to mmc-next for 3.6.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
