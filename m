Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab2JHBE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 21:04:28 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58861 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2JHBE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 21:04:26 -0400
Message-ID: <50722696.4090100@lwfinger.net>
Date: Sun, 07 Oct 2012 20:04:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: florian.c.schilhabel@googlemail.com, gregkh@linuxfoundation.org,
        yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8712u: fix potential NULL pointer dereference
 in r871x_wps_start()
References: <CAPgLHd8d0v6fjMGJnK2LbRWTyhRh4DQXXNyxWo10=0Y+GVk7FA@mail.gmail.com>
In-Reply-To: <CAPgLHd8d0v6fjMGJnK2LbRWTyhRh4DQXXNyxWo10=0Y+GVk7FA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2012 07:43 PM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> The dereference should be moved below the NULL test.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/staging/rtl8712/rtl871x_ioctl_linux.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>
> diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> index c9a6a7f..3a64790 100644
> --- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> +++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> @@ -2110,10 +2110,10 @@ static int r871x_wps_start(struct net_device *dev,
>   	struct iw_point *pdata = &wrqu->data;
>   	u32   u32wps_start = 0;
>
> -	if (copy_from_user((void *)&u32wps_start, pdata->pointer, 4))
> -		return -EFAULT;
>   	if ((padapter->bDriverStopped) || (pdata == NULL))
>   		return -EINVAL;
> +	if (copy_from_user((void *)&u32wps_start, pdata->pointer, 4))
> +		return -EFAULT;
>   	if (u32wps_start == 0)
>   		u32wps_start = *extra;
>   	if (u32wps_start == 1) /* WPS Start */
>
>

