Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2FXVAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 17:00:25 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:48722 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753409Ab2FXVAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 17:00:13 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+FPY1OtmGFFeKBfmWvwX4Y9LDwr2259U3Vrx2ROu
	q8y8JaFx1GxZuS
Message-ID: <4FE77FDC.9090004@gmx.de>
Date: Sun, 24 Jun 2012 21:00:12 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120506 Icedove/3.0.11
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Olof Johansson'" <olof@lixom.net>
Subject: Re: [PATCH v2] video: exynos_dp: fix build warning due to uninitialized
 value
References: <000301cd4e83$9f5fcb30$de1f6190$%han@samsung.com>
In-Reply-To: <000301cd4e83$9f5fcb30$de1f6190$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 01:25 AM, Jingoo Han wrote:
> This patch fixes build warning due to uninitialized value dereference.
> 
> drivers/video/exynos/exynos_dp_core.c: In function 'exynos_dp_set_link_train':
> drivers/video/exynos/exynos_dp_core.c:529:18: warning: 'reg' may be used uninitialized in this function [-Wuninitialized]
> drivers/video/exynos/exynos_dp_core.c:395:6: note: 'reg' was declared here
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/exynos/exynos_dp_core.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
> index a36b2d2..9db7b9f 100644
> --- a/drivers/video/exynos/exynos_dp_core.c
> +++ b/drivers/video/exynos/exynos_dp_core.c
> @@ -407,6 +407,9 @@ static unsigned int exynos_dp_get_lane_link_training(
>  	case 3:
>  		reg = exynos_dp_get_lane3_link_training(dp);
>  		break;
> +	default:
> +		WARN_ON(1);
> +		return 0;
>  	}
>  
>  	return reg;

