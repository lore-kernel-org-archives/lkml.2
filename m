Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab2CFB00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 20:26:26 -0500
Received: from mail.solarflare.com ([216.237.3.220]:27751 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757930Ab2CFB0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 20:26:25 -0500
Message-ID: <1330997177.3022.51.camel@deadeye>
Subject: Re: [PATCH v4] lpc32xx: Added ethernet driver
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Roland Stigge <stigge@antcom.de>, <davem@davemloft.net>,
        <jeffrey.t.kirsher@intel.com>, <alexander.h.duyck@intel.com>,
        <eilong@broadcom.com>, <ian.campbell@citrix.com>,
        <netdev@vger.kernel.org>, <w.sang@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <kevin.wells@nxp.com>,
        <linux-arm-kernel@lists.infradead.org>, <arnd@arndb.de>,
        <baruch@tkos.co.il>, <joe@perches.com>
Date: Tue, 6 Mar 2012 01:26:17 +0000
In-Reply-To: <1330994958.9504.2.camel@edumazet-glaptop>
References: <1330983641-32622-1-git-send-email-stigge@antcom.de>
	 <1330987524.2538.61.camel@bwh-desktop>
	 <1330994958.9504.2.camel@edumazet-glaptop>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18752.005
X-TM-AS-Result: No--12.679300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 16:49 -0800, Eric Dumazet wrote:
> On Mon, 2012-03-05 at 22:45 +0000, Ben Hutchings wrote:
> > On Mon, 2012-03-05 at 22:40 +0100, Roland Stigge wrote:
> > [...]
> 
> ...
> 
> > > +				/* Copy packet from buffer */
> > > +				memcpy(prdbuf,
> > > +					pldat->rx_buff_v[rxconsidx], len);
> > > +
> > > +				/* Pass to upper layer */
> > > +				skb->protocol = eth_type_trans(skb, ndev);
> > > +				netif_rx(skb);
> > > +				ndev->last_rx = jiffies;
> > 
> > Drivers don't need to set last_rx any more.
> 
> Also, a NAPI driver should call netif_receive_skb() instead of
> netif_rx()
> 
> netif_rx() is more expensive because of additional queue, while
> netif_receive_skb() directly calls the upper stacks.

Yes, but not until the poll function is changed to enable IRQs.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

