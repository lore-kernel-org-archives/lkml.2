Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab1HYPlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:41:22 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40117 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858Ab1HYPlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:41:20 -0400
X-Sasl-enc: Cj8NkON2MVfDWJecOk8DGwghXJG0WOfnkd1yy7tMGJJq 1314286879
Date: Thu, 25 Aug 2011 08:39:07 -0700
From: Greg KH <greg@kroah.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, wlanfae <wlanfae@realtek.com>,
        Jiri Pirko <jpirko@redhat.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20110825153907.GA31018@kroah.com>
References: <20110825150209.5d159c549777290de4644bcf@canb.auug.org.au>
 <4E55DA8C.10102@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E55DA8C.10102@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 12:15:56AM -0500, Larry Finger wrote:
> On 08/25/2011 12:02 AM, Stephen Rothwell wrote:
> >Hi Greg,
> >
> >After merging the staging tree, today's linux-next build (x86_64
> >allmodconfig) failed like this:
> >
> >drivers/staging/rtl8192e/rtl_core.c:2917:2: error: unknown field 'ndo_set_multicast_list' specified in initializer
> >
> >Caused by commit 94a799425eee ("From: wlanfae<wlanfae@realtek.com>" -
> >really "[PATCH 1/8] rtl8192e: Import new version of driver from realtek"
> >Larry, that patch was badly imported ...) interacting with commit
> >b81693d9149c ("net: remove ndo_set_multicast_list callback") from the net
> >tree.
> >
> >I applied the following patch (which seems to be what was done to the
> >other drivers in the net tree - there is probably more required):
> >
> >From: Stephen Rothwell<sfr@canb.auug.org.au>
> >Date: Thu, 25 Aug 2011 14:57:55 +1000
> >Subject: [PATCH] rtl8192e: update for ndo_set_multicast_list removal.
> >
> >Signed-off-by: Stephen Rothwell<sfr@canb.auug.org.au>
> >---
> >  drivers/staging/rtl8192e/rtl_core.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> >diff --git a/drivers/staging/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl_core.c
> >index f8a13d9..b38f626 100644
> >--- a/drivers/staging/rtl8192e/rtl_core.c
> >+++ b/drivers/staging/rtl8192e/rtl_core.c
> >@@ -2914,7 +2914,7 @@ static const struct net_device_ops rtl8192_netdev_ops = {
> >  	.ndo_stop = rtl8192_close,
> >  	.ndo_tx_timeout = rtl8192_tx_timeout,
> >  	.ndo_do_ioctl = rtl8192_ioctl,
> >-	.ndo_set_multicast_list = r8192_set_multicast,
> >+	.ndo_set_rx_mode = r8192_set_multicast,
> >  	.ndo_set_mac_address = r8192_set_mac_adr,
> >  	.ndo_validate_addr = eth_validate_addr,
> >  	.ndo_change_mtu = eth_change_mtu,
> 
> Stephan,
> 
> Thanks for the notice. It seems that commit b81693d9149c had not
> made it into my copy of staging. I'll look into the issue.

It wouldn't ever make it there, as that's coming from the net-next tree,
so this will have to wait until stuff merges together in Linus's tree.

thanks,

greg k-h
