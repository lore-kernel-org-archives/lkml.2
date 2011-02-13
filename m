Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1BMXkE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 18:40:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41114 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab1BMXkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 18:40:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: [Bug #28052] [BUG] 2.6.38-rc2: Circular Locking Dependency
Date: Mon, 14 Feb 2011 00:39:43 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
        maciej.rutecki@gmail.com, florian@mickler.org,
        Knut_Petersen@t-online.de
References: <NMZS1i37KEE.A.1eG.6_wVNB@chimera> <8H3lez1sawF.A.OqH.3AxVNB@chimera> <20110213.102124.258125070.davem@davemloft.net>
In-Reply-To: <20110213.102124.258125070.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102140039.43627.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 13, 2011, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Sun, 13 Feb 2011 00:05:18 +0100 (CET)
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28052
> > Subject		: [BUG] 2.6.38-rc2: Circular Locking Dependency
> > Submitter	: Knut Petersen <Knut_Petersen@t-online.de>
> > Date		: 2011-01-24 9:25 (20 days old)
> > Message-ID	: <4D3D45A3.7040809@t-online.de>
> > References	: http://marc.info/?l=linux-kernel&m=129586118515443&w=2
> 
> Fixed by:
> 
> commit 8d3bdbd55a7e2a3f2c148a4830aa26dd682b21c4
> Author: David S. Miller <davem@davemloft.net>
> Date:   Tue Feb 8 15:02:50 2011 -0800
> 
>     net: Fix lockdep regression caused by initializing netdev queues too early.
>     
>     In commit aa9421041128abb4d269ee1dc502ff65fb3b7d69 ("net: init ingress
>     queue") we moved the allocation and lock initialization of the queues
>     into alloc_netdev_mq() since register_netdevice() is way too late.
>     
>     The problem is that dev->type is not setup until the setup()
>     callback is invoked by alloc_netdev_mq(), and the dev->type is
>     what determines the lockdep class to use for the locks in the
>     queues.
>     
>     Fix this by doing the queue allocation after the setup() callback
>     runs.
>     
>     This is safe because the setup() callback is not allowed to make any
>     state changes that need to be undone on error (memory allocations,
>     etc.).  It may, however, make state changes that are undone by
>     free_netdev() (such as netif_napi_add(), which is done by the
>     ipoib driver's setup routine).
>     
>     The previous code also leaked a reference to the &init_net namespace
>     object on RX/TX queue allocation failures.
>     
>     Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks, closing.

Rafael
