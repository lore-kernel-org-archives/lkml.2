Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab2CFAt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 19:49:29 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:33365 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab2CFAt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 19:49:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eric.dumazet@gmail.com designates 10.68.232.106 as permitted sender) smtp.mail=eric.dumazet@gmail.com; dkim=pass header.i=eric.dumazet@gmail.com
Subject: Re: [PATCH v4] lpc32xx: Added ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Roland Stigge <stigge@antcom.de>, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, alexander.h.duyck@intel.com,
        eilong@broadcom.com, ian.campbell@citrix.com, netdev@vger.kernel.org,
        w.sang@pengutronix.de, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, baruch@tkos.co.il, joe@perches.com
In-Reply-To: <1330987524.2538.61.camel@bwh-desktop>
References: <1330983641-32622-1-git-send-email-stigge@antcom.de>
	 <1330987524.2538.61.camel@bwh-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Mar 2012 16:49:18 -0800
Message-ID: <1330994958.9504.2.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 22:45 +0000, Ben Hutchings wrote:
> On Mon, 2012-03-05 at 22:40 +0100, Roland Stigge wrote:
> [...]

...

> > +				/* Copy packet from buffer */
> > +				memcpy(prdbuf,
> > +					pldat->rx_buff_v[rxconsidx], len);
> > +
> > +				/* Pass to upper layer */
> > +				skb->protocol = eth_type_trans(skb, ndev);
> > +				netif_rx(skb);
> > +				ndev->last_rx = jiffies;
> 
> Drivers don't need to set last_rx any more.

Also, a NAPI driver should call netif_receive_skb() instead of
netif_rx()

netif_rx() is more expensive because of additional queue, while
netif_receive_skb() directly calls the upper stacks.



