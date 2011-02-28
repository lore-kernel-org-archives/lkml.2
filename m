Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1B1Sb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:31:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37814 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab1B1Sb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:31:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VIXVkSq/4l5ax54nT02VUVVPR/NnvhSQNKMRGRRKvAGKn9ItODOMd0Hyaqa5kPZtxL
         J0d9KmaJPgCmgObEBj85Pq2zRXDYjlkZ1pAbXkFK7dYhUOmy5ltmg5Gadh+zW2rd+sa9
         2YrDpL1UY+BZuYAQ1LgnpiRkpSrhQscqanR5Y=
Message-ID: <4D6BEA16.2060604@lwfinger.net>
Date: Mon, 28 Feb 2011 12:31:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alessio Igor Bogani <abogani@kernel.org>,
        John Linville <linville@tuxdriver.com>
CC: Dan Carpenter <error27@gmail.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH] rtlwifi: fix places where uninitialized data is used
References: <20110228003734.GA9075@bicker> <1298880715-4286-1-git-send-email-abogani@kernel.org>
In-Reply-To: <1298880715-4286-1-git-send-email-abogani@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2011 02:11 AM, Alessio Igor Bogani wrote:
> drivers/net/wireless/rtlwifi/rtl8192ce/trx.c: In function ‘rtl92ce_rx_query_desc’:
> drivers/net/wireless/rtlwifi/rtl8192ce/trx.c:255:5: warning: ‘rf_rx_num’ may be used uninitialized in this function
> drivers/net/wireless/rtlwifi/rtl8192ce/trx.c:257:12: warning: ‘total_rssi’ may be used uninitialized in this function
> drivers/net/wireless/rtlwifi/rtl8192ce/trx.c:466:6: warning: ‘weighting’ may be used uninitialized in this function
>
> This work was supported by a hardware donation from the CE Linux Forum.
>
> Signed-off-by: Alessio Igor Bogani<abogani@kernel.org>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
> index bf5852f..593eb8e 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
> @@ -252,9 +252,9 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
>   	struct phy_sts_cck_8192s_t *cck_buf;
>   	s8 rx_pwr_all, rx_pwr[4];
> -	u8 rf_rx_num, evm, pwdb_all;
> +	u8 evm, pwdb_all, rf_rx_num = 0;
>   	u8 i, max_spatial_stream;
> -	u32 rssi, total_rssi;
> +	u32 rssi, total_rssi = 0;
>   	bool is_cck_rate;
>
>   	is_cck_rate = RX_HAL_IS_CCK_RATE(pdesc);
> @@ -463,7 +463,7 @@ static void _rtl92ce_update_rxsignalstatistics(struct ieee80211_hw *hw,
>   					       struct rtl_stats *pstats)
>   {
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
> -	int weighting;
> +	int weighting = 0;
>
>   	if (rtlpriv->stats.recv_signal_power == 0)
>   		rtlpriv->stats.recv_signal_power = pstats->recvsignalpower;

ACK. Obviously gcc 4.5.1 has a bug and misses these, whereas 4.5.2 finds them.

Larry
