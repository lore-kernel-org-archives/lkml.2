Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab2HXFxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 01:53:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59249 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab2HXFxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 01:53:11 -0400
Message-ID: <503716C2.40202@lwfinger.net>
Date: Fri, 24 Aug 2012 00:53:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: florian.c.schilhabel@googlemail.com, gregkh@linuxfoundation.org,
        yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: r8712u: rtl871x_mlme.c: use is_zero_ether_addr()
 instead of memcmp()
References: <CAPgLHd8CQw+Px-AMOKuk8Ji-FuBuaM=FCpa+apggPwJx=+B33w@mail.gmail.com>
In-Reply-To: <CAPgLHd8CQw+Px-AMOKuk8Ji-FuBuaM=FCpa+apggPwJx=+B33w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 12:29 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Using is_zero_ether_addr() instead of directly use
> memcmp() to determine if the ethernet address is
> all zeros.
>
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/staging/rtl8712/rtl871x_mlme.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

>
> diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
> index dc7adc1..c51ad9e 100644
> --- a/drivers/staging/rtl8712/rtl871x_mlme.c
> +++ b/drivers/staging/rtl8712/rtl871x_mlme.c
> @@ -28,6 +28,8 @@
>
>   #define _RTL871X_MLME_C_
>
> +#include <linux/etherdevice.h>
> +
>   #include "osdep_service.h"
>   #include "drv_types.h"
>   #include "recv_osdep.h"
> @@ -146,9 +148,8 @@ static struct wlan_network *_r8712_find_network(struct  __queue *scanned_queue,
>   	unsigned long irqL;
>   	struct list_head *phead, *plist;
>   	struct wlan_network *pnetwork = NULL;
> -	u8 zero_addr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
>
> -	if (!memcmp(zero_addr, addr, ETH_ALEN))
> +	if (is_zero_ether_addr(addr))
>   		return NULL;
>   	spin_lock_irqsave(&scanned_queue->lock, irqL);
>   	phead = get_list_head(scanned_queue);
>
>
>

