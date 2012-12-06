Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965245Ab2LFVlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 16:41:40 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:54104 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab2LFVlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 16:41:39 -0500
Message-ID: <1354830114.18211.4.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH wireless-next] iwlwifi: iwlagn_request_scan: Fix check
 for NULL priv->scan_request
From: Johannes Berg <johannes@sipsolutions.net>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Don Fry <donald.h.fry@intel.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date: Thu, 06 Dec 2012 22:41:54 +0100
In-Reply-To: <1354825445-79551-1-git-send-email-tim.gardner@canonical.com> (sfid-20121206_214912_422543_9C67DD48)
References: <1354825445-79551-1-git-send-email-tim.gardner@canonical.com>
	 (sfid-20121206_214912_422543_9C67DD48)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> --- a/drivers/net/wireless/iwlwifi/dvm/scan.c
> +++ b/drivers/net/wireless/iwlwifi/dvm/scan.c
> @@ -673,8 +673,9 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>  	const u8 *ssid = NULL;
>  	u8 ssid_len = 0;
>  
> -	if (WARN_ON_ONCE(priv->scan_request &&
> -			 priv->scan_request->n_channels > MAX_SCAN_CHANNEL))
> +	if (WARN_ON(priv->scan_type == IWL_SCAN_NORMAL &&
> +		(!priv->scan_request ||
> +		priv->scan_request->n_channels > MAX_SCAN_CHANNEL)))
>  		return -EINVAL;

I'll pick it up if you fix the indentation :P

johannes

