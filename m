Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab2CNEtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 00:49:17 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45083 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753710Ab2CNEtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 00:49:16 -0400
Message-ID: <1331700555.27389.51.camel@joe2Laptop>
Subject: Re: [PATCH] Staging: rtl8187se: r8180_core.c: Fix coding style issue
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Miller <amiller@amilx.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 13 Mar 2012 21:49:15 -0700
In-Reply-To: <4F601C02.8070909@gmail.com>
References: <1331686689-6763-1-git-send-email-amiller@amilx.com>
	 <1331688836.27389.13.camel@joe2Laptop> <4F601C02.8070909@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-14 at 15:18 +1100, Ryan Mallon wrote:
> That's still pretty nasty. Eight lines for an if expression! It took me
> a couple of glances to realise that there were only two arguments to
> eqMacAddr. If you add some temporary variables then you can make the
> code a lot more sane, without making it overly verbose:
> 
> 	u8 *addr, *bssid = priv->ieee80211->current_network.bssid;
> 
> 	if (fc & IEEE80211_FCTL_TODS)
> 		addr = hdr->addr1;
> 	else if (fc & IEEE80211_FCTL_FROMDS)
> 		addr = hdr->addr2;
> 	else
> 		addr = hdr->addr3;
> 
> 	if (!bHwError && !bCRC && !bICV &&
> 	    type != IEEE80211_FTYPE_CTL && eqMacAddr(bssid, addr)) {
> 		...
> 
> Also note that the whole if block is indented one too many tab stops.
> Would be best to fix that in a separate patch though. If you fix that
> first, then you will have more horizontal space to re-organise the
> expression inside the if :-).

Yeah, what Ryan said.  Clarity is good.
You might separate the addr and bssid declarations
into 2 lines though...

