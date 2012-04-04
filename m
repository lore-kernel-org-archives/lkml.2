Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab2DDJtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 05:49:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34604 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab2DDJtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 05:49:02 -0400
Subject: Re: Commit 8ef874bfc7296fa206eea2ad1e8a426f576bf6f6 has broken ss
 command
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: slash@ac.auone-net.jp, netdev@vger.kernel.org, xemul@parallels.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1333532694.18626.563.camel@edumazet-glaptop>
References: <20120404090312.1B68C6AC03E@msa102.auone-net.jp>
	 <1333530463.18626.545.camel@edumazet-glaptop>
	 <20120404.052423.998527504342669775.davem@davemloft.net>
	 <1333532694.18626.563.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Apr 2012 11:48:57 +0200
Message-ID: <1333532937.18626.565.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 11:44 +0200, Eric Dumazet wrote:
> On Wed, 2012-04-04 at 05:24 -0400, David Miller wrote:
> > From: Eric Dumazet <eric.dumazet@gmail.com>
> > Date: Wed, 04 Apr 2012 11:07:43 +0200
> > 
> > > On Wed, 2012-04-04 at 18:03 +0900, Kusanagi Kouichi wrote:
> > >> Since commit 8ef874bfc7296fa206eea2ad1e8a426f576bf6f6 ("sock_diag:
> > >> Move the sock_ code to net/core/"), ss command from iproute package
> > >> doesn't work if INET_DIAG is not enabled.
> > >> 
> > >> $ ss
> > >> State       Recv-Q Send-Q                                             Local Address:Port                                                 Peer Address:Port
> > >> TCPDIAG answers: Operation not supported
> > >> --
> > > 
> > > Try to update your iproute2 package ?
> > 
> > Well, he doesn't INET_DIAG enabled in his kernel, so no matter what
> > iproute2 version he uses it won't work :-)
> 
> iproute2 misc/ss.c has a fallback using /proc/net/tcp
> 
> Dont know when this broke.
> 
> I guess we should fix ss to cope INET_DIAG being disabled.
> 
> tcp_show_netlink() should return -1 instead of 0
> 

Kusanagi Kouichi is right. Commit 8ef874bfc72 apparently changed things
since socket(AF_NETLINK, SOCK_RAW, NETINK_INET_DIAG) doesnt fail
anymore...



