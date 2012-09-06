Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2IFCPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 22:15:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:35219 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab2IFCPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 22:15:11 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7fd26d000002b62-ea-5048072eab2c
Message-id: <5048072F.3020602@samsung.com>
Date: Thu, 06 Sep 2012 11:15:11 +0900
From: =?UTF-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827
 Thunderbird/15.0
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Inki Dae <inki.dae@samsung.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>,
        Pawel Osciak <posciak@google.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/exynos: fix double call of
 drm_prime_(init/destroy)_file_private
References: <1346881623-388-1-git-send-email-msb@chromium.org>
In-reply-to: <1346881623-388-1-git-send-email-msb@chromium.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQV09do8Ag94fghaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSujo7uHuWCdUEXbus9sDYwt/F2MHBwSAiYS1x5ndjFyApliEhfu
	rWfrYuTiEBKYzihx+eI0ZpAEr4CgxI/J91hA6pkF5CWOXMoGCTMLqEtMmreIGaK+i0ni0uZj
	UPVaEuvP3wWzWQRUJU7/38UGYrMJmEt0frwEZgsJKEhcmXiMHcQWFQiRWDL3K5gtIqAtsenP
	TEaQocwCR5gkPvQ9YQFJCAtES7Sv6mWGaLaT+HjgLSuIzSlgLzFn4WbGCYyCs5DcOgvh1llI
	bl3AyLyKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgsn0ntYFzZYHGIUYCDUYmH91e+e4AQ
	a2JZcWXuIUYJDmYlEd5PT4BCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZ3O2QUICaQnlqRmp6YW
	pBbBZJk4OKUaGN16lzdePPBG4+cll5WJZneeWYqsC36s+q1ewu79A17VMywH93QviYoQa5o2
	fUZXv9yq+9ON6lwvvZrKp+LxQPbzsTv75wZ35u/Rd3fawnX59pnMTdl3foSxNv5gXbBFRalz
	7n4pc6fnAs27CxvvnzV48KRvw8wVnmq5Gzk21PQs7VH01V3FskCJpTgj0VCLuag4EQBYWO+z
	RwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mandeep,

On 2012년 09월 06일 06:47, Mandeep Singh Baines wrote:
> The double invocations are incorrect but seem to be safe so I don't
> think this will fix any bugs.
> 
> Before:
> 
> [    7.639366] drm_prime_init_file ee3675d0
> [    7.639377] drm_prime_init_file ee3675d0
> [    7.639507] drm_prime_destroy_file ee3675d0
> [    7.639518] drm_prime_destroy_file ee3675d0
> [    7.639802] drm_prime_init_file ee372390
> [    7.639810] drm_prime_init_file ee372390
> [    8.473316] drm_prime_init_file ee356390
> [    8.473331] drm_prime_init_file ee356390
> 
> After:
> 
> [    6.363842] drm_prime_init_file edc2e5d0
> [    6.363994] drm_prime_destroy_file edc2e5d0
> [    6.364260] drm_prime_init_file edc2e750
> [    8.004837] drm_prime_init_file ee36ded0
> 

You are right. prime file_priv is handled by drm_fops.c, so it can be
removed from exynos drm.

Thanks for your patch.

> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> CC: Stéphane Marchesin <marcheu@chromium.org>
> CC: Pawel Osciak <posciak@google.com>
> CC: Inki Dae <inki.dae@samsung.com>
> CC: Joonyoung Shim <jy0922.shim@samsung.com>
> CC: Seung-Woo Kim <sw0312.kim@samsung.com>
> CC: Kyungmin Park <kyungmin.park@samsung.com>
> CC: David Airlie <airlied@linux.ie>
> CC: dri-devel@lists.freedesktop.org

Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>

> ---
>  drivers/gpu/drm/exynos/exynos_drm_drv.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> index ebacec6..a27b8ff 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> @@ -160,7 +160,6 @@ static int exynos_drm_open(struct drm_device *dev, struct drm_file *file)
>  	if (!file_priv)
>  		return -ENOMEM;
>  
> -	drm_prime_init_file_private(&file->prime);
>  	file->driver_priv = file_priv;
>  
>  	return exynos_drm_subdrv_open(dev, file);
> @@ -184,7 +183,6 @@ static void exynos_drm_preclose(struct drm_device *dev,
>  			e->base.destroy(&e->base);
>  		}
>  	}
> -	drm_prime_destroy_file_private(&file->prime);
>  	spin_unlock_irqrestore(&dev->event_lock, flags);
>  
>  	exynos_drm_subdrv_close(dev, file);
> 

-- 
Seung-Woo Kim
Samsung Software R&D Center
--

