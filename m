Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab3AJICK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:02:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53493 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550Ab3AJICJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:02:09 -0500
Date: Thu, 10 Jan 2013 00:02:08 -0800 (PST)
Message-Id: <20130110.000208.2040524620441942742.davem@davemloft.net>
To: bh74.an@samsung.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        peppe.cavallaro@st.com, jeffrey.t.kirsher@intel.com,
        kgene.kim@samsung.com
Subject: Re: [PATCH v2 3/3] net: stmmac: add gmac autonego set for ethtool
 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <000601cdedf8$5d39bdf0$17ad39d0$@samsung.com>
References: <000601cdedf8$5d39bdf0$17ad39d0$@samsung.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Byungho An <bh74.an@samsung.com>
Date: Tue, 08 Jan 2013 15:32:02 -0800

> @@ -348,6 +349,10 @@ stmmac_set_pauseparam(struct net_device *netdev,
>  
>  	if (phy->autoneg) {
>  		if (netif_running(netdev))
> +			if((interface == PHY_INTERFACE_MODE_SGMII) ||
> +				(interface == PHY_INTERFACE_MODE_TBI) ||
> +				(interface == PHY_INTERFACE_MODE_RTBI)) 
> +				priv->hw->mac->set_autoneg(priv->ioaddr);

This is improperly indented and formatted, use this style:

	if (A ||
	    B ||
	    C)
		statement();

I can tell what you're trying to do, you are just trying to use TAB
characters exclusivly to indent because you are lazy.  But that's not
the objective here.
