Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab2DRUyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:54:18 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41586 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2DRUyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:54:16 -0400
Date: Wed, 18 Apr 2012 16:54:00 -0400 (EDT)
Message-Id: <20120418.165400.980383816074286216.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: a.beregalov@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, marc@merlins.org
Subject: Re: [PATCH] tcp: fix retransmit of partially acked frames
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334780063.2472.352.camel@edumazet-glaptop>
References: <CAA1sL1TN+acPd4NAnFC0soeHzzcJe0ja3_zS5ZkFog11HSDAyA@mail.gmail.com>
	<1334734196.2472.91.camel@edumazet-glaptop>
	<1334780063.2472.352.camel@edumazet-glaptop>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 Apr 2012 13:54:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 18 Apr 2012 22:14:23 +0200

> From: Eric Dumazet <edumazet@google.com>
> 
> Alexander Beregalov reported skb_over_panic errors and provided stack
> trace.
> 
> I occurs commit a21d45726aca (tcp: avoid order-1 allocations on wifi and
> tx path) added a regression, when a retransmit is done after a partial
> ACK.
> 
> tcp_retransmit_skb() tries to aggregate several frames if the first one
> has enough available room to hold the following ones payload. This is
> controlled by /proc/sys/net/ipv4/tcp_retrans_collapse tunable (default :
> enabled)
> 
> Problem is we must make sure _pskb_trim_head() doesnt fool
> skb_availroom() when pulling some bytes from skb (this pull is done when
> receiver ACK part of the frame).
> 
> Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
> Cc: Marc MERLIN <marc@merlins.org>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks.
