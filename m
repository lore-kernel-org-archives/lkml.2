Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965137Ab2CNBvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 21:51:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52561 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab2CNBvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 21:51:08 -0400
Date: Tue, 13 Mar 2012 21:49:50 -0400
From: Andrew Miller <amiller@amilx.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: r8180_core.c: Fix coding style issue
Message-ID: <20120314014949.GB7156@iron>
References: <1331686689-6763-1-git-send-email-amiller@amilx.com>
 <1331688836.27389.13.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331688836.27389.13.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 06:33:56PM -0700, Joe Perches wrote:
> On Tue, 2012-03-13 at 20:58 -0400, Andrew Miller wrote:
> > Fix long line coding style issue
> > Signed-off-by: Andrew Miller <amiller@amilx.com>
Thanks for the review

I think I starting to get the idea of what I need to be looking for.

> 
> Hi Andrew.
> 
> Please strive for clarity instead of just fixing
> random 80 char warnings.
> 
> > diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
> []
> > @@ -1607,17 +1609,20 @@ void rtl8180_rx(struct net_device *dev)
> >  		/* printk("==========================>rx : RXAGC is %d,signalstrength is %d\n",RXAGC,stats.signalstrength); */
> >  		stats.rssi = priv->wstats.qual.qual = priv->SignalQuality;
> >  		stats.noise = priv->wstats.qual.noise = 100 - priv->wstats.qual.qual;
> > -		bHwError = (((*(priv->rxringtail)) & (0x00000fff)) == 4080) | (((*(priv->rxringtail)) & (0x04000000)) != 0)
> > -			| (((*(priv->rxringtail)) & (0x08000000)) != 0) | (((~(*(priv->rxringtail))) & (0x10000000)) != 0) | (((~(*(priv->rxringtail))) & (0x20000000)) != 0);
> > +		bHwError = (((*(priv->rxringtail)) & (0x00000fff)) == 4080) |
> > +			   (((*(priv->rxringtail)) & (0x04000000)) != 0) |
> > +			   (((*(priv->rxringtail)) & (0x08000000)) != 0) |
> > +			   (((~(*(priv->rxringtail))) & (0x10000000)) != 0) |
> > +			   (((~(*(priv->rxringtail))) & (0x20000000)) != 0);
> 
> Likely these | uses should be ||

I'm not really sure what you mean, do you mean I should change '|' to '||"?
like this
		
           bHwError = (((*(priv->rxringtail)) & (0x00000fff)) == 4080) ||
                      (((*(priv->rxringtail)) & (0x04000000)) != 0) ||
                      (((*(priv->rxringtail)) & (0x08000000)) != 0) ||
                      (((~(*(priv->rxringtail))) & (0x10000000)) != 0) ||
                      (((~(*(priv->rxringtail))) & (0x20000000)) != 0);

> 
> >  		bCRC = ((*(priv->rxringtail)) & (0x00002000)) >> 13;
> >  		bICV = ((*(priv->rxringtail)) & (0x00001000)) >> 12;
> >  		hdr = (struct ieee80211_hdr_4addr *)priv->rxbuffer->buf;
> >  		    fc = le16_to_cpu(hdr->frame_ctl);
> >  		type = WLAN_FC_GET_TYPE(fc);
> >  
> > -			if ((IEEE80211_FTYPE_CTL != type) &&
> > -				(eqMacAddr(priv->ieee80211->current_network.bssid, (fc & IEEE80211_FCTL_TODS) ? hdr->addr1 : (fc & IEEE80211_FCTL_FROMDS) ? hdr->addr2 : hdr->addr3))
> > -				 && (!bHwError) && (!bCRC) && (!bICV)) {
> > +			if ((IEEE80211_FTYPE_CTL != type) && (eqMacAddr(priv->ieee80211->current_network.bssid,
> > +			    (fc & IEEE80211_FCTL_TODS) ? hdr->addr1 : (fc & IEEE80211_FCTL_FROMDS) ? hdr->addr2 : hdr->addr3))
> > +			    && (!bHwError) && (!bCRC) && (!bICV)) {
> 
> This is difficult to read and could be better written
> removing unnecessary parentheses and making the egMacAddr
> clearer as a function/macro call:
> 
> 			if (IEEE80211_FTYPE_CTL != type &&
> 			    eqMacAddr(priv->ieee80211->current_network.bssid,
> 				      fc & IEEE80211_FCTL_TODS ? hdr->addr1 :
> 				      fc & IEEE80211_FCTL_FROMDS ? hdr->addr2 :
> 				      hdr->addr3) &&
> 			    !bHwError &&
> 			    !bCRC &&
> 			    !bICV)
> 
> It might be better to reshuffle the test order too:
> 			if (IEEE80211_FTYPE_CTL != type &&
> 			   !bHwError && bCRC && !bICV &&
> 			    eqMacAddr(priv->ieee80211->current_network.bssid,
> 				      fc & IEEE80211_FCTL_TODS ? hdr->addr1 :
> 				      fc & IEEE80211_FCTL_FROMDS ? hdr->addr2 :
> 				      hdr->addr3))
> 
> etc...

That does look much cleaner, It never occurred to me that I can do that.

Thanks for your help, I'm really trying to do better, I will have this fix up tomorrow for another review.
