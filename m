Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab1FCDHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 23:07:47 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62730 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab1FCDHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 23:07:45 -0400
Date: Fri, 3 Jun 2011 00:07:46 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Cc: sgruszka@redhat.com, linville@tuxdriver.com,
        kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] iwlegacy: add missing null check
Message-ID: <20110603030746.GA4834@joana>
Mail-Followup-To: Greg Dietsche <Gregory.Dietsche@cuw.edu>,
	sgruszka@redhat.com, linville@tuxdriver.com,
	kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1307066770-27309-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <1307066770-27309-5-git-send-email-Gregory.Dietsche@cuw.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307066770-27309-5-git-send-email-Gregory.Dietsche@cuw.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

* Greg Dietsche <Gregory.Dietsche@cuw.edu> [2011-06-02 21:06:10 -0500]:

> lq_sta has other null checks in this funcion.
> assuming they are correct, this additional null check
> should be added too.
> 
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
> ---
>  drivers/net/wireless/iwlegacy/iwl-4965-rs.c |   66 ++++++++++++++-------------
>  1 files changed, 34 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
> index 24d1499..a475aac 100644
> --- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
> +++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
> @@ -2275,40 +2275,42 @@ iwl4965_rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
>  	if (rate_control_send_low(sta, priv_sta, txrc))
>  		return;
>  
> -	rate_idx  = lq_sta->last_txrate_idx;
> -
> -	if (lq_sta->last_rate_n_flags & RATE_MCS_HT_MSK) {
> -		rate_idx -= IWL_FIRST_OFDM_RATE;
> -		/* 6M and 9M shared same MCS index */
> -		rate_idx = (rate_idx > 0) ? (rate_idx - 1) : 0;
> -		if (iwl4965_rs_extract_rate(lq_sta->last_rate_n_flags) >=
> -			 IWL_RATE_MIMO2_6M_PLCP)
> -			rate_idx = rate_idx + MCS_INDEX_PER_STREAM;
> -		info->control.rates[0].flags = IEEE80211_TX_RC_MCS;
> -		if (lq_sta->last_rate_n_flags & RATE_MCS_SGI_MSK)
> -			info->control.rates[0].flags |=
> -					IEEE80211_TX_RC_SHORT_GI;
> -		if (lq_sta->last_rate_n_flags & RATE_MCS_DUP_MSK)
> -			info->control.rates[0].flags |=
> -					IEEE80211_TX_RC_DUP_DATA;
> -		if (lq_sta->last_rate_n_flags & RATE_MCS_HT40_MSK)
> -			info->control.rates[0].flags |=
> -					IEEE80211_TX_RC_40_MHZ_WIDTH;
> -		if (lq_sta->last_rate_n_flags & RATE_MCS_GF_MSK)
> -			info->control.rates[0].flags |=
> -					IEEE80211_TX_RC_GREEN_FIELD;
> -	} else {
> -		/* Check for invalid rates */
> -		if ((rate_idx < 0) || (rate_idx >= IWL_RATE_COUNT_LEGACY) ||
> -				((sband->band == IEEE80211_BAND_5GHZ) &&
> -				 (rate_idx < IWL_FIRST_OFDM_RATE)))
> -			rate_idx = rate_lowest_index(sband, sta);
> -		/* On valid 5 GHz rate, adjust index */
> -		else if (sband->band == IEEE80211_BAND_5GHZ)
> +	if (lq_sta) {

Then do
	if (!lq_sta)
		return;

to avoid an exatra level of indentation.

-- 
Gustavo F. Padovan
http://profusion.mobi
