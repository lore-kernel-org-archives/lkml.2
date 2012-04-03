Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab2DCCPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:15:12 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43418 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab2DCCPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:15:10 -0400
Subject: Re: [PATCH] phonet: Check input from user before allocating
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: remi@remlab.net, levinsasha928@gmail.com, remi.denis-courmont@nokia.com,
        davej@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120402.215911.1929019308299701014.davem@davemloft.net>
References: <201204022201.41808.remi@remlab.net>
	 <20120402.174006.70116829696492189.davem@davemloft.net>
	 <1333417997.18626.1.camel@edumazet-glaptop>
	 <20120402.215911.1929019308299701014.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Apr 2012 04:15:04 +0200
Message-ID: <1333419304.18626.5.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 21:59 -0400, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Tue, 03 Apr 2012 03:53:17 +0200
> 
> > Not that AF_UNIX does nothing in this respect, it can use order-XX pages
> > for large datagrams.
> > 
> > (I beleve I sent a patch some time ago to address this point)
> 
> Yes, on the datagram side it's a problem.
> 
> For stream AF_UNIX sockets the allocation is capped at SKB_MAX_ALLOC
> which evaluates to an order 2 page.
> 
> Overall, AF_UNIX ought to be easy to deal with since all of the
> routines that copy data between userspace and SKBs can handle
> segmented SKBs and thus most of the work is converting over to
> sock_alloc_send_pskb() and setting data_len how we set the normal
> length of sock_alloc_skb_skb() currently.
> 
> Anyways, feel free to resubmit your patch.

This was indeed a basic patch, but it probably can lower raw performance
on some apps, (if memory frag is not an issue) so I need to bench it. 


Any idea of a representative benchmark in dgram af_unix ?

http://patchwork.ozlabs.org/patch/114103/

I'll respin it with proper performance resuts.



