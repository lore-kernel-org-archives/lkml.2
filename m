Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab1HaUQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 16:16:54 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:35960 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab1HaUQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 16:16:53 -0400
X-Greylist: delayed 2677 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Aug 2011 16:16:52 EDT
Date: Wed, 31 Aug 2011 21:13:44 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] r8169: fix WOL setting for 8105 and 8111EVL
Message-ID: <20110831191344.GA24634@electric-eye.fr.zoreil.com>
References: <1314807479-1552-1-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314807479-1552-1-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> 8105, 8111E, and 8111EVL need enable RxConfig bit 1 ~ 3 for supporting
> wake on lan.
[...]
> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
> index 1cf8c3c..96e003a 100644
> --- a/drivers/net/ethernet/realtek/r8169.c
> +++ b/drivers/net/ethernet/realtek/r8169.c
> @@ -3416,8 +3416,11 @@ static void r8168_pll_power_down(struct rtl8169_private *tp)
>  		rtl_writephy(tp, 0x1f, 0x0000);
>  		rtl_writephy(tp, MII_BMCR, 0x0000);
>  
> -		if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
> -		    tp->mac_version == RTL_GIGA_MAC_VER_33)
> +		if (tp->mac_version == RTL_GIGA_MAC_VER_29 ||
> +		    tp->mac_version == RTL_GIGA_MAC_VER_30 ||
> +		    tp->mac_version == RTL_GIGA_MAC_VER_32 ||
> +		    tp->mac_version == RTL_GIGA_MAC_VER_33 ||
> +		    tp->mac_version == RTL_GIGA_MAC_VER_34)
>  			RTL_W32(RxConfig, RTL_R32(RxConfig) | AcceptBroadcast |
>  				AcceptMulticast | AcceptMyPhys);

Fine for RTL_GIGA_MAC_VER_34 but RTL_GIGA_MAC_VER_29 and RTL_GIGA_MAC_VER_29
use r810x_pll_power_{up/down}, not their r8168_pll_xyz siblings.

-- 
Ueimor
