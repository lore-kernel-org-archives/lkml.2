Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2LEEHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 23:07:20 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35349 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab2LEEHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 23:07:17 -0500
Message-ID: <50BEC867.7090209@lwfinger.net>
Date: Tue, 04 Dec 2012 22:07:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cyril Roelandt <tipecaml@gmail.com>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        florian.c.schilhabel@googlemail.com, gregkh@linuxfoundation.org,
        yongjun_wei@trendmicro.com.cn, jim.cromie@gmail.com,
        marcos.souza.org@gmail.com, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: rtl8712: avoid a useless call to memset().
References: <1354670522-27144-1-git-send-email-tipecaml@gmail.com>
In-Reply-To: <1354670522-27144-1-git-send-email-tipecaml@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2012 07:22 PM, Cyril Roelandt wrote:
> In r8711_wx_get_wap(), make sure we do not call memcpy() on a memory area that
> has just been zeroed by a call to memset().
>
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> ---
>   drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>
> diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> index 3a64790..2c73319 100644
> --- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> +++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> @@ -1131,10 +1131,11 @@ static int r8711_wx_get_wap(struct net_device *dev,
>   	struct ndis_wlan_bssid_ex *pcur_bss = &pmlmepriv->cur_network.network;
>
>   	wrqu->ap_addr.sa_family = ARPHRD_ETHER;
> -	memset(wrqu->ap_addr.sa_data, 0, ETH_ALEN);
>   	if (check_fwstate(pmlmepriv, _FW_LINKED |
>   	    WIFI_ADHOC_MASTER_STATE|WIFI_AP_STATE)) {
>   		memcpy(wrqu->ap_addr.sa_data, pcur_bss->MacAddress, ETH_ALEN);
> +	} else {
> +		memset(wrqu->ap_addr.sa_data, 0, ETH_ALEN);
>   	}
>   	return 0;
>   }
>

