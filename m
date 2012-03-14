Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030377Ab2CNCM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:12:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36137 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030293Ab2CNCM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:12:27 -0400
Message-ID: <1331691146.27389.20.camel@joe2Laptop>
Subject: Re: [PATCH] Staging: rtl8187se: r8180_core.c: Fix coding style issue
From: Joe Perches <joe@perches.com>
To: Andrew Miller <amiller@amilx.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 13 Mar 2012 19:12:26 -0700
In-Reply-To: <20120314014949.GB7156@iron>
References: <1331686689-6763-1-git-send-email-amiller@amilx.com>
	 <1331688836.27389.13.camel@joe2Laptop> <20120314014949.GB7156@iron>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 21:49 -0400, Andrew Miller wrote:
> On Tue, Mar 13, 2012 at 06:33:56PM -0700, Joe Perches wrote:
> > On Tue, 2012-03-13 at 20:58 -0400, Andrew Miller wrote:
> > > Fix long line coding style issue
> > > Signed-off-by: Andrew Miller <amiller@amilx.com>
> > Please strive for clarity instead of just fixing
> > random 80 char warnings.
> > > diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
> > []
> > > @@ -1607,17 +1609,20 @@ void rtl8180_rx(struct net_device *dev)
> > >  		/* printk("==========================>rx : RXAGC is %d,signalstrength is %d\n",RXAGC,stats.signalstrength); */
> > >  		stats.rssi = priv->wstats.qual.qual = priv->SignalQuality;
> > >  		stats.noise = priv->wstats.qual.noise = 100 - priv->wstats.qual.qual;
> > > -		bHwError = (((*(priv->rxringtail)) & (0x00000fff)) == 4080) | (((*(priv->rxringtail)) & (0x04000000)) != 0)
> > > -			| (((*(priv->rxringtail)) & (0x08000000)) != 0) | (((~(*(priv->rxringtail))) & (0x10000000)) != 0) | (((~(*(priv->rxringtail))) & (0x20000000)) != 0);
> > > +		bHwError = (((*(priv->rxringtail)) & (0x00000fff)) == 4080) |
> > > +			   (((*(priv->rxringtail)) & (0x04000000)) != 0) |
> > > +			   (((*(priv->rxringtail)) & (0x08000000)) != 0) |
> > > +			   (((~(*(priv->rxringtail))) & (0x10000000)) != 0) |
> > > +			   (((~(*(priv->rxringtail))) & (0x20000000)) != 0);
> > Likely these | uses should be ||
> I'm not really sure what you mean, do you mean I should change '|' to '||"?
> like this
>            bHwError = (((*(priv->rxringtail)) & (0x00000fff)) == 4080) ||
>                       (((*(priv->rxringtail)) & (0x04000000)) != 0) ||
>                       (((*(priv->rxringtail)) & (0x08000000)) != 0) ||
>                       (((~(*(priv->rxringtail))) & (0x10000000)) != 0) ||
>                       (((~(*(priv->rxringtail))) & (0x20000000)) != 0);

Yes.

If this bit of code is especially performance sensitive,
there are times when using | instead of || can be an
overall speed improvement.  I haven't looked at this
code before so I don't know what's appropriate here but
using || might be more sensible though possibly slower.

> > It might be better to reshuffle the test order too:
> > 			if (IEEE80211_FTYPE_CTL != type &&
> > 			   !bHwError && bCRC && !bICV &&
> > 			    eqMacAddr(priv->ieee80211->current_network.bssid,
> > 				      fc & IEEE80211_FCTL_TODS ? hdr->addr1 :
> > 				      fc & IEEE80211_FCTL_FROMDS ? hdr->addr2 :
> > 				      hdr->addr3))
> > etc...
> That does look much cleaner, It never occurred to me that I can do that.

Feel empowered to make the code better.  Do what's right.
Don't just correct mindless checkpatch error messages.

cheers, Joe

