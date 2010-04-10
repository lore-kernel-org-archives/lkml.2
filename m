Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037Ab0DJFNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 01:13:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35148
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784Ab0DJFNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 01:13:07 -0400
Date: Fri, 09 Apr 2010 22:13:07 -0700 (PDT)
Message-Id: <20100409.221307.246951787.davem@davemloft.net>
To: cristiklein@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: add setsockopt to disable slow start after idle
From: David Miller <davem@davemloft.net>
In-Reply-To: <1270863015-19597-1-git-send-email-cristiklein@gmail.com>
References: <1270863015-19597-1-git-send-email-cristiklein@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cristian KLEIN <cristiklein@gmail.com>
Date: Sat, 10 Apr 2010 03:30:15 +0200

> Allows user-space to override the sysctl
> net.ipv4.tcp_slow_start_after_idle, on a per-socket bases, using
> setsockopt().
> 
> Slow start after idle can harm some scientific applications which
> interleave computation and communication. Assume we have an iterative
> applications, each iteration consisting of a computation and a
> communication phase. If the computation phase takes long enough (i.e.
> more that 2*RTT), the communication phase will always slow start and
> might never reach the wire speed.
> 
> This patch allows each application to disable slow start after idle,
> just like we allow delay-sensitive applications (e.g. telnet, SSH) to
> disable NAGLE.
> 
> Signed-off-by: Cristian KLEIN <cristiklein@gmail.com>

We specifically did not add a socket option for this facility.

It is a very dangerous option to enable, and depends deeply
upon the characteristics of your network and the paths by
which remote hosts are reached.

Therefore, only the system administrator can determine whether it is
safe to enable this, and that's why it can only be changed via sysctl.
Lettting arbitrary applications change this aspect of TCP is beyond
dangerous.

I will not be applying this patch.
