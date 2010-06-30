Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab0F3TFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 15:05:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58858
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757163Ab0F3TFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 15:05:37 -0400
Date: Wed, 30 Jun 2010 12:05:51 -0700 (PDT)
Message-Id: <20100630.120551.170116973.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-06-30
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100630185319.GA2618@tuxdriver.com>
References: <20100630185319.GA2618@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 30 Jun 2010 14:53:20 -0400

> Here are a few more fixes intended for 2.6.35.  Included are a couple of
> small regression fixes for iwlwifi, one that causes connection stalls with
> 802.11n on some devices and another which could disable multicast traffic.
> Also included is an ath9k fix which avoids a null pointer dereference
> resulting from a timer leak.
> 
> Please let me know if there are problems!
...
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Pulled, thanks John.

> @@ -1329,6 +1328,12 @@ void iwl_configure_filter(struct ieee80211_hw *hw,
>  
>  	mutex_unlock(&priv->mutex);
>  
> +	/*
> +	 * Receiving all multicast frames is always enabled by the
> +	 * default flags setup in iwl_connection_init_rx_config()
> +	 * since we currently do not support programming multicast
> +	 * filters into the device.
> +	 */
>  	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
>  			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;

Note that this is an amazingly serious limitation.

This basically makes iwl chips unsuitable for use on networks where
real multicast use is common.
