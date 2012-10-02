Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab2JBXuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:50:37 -0400
Received: from ozlabs.org ([203.10.76.45]:52744 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757017Ab2JBXud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:50:33 -0400
From: Michael Neuling <mikey@neuling.org>
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: Tree for Oct 2 (ipoib_netlink.c)
In-reply-to: <506B3FE4.9040407@xenotime.net>
References: <20121002163229.d377074dc8f6c029428faeaa@canb.auug.org.au> <506B3FE4.9040407@xenotime.net>
Comments: In-reply-to Randy Dunlap <rdunlap@xenotime.net>
   message dated "Tue, 02 Oct 2012 12:26:28 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Wed, 03 Oct 2012 09:50:31 +1000
Message-ID: <10635.1349221831@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> on x86_64:
> 
> drivers/built-in.o: In function `ipoib_changelink':
> ipoib_netlink.c:(.text+0x6a5fc9): undefined reference to `ipoib_set_mode'
> ipoib_netlink.c:(.text+0x6a5fe3): undefined reference to `ipoib_set_mode'

Happens on powerpc too with ppc64e_defconfig compiling modules.

Reverting this fixes it:
  862096a IB/ipoib: Add more rtnl_link_ops callbacks

Adding patch owners and committer to CC.

Mikey
