Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab1AXWl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:41:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49609
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342Ab1AXWlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:41:25 -0500
Date: Mon, 24 Jan 2011 14:42:00 -0800 (PST)
Message-Id: <20110124.144200.112610203.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: runningdoglackey@yahoo.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, therbert@google.com
Subject: Re: Problems with /proc/net/tcp6 - possible bug - ipv6
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295709344.2651.55.camel@edumazet-laptop>
References: <702550.61465.qm@web63902.mail.re1.yahoo.com>
	<1295686781.2609.37.camel@edumazet-laptop>
	<1295709344.2651.55.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sat, 22 Jan 2011 16:15:44 +0100

> [PATCH] tcp: fix bug in listening_get_next()
> 
> commit a8b690f98baf9fb19 (tcp: Fix slowness in read /proc/net/tcp)
> introduced a bug in handling of SYN_RECV sockets.
> 
> st->offset represents number of sockets found since beginning of
> listening_hash[st->bucket].
> 
> We should not reset st->offset when iterating through
> syn_table[st->sbucket], or else if more than ~25 sockets (if
> PAGE_SIZE=4096) are in SYN_RECV state, we exit from listening_get_next()
> with a too small st->offset
> 
> Next time we enter tcp_seek_last_pos(), we are not able to seek past
> already found sockets.
> 
> Reported-by: PK <runningdoglackey@yahoo.com>
> CC: Tom Herbert <therbert@google.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied and queued up for -stable, thanks Eric.
