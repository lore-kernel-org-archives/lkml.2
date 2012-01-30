Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab2A3Rpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:45:44 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40039 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab2A3Rpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:45:43 -0500
Date: Mon, 30 Jan 2012 12:45:37 -0500 (EST)
Message-Id: <20120130.124537.2246327212488304490.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: nickm@freehaven.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        himeraster@gmail.com
Subject: Re: [PATCH] af_unix: fix EPOLLET regression for stream sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327803063.2805.14.camel@edumazet-laptop>
References: <CAKDKvuzH14AZjDG3WSdrf5VtmiUgG0Y+EaC83qqSd0VFKzyitg@mail.gmail.com>
	<1327686822.3159.3.camel@edumazet-laptop>
	<1327803063.2805.14.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 30 Jan 2012 09:45:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 29 Jan 2012 03:11:03 +0100

> Commit 0884d7aa24 (AF_UNIX: Fix poll blocking problem when reading from
> a stream socket) added a regression for epoll() in Edge Triggered mode
> (EPOLLET)
> 
> Appropriate fix is to use skb_peek()/skb_unlink() instead of
> skb_dequeue(), and only call skb_unlink() when skb is fully consumed.
> 
> This remove the need to requeue a partial skb into sk_receive_queue head
> and the extra sk->sk_data_ready() calls that added the regression.
> 
> This is safe because once skb is given to sk_receive_queue, it is not
> modified by a writer, and readers are serialized by u->readlock mutex.
> 
> This also reduce number of spinlock acquisition for small reads or
> MSG_PEEK users so should improve overall performance.
> 
> Reported-by: Nick Mathewson <nickm@freehaven.net>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Alexey Moiseytsev <himeraster@gmail.com>

Applied and queued up for -stable, thanks.
