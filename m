Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1BIAj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 19:39:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56634
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755036Ab1BIAjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 19:39:54 -0500
Date: Tue, 08 Feb 2011 16:40:30 -0800 (PST)
Message-Id: <20110208.164030.242137610.davem@davemloft.net>
To: toshiharu-linux@dsn.okisemi.com
Cc: netdev@vger.kernel.org, tomoya-linux@dsn.okisemi.com, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pch_gbe: Fix the issue which a driver locks when rx
 offload is set by ethtool
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D512A27.2030406@dsn.okisemi.com>
References: <4D512A27.2030406@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Date: Tue, 08 Feb 2011 20:33:59 +0900

> @@ -531,12 +533,8 @@ void pch_gbe_reinit_locked(struct pch_gbe_adapter *adapter)
>  {
>  	struct net_device *netdev = adapter->netdev;
>  
> -	rtnl_lock();
> -	if (netif_running(netdev)) {
> -		pch_gbe_down(adapter);
> -		pch_gbe_up(adapter);
> -	}
> -	rtnl_unlock();
> +	pch_gbe_down(adapter);
> +	pch_gbe_up(adapter);

Are you sure you can just blindly delete the netif_running() check here?
