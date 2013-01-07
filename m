Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3AGE7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 23:59:44 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38006 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3AGE7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 23:59:42 -0500
Date: Sun, 06 Jan 2013 20:59:39 -0800 (PST)
Message-Id: <20130106.205939.1265185319066155577.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: w@1wt.eu, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: fix MSG_SENDPAGE_NOTLAST logic
From: David Miller <davem@davemloft.net>
In-Reply-To: <1357532509.6919.1715.camel@edumazet-glaptop>
References: <1357501171.6919.650.camel@edumazet-glaptop>
	<20130106195359.GN16031@1wt.eu>
	<1357532509.6919.1715.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 06 Jan 2013 20:21:49 -0800

> From: Eric Dumazet <edumazet@google.com>
> 
> commit 35f9c09fe9c72e (tcp: tcp_sendpages() should call tcp_push() once)
> added an internal flag : MSG_SENDPAGE_NOTLAST meant to be set on all
> frags but the last one for a splice() call.
> 
> The condition used to set the flag in pipe_to_sendpage() relied on
> splice() user passing the exact number of bytes present in the pipe,
> or a smaller one.
> 
> But some programs pass an arbitrary high value, and the test fails.
> 
> The effect of this bug is a lack of tcp_push() at the end of a
> splice(pipe -> socket) call, and possibly very slow or erratic TCP
> sessions.
> 
> We should both test sd->total_len and fact that another fragment
> is in the pipe (pipe->nrbufs > 1)
> 
> Many thanks to Willy for providing very clear bug report, bisection
> and test programs.
> 
> Reported-by: Willy Tarreau <w@1wt.eu>
> Bisected-by: Willy Tarreau <w@1wt.eu>
> Tested-by: Willy Tarreau <w@1wt.eu>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks everyone.
