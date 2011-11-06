Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1KFWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 17:25:58 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56140 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab1KFWZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 17:25:56 -0500
Message-ID: <4EB70920.80905@linux.vnet.ibm.com>
Date: Mon, 07 Nov 2011 03:54:32 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Bing Zhao <bzhao@marvell.com>
Subject: Re: [PATCH] net, wireless, mwifiex: Fix mem leak in mwifiex_update_curr_bss_params()
References: <alpine.LNX.2.00.1111062255310.5763@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1111062255310.5763@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11110612-9264-0000-0000-0000001990A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 03:28 AM, Jesper Juhl wrote:
> If kmemdup() fails we leak the memory allocated to bss_desc.
> This patch fixes the leak.
> I also removed the pointless default assignment of 'NULL' to 'bss_desc' 
> while I was there anyway.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Looks good to me.
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Thanks,
Srivatsa S. Bhat

> ---
>  drivers/net/wireless/mwifiex/scan.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
>  note: patch is compile tested only since I don't have the hardware.
> 
> diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
> index dae8dbb..8a3f959 100644
> --- a/drivers/net/wireless/mwifiex/scan.c
> +++ b/drivers/net/wireless/mwifiex/scan.c
> @@ -1469,7 +1469,7 @@ mwifiex_update_curr_bss_params(struct mwifiex_private *priv, u8 *bssid,
>  			       s32 rssi, const u8 *ie_buf, size_t ie_len,
>  			       u16 beacon_period, u16 cap_info_bitmap, u8 band)
>  {
> -	struct mwifiex_bssdescriptor *bss_desc = NULL;
> +	struct mwifiex_bssdescriptor *bss_desc;
>  	int ret;
>  	unsigned long flags;
>  	u8 *beacon_ie;
> @@ -1484,6 +1484,7 @@ mwifiex_update_curr_bss_params(struct mwifiex_private *priv, u8 *bssid,
> 
>  	beacon_ie = kmemdup(ie_buf, ie_len, GFP_KERNEL);
>  	if (!beacon_ie) {
> +		kfree(bss_desc);
>  		dev_err(priv->adapter->dev, " failed to alloc beacon_ie\n");
>  		return -ENOMEM;
>  	}

