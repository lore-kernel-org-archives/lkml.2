Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab1IAGCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 02:02:39 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:53123 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab1IAGCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 02:02:35 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.13 with qID p8162SIh013342, This message is released by code: ctlocs8528
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1314807479-1552-1-git-send-email-hayeswang@realtek.com> <20110831191344.GA24634@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next 1/3] r8169: fix WOL setting for 8105 and 8111EVL
Date: Thu, 1 Sep 2011 14:02:28 +0800
X-BOX-Message-Id: p8162SIh013342
Message-ID: <89F823C255D94E19BB78C69C1996025C@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcxoFKPFq0QFeNFwS3aDttbDyVA/SgAWAWGw
In-Reply-To: <20110831191344.GA24634@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Thursday, September 01, 2011 3:14 AM
> To: Hayeswang
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next 1/3] r8169: fix WOL setting for 
> 8105 and 8111EVL
> 
> Hayes Wang <hayeswang@realtek.com> :
> > 8105, 8111E, and 8111EVL need enable RxConfig bit 1 ~ 3 for 
> supporting 
> > wake on lan.
> [...]
> > diff --git a/drivers/net/ethernet/realtek/r8169.c 
> > b/drivers/net/ethernet/realtek/r8169.c
> > index 1cf8c3c..96e003a 100644
> > --- a/drivers/net/ethernet/realtek/r8169.c
> > +++ b/drivers/net/ethernet/realtek/r8169.c
> > @@ -3416,8 +3416,11 @@ static void 
> r8168_pll_power_down(struct rtl8169_private *tp)
> >  		rtl_writephy(tp, 0x1f, 0x0000);
> >  		rtl_writephy(tp, MII_BMCR, 0x0000);
> >  
> > -		if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
> > -		    tp->mac_version == RTL_GIGA_MAC_VER_33)
> > +		if (tp->mac_version == RTL_GIGA_MAC_VER_29 ||
> > +		    tp->mac_version == RTL_GIGA_MAC_VER_30 ||
> > +		    tp->mac_version == RTL_GIGA_MAC_VER_32 ||
> > +		    tp->mac_version == RTL_GIGA_MAC_VER_33 ||
> > +		    tp->mac_version == RTL_GIGA_MAC_VER_34)
> >  			RTL_W32(RxConfig, RTL_R32(RxConfig) | 
> AcceptBroadcast |
> >  				AcceptMulticast | AcceptMyPhys);
> 
> Fine for RTL_GIGA_MAC_VER_34 but RTL_GIGA_MAC_VER_29 and 
> RTL_GIGA_MAC_VER_29 use r810x_pll_power_{up/down}, not their 
> r8168_pll_xyz siblings.
> 

I would fix it. Thanks.
 
Best Regards,
Hayes

