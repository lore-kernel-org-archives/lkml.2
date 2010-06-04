Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0FDQQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 12:16:11 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:44788
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781Ab0FDQQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 12:16:10 -0400
Date: Fri, 4 Jun 2010 18:16:44 +0200
From: Michael Guntsche <mike@it-loops.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [2.6.35-rc1] page alloc failure order:1, mode:0x4020
Message-ID: <20100604161644.GA98048@trillian.local>
References: <20100604092025.GA96690@trillian.comsick.at>
 <1275656014.2482.169.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275656014.2482.169.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010.06.04 14:53:34 , Eric Dumazet wrote:
> order-1 allocations are unfortunate, since this hardware should use
> order-0 ones if possible, and it seems it was its goal.
> 
> 3872 (0xF20) comes from 
<snip>
> 
> 1) Maybe rx_bufsize should not include the roundup() since 
> ath_rxbuf_alloc() also do an alignment adjustment ?
> 
> 2) We should try to reduce skb_shared_info by four bytes.
> 
> Could you try this patch ?
> 
> 
> We make sure rx_bufsize + various overhead <= PAGE_SIZE
> But I am not sure its legal for the hardware...

I applied the patch recompiled and run it on the routerboard, trying
to trigger the bug again.

Kind regards,
Michael
