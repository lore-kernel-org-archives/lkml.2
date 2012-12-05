Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2LEIND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 03:13:03 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:11298 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab2LEINA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 03:13:00 -0500
Message-ID: <50BF0209.9080207@bfs.de>
Date: Wed, 05 Dec 2012 09:12:57 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Cyril Roelandt <tipecaml@gmail.com>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, yongjun_wei@trendmicro.com.cn,
        jim.cromie@gmail.com, marcos.souza.org@gmail.com,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: rtl8712: avoid a useless call to memset().
References: <1354670522-27144-1-git-send-email-tipecaml@gmail.com>
In-Reply-To: <1354670522-27144-1-git-send-email-tipecaml@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyril,
you patch is correct ..but being an advocate of defensive programming
i would say the original version especially since the number of bytes is small.

re,
 wh

Am 05.12.2012 02:22, schrieb Cyril Roelandt:
> In r8711_wx_get_wap(), make sure we do not call memcpy() on a memory area that
> has just been zeroed by a call to memset().
> 
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> ---
>  drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> index 3a64790..2c73319 100644
> --- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> +++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> @@ -1131,10 +1131,11 @@ static int r8711_wx_get_wap(struct net_device *dev,
>  	struct ndis_wlan_bssid_ex *pcur_bss = &pmlmepriv->cur_network.network;
>  
>  	wrqu->ap_addr.sa_family = ARPHRD_ETHER;
> -	memset(wrqu->ap_addr.sa_data, 0, ETH_ALEN);
>  	if (check_fwstate(pmlmepriv, _FW_LINKED |
>  	    WIFI_ADHOC_MASTER_STATE|WIFI_AP_STATE)) {
>  		memcpy(wrqu->ap_addr.sa_data, pcur_bss->MacAddress, ETH_ALEN);
> +	} else {
> +		memset(wrqu->ap_addr.sa_data, 0, ETH_ALEN);
>  	}
>  	return 0;
>  }
