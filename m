Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1EIQC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:02:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52982 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab1EIQCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:02:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iyQStn4opz/fQFBit0xN9YxWj1JF7etF3Yqgm7gbYg08p6gpSvHbeFqmKwNDy+dJdn
         kxuILzaVx3Vr5MEhWDtRz5OFUfHHvw8V/RgD6n1HtmGerQfY63VqCb3TUDjziZdeSOl3
         4HX2gCfONxs9hZS+0DjKoDyfECCYOmkocgAhE=
Message-ID: <4DC81009.5060501@lwfinger.net>
Date: Mon, 09 May 2011 11:02:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Fix memset using sizeof(ptr) not
 sizeof(*ptr)
References: <1304919832.19586.15.camel@Joe-Laptop>
In-Reply-To: <1304919832.19586.15.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2011 12:43 AM, Joe Perches wrote:
> Found via coccinelle script
>
> @@
> type T;
> T* ptr;
> expression E1;
> @@
>
> * memset(E1, 0, sizeof(ptr));
>
> Signed-off-by: Joe Perches<joe@perches.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
> index 79c98f6..c16fc1c 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
> @@ -372,7 +372,7 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
>   	__le16 fc;
>   	struct ieee80211_hdr *hdr;
>
> -	memset(rx_status, 0, sizeof(rx_status));
> +	memset(rx_status, 0, sizeof(*rx_status));
>   	rxdesc	= skb->data;
>   	skb_len	= skb->len;
>   	drvinfo_len = (GET_RX_DESC_DRVINFO_SIZE(rxdesc) * RTL_RX_DRV_INFO_UNIT);

ACK.

Larry
