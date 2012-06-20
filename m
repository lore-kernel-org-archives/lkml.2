Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab2FTAq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 20:46:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:58168 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750831Ab2FTAqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 20:46:25 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18i6msECrAiSrhjQ1McvdN8ZefIx0z/uQD7fRkZOO
	4iQqXSsZGsjLIu
Message-ID: <4FE11D60.9040109@gmx.de>
Date: Wed, 20 Jun 2012 00:46:24 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120506 Icedove/3.0.11
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Olof Johansson'" <olof@lixom.net>
Subject: Re: [PATCH] video: exynos_dp: fix build warning due to uninitialized
 value
References: <001501cd4de5$d955a290$8c00e7b0$%han@samsung.com>
In-Reply-To: <001501cd4de5$d955a290$8c00e7b0$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On 06/19/2012 06:36 AM, Jingoo Han wrote:
> This patch fixes build warning due to uninitialized value dereference.
> 
> drivers/video/exynos/exynos_dp_core.c: In function 'exynos_dp_set_link_train':
> drivers/video/exynos/exynos_dp_core.c:529:18: warning: 'reg' may be used uninitialized in this function [-Wuninitialized]
> drivers/video/exynos/exynos_dp_core.c:395:6: note: 'reg' was declared here
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/exynos/exynos_dp_core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
> index a36b2d2..9b2cdff 100644
> --- a/drivers/video/exynos/exynos_dp_core.c
> +++ b/drivers/video/exynos/exynos_dp_core.c
> @@ -407,6 +407,8 @@ static unsigned int exynos_dp_get_lane_link_training(
>  	case 3:
>  		reg = exynos_dp_get_lane3_link_training(dp);
>  		break;
> +	default:
> +		return -EINVAL;

Why do you consider returning -EINVAL here a good idea? As far as I can
see the caller does not check the return value for an error condition
and I doubt that the hardware understands what -EINVAL means. If you
want to fix the warning, make sure that you don't hide actual errors,
add an WARN or BUG or make sure the error code makes it to userspace.

>  	}
>  
>  	return reg;


Best regards,

Florian Tobias Schandinat
