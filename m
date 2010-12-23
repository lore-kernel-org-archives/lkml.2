Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0LWRcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 12:32:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42482
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753355Ab0LWRcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 12:32:41 -0500
Date: Thu, 23 Dec 2010 09:33:11 -0800 (PST)
Message-Id: <20101223.093311.226768777.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: renton@renton.name, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.36.2 - loop on read /proc/net/tcp
From: David Miller <davem@davemloft.net>
In-Reply-To: <1293080846.2679.41.camel@edumazet-laptop>
References: <20101222134343.GC19998@beaver.vrungel.ru>
	<1293080846.2679.41.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 23 Dec 2010 06:07:26 +0100

> [PATCH] tcp: fix listening_get_next()
> 
> Alexey Vlasov found /proc/net/tcp could sometime loop and display
> millions of sockets in LISTEN state.
> 
> In 2.6.29, when we converted TCP hash tables to RCU, we left two
> sk_next() calls in listening_get_next().
> 
> We must instead use sk_nulls_next() to properly detect an end of chain.
> 
> Reported-by: Alexey Vlasov <renton@renton.name>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks everyone.
