Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0FAH1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 03:27:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44602
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028Ab0FAH1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 03:27:12 -0400
Date: Tue, 01 Jun 2010 00:27:21 -0700 (PDT)
Message-Id: <20100601.002721.184817854.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: julia@diku.dk, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
       yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ipv6: get rid of ipip6_prl_lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1275282295.2472.34.camel@edumazet-laptop>
References: <1275252912.2472.23.camel@edumazet-laptop>
	<Pine.LNX.4.64.1005302303180.19253@ask.diku.dk>
	<1275282295.2472.34.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 31 May 2010 07:04:55 +0200

> [PATCH] ipv6: get rid of ipip6_prl_lock
> 
> As noticed by Julia Lawall, ipip6_tunnel_add_prl() incorrectly calls 
> kzallloc(..., GFP_KERNEL) while a spinlock is held. She provided
> a patch to use GFP_ATOMIC instead.
> 
> One possibility would be to convert this spinlock to a mutex, or
> preallocate the thing before taking the lock.
> 
> After RCU conversion, it appears we dont need this lock, since 
> caller already holds RTNL
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks everyone.
