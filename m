Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab2L0VcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 16:32:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44846 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2L0VcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 16:32:11 -0500
Date: Thu, 27 Dec 2012 13:32:09 -0800 (PST)
Message-Id: <20121227.133209.1785109551425933956.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: Larry.Finger@lwfinger.net, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] forcedeth: Fix WARNINGS that result when DMA mapping
 is not checked
From: David Miller <davem@davemloft.net>
In-Reply-To: <1356642209.30414.1411.camel@edumazet-glaptop>
References: <1356638715.30414.1349.camel@edumazet-glaptop>
	<50DCB1D9.50906@lwfinger.net>
	<1356642209.30414.1411.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 27 Dec 2012 13:03:29 -0800

> On Thu, 2012-12-27 at 14:38 -0600, Larry Finger wrote:
>> On 12/27/2012 02:05 PM, Eric Dumazet wrote:
>> > On Thu, 2012-12-27 at 13:42 -0600, Larry Finger wrote:
> 
>> >> +		if (pci_dma_mapping_error(np->pci_dev,
>> >> +					  np->put_tx_ctx->dma))
>> >> +			return NETDEV_TX_BUSY;
>> >
>> > Really this is not going to work very well : caller will call this in a
>> > loop.
>> 
>> Any suggestions on what value should be returned, or does the caller need to be 
>> modified?
> 
> NETDEV_TX_BUSY is really obsolete
> 
> Documentation/networking/driver.txt
> 
> In case of mapping error, I would drop the packet.

Agreed.
